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

    // Inisialisasi Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Dapatkan Access Token Firebase
    const accessToken = await getFirebaseAccessToken();
    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`;

    // Skenario A: Owner membalas pesan, kirim notifikasi ke Klien
    if (sender_type === 'OWNER') {
      const { data: roomData } = await supabase.from('chat_rooms').select('client_id').eq('id', room_id).single();
      if (!roomData) return new Response("Room tidak ditemukan", { status: 404 });

      const { data: licenseData } = await supabase.from('licenses').select('fcm_token').eq('license_key', roomData.client_id).single();
      const clientFcmToken = licenseData?.fcm_token;

      if (!clientFcmToken) return new Response("Klien belum punya FCM Token", { status: 200 });

      const fcmPayload = {
        message: {
          token: clientFcmToken,
          notification: { title: "Pesan Baru dari Owner", body: message },
          data: { route: "/chat" }
        }
      };

      await fetch(fcmUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`
        },
        body: JSON.stringify(fcmPayload)
      });

      return new Response(JSON.stringify({ status: "Sent to Client" }), { headers: { "Content-Type": "application/json" } });
    }

    // Skenario B: Klien mengirim pesan, kirim notifikasi ke SEMUA HP Owner
    if (sender_type === 'CLIENT') {
      const { data: adminTokens } = await supabase.from('admin_tokens').select('fcm_token');
      
      if (!adminTokens || adminTokens.length === 0) {
        return new Response("Belum ada token Admin yang terdaftar", { status: 200 });
      }

      let sentCount = 0;
      for (const admin of adminTokens) {
        if (admin.fcm_token) {
          const fcmPayload = {
            message: {
              token: admin.fcm_token,
              notification: { title: "Pesan Baru dari Klien", body: message },
              data: { route: "/chat", room_id: room_id }
            }
          };

          await fetch(fcmUrl, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${accessToken}`
            },
            body: JSON.stringify(fcmPayload)
          });
          sentCount++;
        }
      }

      return new Response(JSON.stringify({ status: `Sent to ${sentCount} Admins` }), { headers: { "Content-Type": "application/json" } });
    }

    return new Response("Unknown sender type", { status: 200 });

  } catch (error) {
    console.error("Error:", error);
    return new Response(String(error), { status: 500 });
  }
});
