import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const MAX_SESSIONS = 2; // Maksimal perangkat per lisensi

serve(async (req) => {
  // CORS Headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    }})
  }

  const headers = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
  const { license_key, device_id, package_name, device_info = 'Unknown Device' } = await req.json()

  // 1. Inisialisasi Database
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '' // Service role
  )

  // 2. Cari Lisensi di Tabel
  const { data: license, error } = await supabase
    .from('licenses')
    .select('*')
    .eq('license_key', license_key)
    .single()

  if (error && error.code !== 'PGRST116') {
      return new Response(JSON.stringify({ success: false, message: `Database error: ${error.message} (${error.code})` }), { status: 500, headers })
  }

  if (!license) {
    return new Response(JSON.stringify({ success: false, message: "Kunci lisensi tidak valid" }), { status: 404, headers })
  }

  // 3. Validasi Package Name/Application (Opsional, sesuaikan dengan nama kolom yang ada)
  // Jika tabel licenses menggunakan application_id atau tidak butuh validasi, abaikan saja pengecekan package_name
  // if (license.package_name && license.package_name !== package_name) {
  //   return new Response(JSON.stringify({ success: false, message: "Lisensi ini tidak ditujukan untuk aplikasi ini" }), { status: 403, headers })
  // }

  // 4. Manajemen Sesi (DIMATIKAN SEMENTARA: Semua login langsung ACTIVE)
  // FITUR SALING TABRAK (Auto-Kick) KHUSUS com.ardevlabs.finance
  if (package_name === 'com.ardevlabs.finance') {
      // Cabut semua sesi yang ada sebelumnya untuk lisensi ini
      await supabase.from('license_sessions').update({ status: 'REVOKE' }).eq('license_key', license_key);
  }

  const { data: newSession, error: upsertError } = await supabase
      .from('license_sessions')
      .upsert({
          license_key: license_key,
          device_id: device_id,
          device_info: device_info,
          status: 'ACTIVE'
      }, { onConflict: 'license_key,device_id' })
      .select()
      .single();

  if (upsertError) {
      return new Response(JSON.stringify({ success: false, message: `Gagal mencatat sesi: ${upsertError.message}` }), { status: 500, headers })
  }

  // Pastikan licenses juga statusnya diupdate jika masih PENDING
  if (license.status === 'PENDING' || license.status === 'NOT_ACTIVATED') {
      await supabase.from('licenses').update({ status: 'ACTIVE', activated_at: new Date().toISOString() }).eq('id', license.id);
  }

  return new Response(
      JSON.stringify({
          success: true,
          status: "ACTIVE",
          session_id: newSession.id,
          license_type: license.license_type,
          expiration_date: license.expired_at || license.expires_at,
          client_id: license.customer_id || license_key,
          client_name: license.customer_name || "Klien ArLABS",
          message: "Aktivasi Berhasil!"
      }),
      { headers }
  )
})
