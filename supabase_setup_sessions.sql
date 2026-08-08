-- 1. Hapus tabel lama beserta constraint-nya (jika ada)
DROP TABLE IF EXISTS public.license_sessions CASCADE;

-- 2. Buat tabel license_sessions baru
CREATE TABLE public.license_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    license_key TEXT NOT NULL, 
    device_id TEXT NOT NULL,
    device_info TEXT, -- Contoh: "Chrome on Windows", "Mobile App"
    status TEXT DEFAULT 'PENDING', -- PENDING, ACTIVE, REJECTED
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(license_key, device_id)
);

-- 3. Aktifkan Row Level Security (RLS) - Opsional, biarkan disable untuk kemudahan jika tidak ada otentikasi user
ALTER TABLE public.license_sessions DISABLE ROW LEVEL SECURITY;

-- 4. Tambahkan ke Realtime (Abaikan jika gagal / sudah ada)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' 
    AND tablename = 'license_sessions'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.license_sessions;
  END IF;
END
$$;
