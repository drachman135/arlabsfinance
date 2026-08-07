import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { JWT } from "https://esm.sh/google-auth-library@9";

// 1. Ambil Service Account JSON dari Environment Variables
const serviceAccountRaw = Deno.env.get('FIREBASE_SERVICE_ACCOUNT');
if (!serviceAccountRaw) throw new Error("Missing FIREBASE_SERVICE_ACCOUNT");
const serviceAccount = JSON.parse(serviceAccountRaw);

// 2. Fungsi Auth ke Firebase
async function getFirebaseAccessToken() {
  const jwtClient = new JWT({
    email: serviceAccount.client_email,
    key: serviceAccount.private_key,
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
  });
  const tokens = await jwtClient.authorize();
  return tokens.access_token;
}

// 3. Listener Utama Webhook
serve(async (req) => {
  try {
    const payload = await req.json();
    const { room_id, sender_type, message } = payload.record;

    // Abaikan jika yang mengirim pesan adalah CLIENT (kita hanya kirim notifikasi ke klien jika OWNER yang balas)
    if (sender_type === 'CLIENT') {
      return new Response("Notifikasi diabaikan: Pengirim bukan Owner", { status: 200 });
    }

    // Inisialisasi Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Cari client_id berdasarkan room_id
    const { data: roomData } = await supabase.from('chat_rooms').select('client_id').eq('id', room_id).single();
    if (!roomData) return new Response("Room tidak ditemukan", { status: 404 });

    // Cari fcm_token klien dari tabel licenses
    const { data: licenseData } = await supabase.from('licenses').select('fcm_token').eq('license_key', roomData.client_id).single();
    const fcmToken = licenseData?.fcm_token;
    if (!fcmToken) return new Response("Klien belum punya FCM Token", { status: 200 });

    // Dapatkan Access Token & Kirim ke Firebase
    const accessToken = await getFirebaseAccessToken();
    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`;

    const fcmPayload = {
      message: {
        token: fcmToken,
        notification: {
          title: "Pesan Baru",
          body: message,
        },
        data: {
          route: "/chat" // Akan membuat klien pindah ke halaman chat saat notif ditekan
        }
      }
    };

    const response = await fetch(fcmUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify(fcmPayload)
    });

    const result = await response.json();
    return new Response(JSON.stringify(result), { headers: { "Content-Type": "application/json" } });
  } catch (error) {
    console.error("Error:", error);
    return new Response(String(error), { status: 500 });
  }
});
