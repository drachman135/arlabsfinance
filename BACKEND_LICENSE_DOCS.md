# Panduan Backend: Sistem Lisensi (License Gateway)

Dokumen ini berisi kode SQL dan Edge Function yang diperlukan di sisi Supabase untuk mengaktifkan sistem aktivasi lisensi (*License Gateway*).

## 1. Database Schema (SQL)
Silakan jalankan *script* SQL di bawah ini pada SQL Editor di *dashboard* Supabase Anda. Ini akan membuat tabel untuk menyimpan *License Keys*.

```sql
-- Tabel Master Lisensi
CREATE TABLE IF NOT EXISTS public.license_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key_string TEXT UNIQUE NOT NULL,       -- Contoh: AR-GOLD-2024
    package_name TEXT NOT NULL,            -- Contoh: com.ardevlabs.finance
    license_type TEXT DEFAULT 'TRIAL',     -- TRIAL, MONTHLY, LIFETIME
    status TEXT DEFAULT 'PENDING',         -- PENDING, ACTIVE, BLOCKED, EXPIRED
    device_id TEXT,                        -- Akan diisi saat aktivasi (Device Binding)
    activation_date TIMESTAMPTZ,
    expiration_date TIMESTAMPTZ,           -- NULL jika LIFETIME
    max_devices INT DEFAULT 1,             -- Batas jumlah perangkat per lisensi
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexing untuk pencarian cepat
CREATE INDEX idx_license_key_string ON public.license_keys(key_string);

-- Izinkan akses read-only untuk admin saja (opsional)
ALTER TABLE license_keys ENABLE ROW LEVEL SECURITY;
```

---

## 2. Supabase Edge Function (`activate-license`)
Buatlah fungsi baru di Supabase Edge Functions dengan nama `activate-license`, lalu tempelkan (*paste*) kode Typescript di bawah ini. Pastikan Anda meng-*expose* `SUPABASE_URL` dan `SUPABASE_SERVICE_ROLE_KEY` pada *Environment Variables* Edge Function tersebut.

```typescript
// Deno / Supabase Edge Function Logic
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  // CORS Headers (jika dipanggil dari Web Browser)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    }})
  }

  const headers = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
  const { license_key, device_id, package_name } = await req.json()

  // 1. Inisialisasi Database
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '' // Gunakan service role untuk bypass RLS
  )

  // 2. Cari Lisensi di Tabel
  const { data: license, error } = await supabase
    .from('license_keys')
    .select('*')
    .eq('key_string', license_key)
    .single()

  if (!license) {
    return new Response(JSON.stringify({ success: false, message: "Kunci lisensi tidak valid" }), { status: 404, headers })
  }

  // 3. Validasi Package Name (Cegah lisensi POS dipakai di Finance)
  if (license.package_name !== package_name) {
    return new Response(JSON.stringify({ success: false, message: "Lisensi ini tidak ditujukan untuk aplikasi ini" }), { status: 403, headers })
  }

  // 4. Logika Binding Perangkat
  if (license.device_id && license.device_id !== device_id) {
    return new Response(JSON.stringify({ success: false, message: "Lisensi sudah terikat di perangkat lain" }), { status: 403, headers })
  }

  // 5. Update Status ke ACTIVE dan Simpan Device ID
  const { error: updateError } = await supabase
    .from('license_keys')
    .update({ 
      status: 'ACTIVE', 
      device_id: device_id, 
      activation_date: new Date().toISOString() 
    })
    .eq('id', license.id)

  if (updateError) {
    return new Response(JSON.stringify({ success: false, message: "Gagal menyimpan data aktivasi" }), { status: 500, headers })
  }

  // (Opsional) Mengambil nama dari tabel customers berdasarkan ID / Kode yang dipakai untuk aktivasi
  // const { data: customer } = await supabase.from('customers').select('id, name').eq('id', license_key).single()
  // const clientId = customer?.id || license_key
  // const clientName = customer?.name || "Klien ArLABS"

  // 6. Kirim Response ke Android/React
  return new Response(
    JSON.stringify({
      success: true,
      status: "ACTIVE",
      license_type: license.license_type,
      expiration_date: license.expiration_date,
      client_id: license_key, // Wajib dikirim agar Dashboard bisa query data yang benar (ID yang digunakan untuk aktivasi)
      client_name: "Klien ArLABS", // Nama akan di-fetch otomatis oleh Dashboard dari tabel customers
      message: "Aktivasi Berhasil!"
    }),
    { headers }
  )
})
```

---

## 3. Database Schema untuk Dashboard

### V2. Skema Mutasi Kasbon UMKM

Untuk mendukung sistem piutang gaya warung/UMKM yang mencatat setiap penambahan hutang dan pembayaran cicilan (tanpa jatuh tempo ketat), kita menggunakan tabel `kasbon_ledger`.

Jalankan perintah SQL ini untuk membuat tabel Kasbon dan **MENGHAPUS** tabel lama (`recent_transactions` & `financial_summaries`) yang sudah tidak relevan agar *database* Anda bersih:

```sql
-- 1. Hapus tabel lama yang tidak digunakan (Aman untuk dihapus khusus proyek ini)
DROP TABLE IF EXISTS public.recent_transactions;
DROP TABLE IF EXISTS public.financial_summaries;

-- 2. Buat tabel Buku Kasbon (Ledger)
CREATE TABLE IF NOT EXISTS public.kasbon_ledger (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id TEXT NOT NULL,               -- ID Klien (license_key)
    description TEXT NOT NULL,             -- Contoh: 'Nasi Rames + Es Teh', 'Cicil Kasbon'
    type TEXT NOT NULL,                    -- 'DEBT' (Hutang Bertambah) atau 'PAYMENT' (Hutang Dibayar)
    amount NUMERIC DEFAULT 0,              -- Nominal uang
    transaction_date TIMESTAMPTZ DEFAULT now()
);

-- Mengizinkan akses (Opsional: Jika RLS diaktifkan, ubah sesuai policy)
ALTER TABLE public.kasbon_ledger DISABLE ROW LEVEL SECURITY;
```

> **Cara Kerjanya:** Saat klien berhutang, aplikasi Owner akan melakukan `INSERT` dengan tipe `DEBT`. Saat klien membayar/mencicil, aplikasi Owner akan melakukan `INSERT` dengan tipe `PAYMENT`. Sisa hutang dihitung otomatis oleh aplikasi Klien dengan rumus: `(Total DEBT) - (Total PAYMENT)`.

-- Tabel Ruang Obrolan (Chat Rooms) - Jika belum ada
CREATE TABLE IF NOT EXISTS public.chat_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id TEXT NOT NULL UNIQUE,        -- 1 klien = 1 room chat dengan owner
    unread_count INT DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Tabel Pesan (Chat Messages)
CREATE TABLE IF NOT EXISTS public.chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
    sender_type TEXT NOT NULL,             -- 'CLIENT' atau 'OWNER'
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    is_read BOOLEAN DEFAULT false,
    attachment_url TEXT                    -- URL gambar jika ada lampiran
);

-- JALANKAN INI JIKA TABEL chat_messages SUDAH TERLANJUR DIBUAT SEBELUMNYA:
-- ALTER TABLE public.chat_messages ADD COLUMN attachment_url TEXT;
-- ALTER TABLE public.chat_messages ALTER COLUMN message DROP NOT NULL;
```

> **Catatan Penting Realtime:** Pastikan Anda menyalakan Realtime (Replication) untuk tabel `chat_messages` di dashboard Supabase Anda (Database > Replication > centang `chat_messages`) agar fitur *chat* bisa berjalan secara *real-time*!

### 2. Pengaturan Supabase Storage (Untuk Lampiran Gambar)

Jika sebelumnya Anda mengalami **Gagal Mengunggah Gambar**, itu karena Supabase memblokirnya secara otomatis. Jalankan **SQL di bawah ini** di SQL Editor Supabase Anda untuk membuka aksesnya:

```sql
-- Mengizinkan Klien membaca (melihat) gambar di bucket chat_attachments
CREATE POLICY "Public Select" ON storage.objects FOR SELECT TO public USING (bucket_id = 'chat_attachments');

-- Mengizinkan Klien mengunggah (insert) gambar ke bucket chat_attachments
CREATE POLICY "Public Uploads" ON storage.objects FOR INSERT TO public WITH CHECK (bucket_id = 'chat_attachments');
```

*(Catatan: Pastikan Anda sudah membuat bucket `chat_attachments` dan mengaturnya sebagai **Public** di menu Storage).*
