import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    }})
  }

  const headers = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
  
  try {
    const { action, session_id, license_key } = await req.json()
    // action: 'APPROVE', 'REJECT', 'REVOKE'

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '' 
    )

    if (action === 'APPROVE') {
      const { error } = await supabase
        .from('license_sessions')
        .update({ status: 'ACTIVE' })
        .eq('id', session_id)
        .eq('license_key', license_key)
        
      if (error) throw error;
      return new Response(JSON.stringify({ success: true, message: "Sesi disetujui" }), { headers })
    }
    
    if (action === 'REJECT' || action === 'REVOKE') {
      const { error } = await supabase
        .from('license_sessions')
        .delete() // Hapus sesi sepenuhnya jika ditolak atau di-revoke
        .eq('id', session_id)
        .eq('license_key', license_key)
        
      if (error) throw error;
      return new Response(JSON.stringify({ success: true, message: "Sesi dihapus" }), { headers })
    }
    
    return new Response(JSON.stringify({ success: false, message: "Aksi tidak dikenal" }), { status: 400, headers })

  } catch (err: any) {
    return new Response(JSON.stringify({ success: false, message: err.message }), { status: 500, headers })
  }
})
