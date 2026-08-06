-- Tambahkan script ini ke SQL Editor di Supabase Dashboard Anda dan jalankan

ALTER TABLE client_profiles 
ADD COLUMN IF NOT EXISTS status text DEFAULT 'pending';

-- Opsi tambahan: Update existing clients to 'approved' if you have any existing ones
UPDATE client_profiles 
SET status = 'approved' 
WHERE status = 'pending';
