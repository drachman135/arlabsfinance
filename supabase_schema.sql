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
CREATE POLICY "Clients can view own profile" 
ON public.client_profiles 
FOR SELECT 
USING (auth.uid() = id);

-- Allow clients to update their own profile (except status if possible, but keep it simple for now)
CREATE POLICY "Clients can update own profile" 
ON public.client_profiles 
FOR UPDATE 
USING (auth.uid() = id);

-- Allow insertion of profile during registration (using trigger or manual insert)
-- For this simple setup, we'll allow insert if id matches auth.uid()
CREATE POLICY "Clients can insert own profile" 
ON public.client_profiles 
FOR INSERT 
WITH CHECK (auth.uid() = id);

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

CREATE POLICY "Clients can view messages in their rooms" 
ON public.chat_messages 
FOR SELECT 
USING (
    sender_id = auth.uid()::text 
    OR receiver_id = auth.uid()::text
);

CREATE POLICY "Clients can send messages" 
ON public.chat_messages 
FOR INSERT 
WITH CHECK (sender_id = auth.uid()::text);

-----------------------------------------------------------

-- 4. Enable Realtime
-- This is necessary for the auto-login "Waiting Approval" flow and chat
ALTER PUBLICATION supabase_realtime ADD TABLE public.client_profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_messages;
