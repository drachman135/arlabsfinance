-- ArLABS Finance Client
-- Full Database Schema for Supabase

-- 1. Table: client_profiles
CREATE TABLE IF NOT EXISTS public.client_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    status TEXT DEFAULT 'pending',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Enable RLS for client_profiles
ALTER TABLE public.client_profiles ENABLE ROW LEVEL SECURITY;

-- Allow clients to view their own profile
DROP POLICY IF EXISTS "Clients can view own profile" ON public.client_profiles;
CREATE POLICY "Clients can view own profile" 
ON public.client_profiles 
FOR SELECT 
USING (auth.uid() = id);

-- Allow clients to update their own profile (except status if possible, but keep it simple for now)
DROP POLICY IF EXISTS "Clients can update own profile" ON public.client_profiles;
CREATE POLICY "Clients can update own profile" 
ON public.client_profiles 
FOR UPDATE 
USING (auth.uid() = id);

-- Allow insertion of profile during registration (using trigger or manual insert)
-- For this simple setup, we'll allow insert if id matches auth.uid()
DROP POLICY IF EXISTS "Clients can insert own profile" ON public.client_profiles;
CREATE POLICY "Clients can insert own profile" 
ON public.client_profiles 
FOR INSERT 
WITH CHECK (auth.uid() = id);

-- Trigger to automatically create client_profile upon Supabase Auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
DECLARE
  v_status text := 'pending';
BEGIN
  -- Auto-approve the dummy developer account
  IF new.email = 'dev@test.com' THEN
    v_status := 'approved';
  END IF;

  INSERT INTO public.client_profiles (id, name, email, status)
  VALUES (new.id, COALESCE(new.raw_user_meta_data->>'name', 'Klien Baru'), new.email, v_status);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists so we can safely re-run this script
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
-----------------------------------------------------------

-- 2. Table: chat_rooms
CREATE TABLE IF NOT EXISTS public.chat_rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id TEXT NOT NULL,
    owner_id TEXT NOT NULL,
    owner_name TEXT,
    owner_avatar TEXT,
    last_message TEXT,
    last_message_time TIMESTAMP WITH TIME ZONE,
    unread_count INTEGER DEFAULT 0
);

ALTER TABLE public.chat_rooms ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Clients can view own chat rooms" ON public.chat_rooms;
CREATE POLICY "Clients can view own chat rooms" 
ON public.chat_rooms 
FOR SELECT 
USING (client_id = auth.uid()::text);

-----------------------------------------------------------

-- 3. Table: chat_messages
CREATE TABLE IF NOT EXISTS public.chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
    sender_id TEXT NOT NULL,
    receiver_id TEXT NOT NULL,
    content TEXT NOT NULL,
    status TEXT DEFAULT 'sent',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Clients can view messages in their rooms" ON public.chat_messages;
CREATE POLICY "Clients can view messages in their rooms" 
ON public.chat_messages 
FOR SELECT 
USING (
    sender_id = auth.uid()::text 
    OR receiver_id = auth.uid()::text
);

DROP POLICY IF EXISTS "Clients can send messages" ON public.chat_messages;
CREATE POLICY "Clients can send messages" 
ON public.chat_messages 
FOR INSERT 
WITH CHECK (sender_id = auth.uid()::text);

-----------------------------------------------------------

-- 4. Enable Realtime
-- This is necessary for the auto-login "Waiting Approval" flow and chat
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'client_profiles') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.client_profiles;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'chat_rooms') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_rooms;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'chat_messages') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_messages;
  END IF;
END $$;
