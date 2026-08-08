import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, Send, Loader2, Info, Paperclip, X, Check, CheckCheck } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../../core/supabase';
import { LicenseService } from '../../core/license/LicenseService';
import { OfflineStore } from '../../core/offline/OfflineStore';
import { SyncQueue } from '../../core/offline/SyncQueue';
import { NetworkMonitor } from '../../core/offline/NetworkMonitor';


interface ChatMessage {
  id: string;
  sender_type: 'CLIENT' | 'OWNER';
  message?: string;
  created_at: string;
  attachment_url?: string;
  isPending?: boolean; // For optimistic UI when offline
}

export function ChatScreen() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputMsg, setInputMsg] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isUploading, setIsUploading] = useState(false);
  const [roomId, setRoomId] = useState<string | null>(null);
  const [clientName, setClientName] = useState<string>('Unknown_Client');
  
  // Image Preview State
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  
  const activeClientId = LicenseService.getLicenseLocally()?.license_key;
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Auto-scroll ke bawah saat ada pesan baru
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Inisialisasi dan load pesan
  useEffect(() => {
    let mounted = true;

    let activeChannel: any = null;

    const initChat = async () => {
      if (!activeClientId) {
        setIsLoading(false);
        return;
      }

      try {
        // 1. Cari room id untuk client ini
        let { data: roomData } = await supabase
          .from('chat_rooms')
          .select('id')
          .eq('client_id', activeClientId)
          .limit(1);

        let currentRoomId = roomData && roomData.length > 0 ? roomData[0].id : null;

        // Jika room belum ada, buat baru
        if (!currentRoomId && NetworkMonitor.isOnline()) {
          // Double check if mounted to avoid Strict Mode double inserts
          if (!mounted) return;
          
          const { data: newRoom } = await supabase
            .from('chat_rooms')
            .insert([{ client_id: activeClientId }])
            .select()
            .single();
            
          if (newRoom) currentRoomId = newRoom.id;
        }

        if (!mounted) return;

        if (currentRoomId) {
          setRoomId(currentRoomId);
          
          const CACHE_KEY = `chat_messages_${currentRoomId}`;
          const cachedMsgs = await OfflineStore.get<ChatMessage[]>(CACHE_KEY);
          if (cachedMsgs) {
            setMessages(cachedMsgs);
            setIsLoading(false);
          }

          if (NetworkMonitor.isOnline()) {
            // Cari nama klien untuk nama folder storage
            const { data: licenseData } = await supabase
              .from('licenses')
              .select('customer_name')
              .eq('license_key', activeClientId)
              .single();
              
            if (licenseData?.customer_name) {
              setClientName(licenseData.customer_name.replace(/[^a-zA-Z0-9]/g, '_'));
            }

            // 2. Load pesan-pesan sebelumnya
            const { data: msgs } = await supabase
              .from('chat_messages')
              .select('*')
              .eq('room_id', currentRoomId)
              .order('created_at', { ascending: true });
              
            if (msgs) {
              setMessages(msgs as ChatMessage[]);
              await OfflineStore.set(CACHE_KEY, msgs);
            }

            // 3. Subscribe ke pesan baru (Realtime)
            activeChannel = supabase
              .channel(`room_${currentRoomId}`)
              .on('postgres_changes', 
                { event: 'INSERT', schema: 'public', table: 'chat_messages', filter: `room_id=eq.${currentRoomId}` },
                (payload) => {
                  setMessages(prev => {
                    const existingIndex = prev.findIndex(m => m.id === payload.new.id);
                    if (existingIndex !== -1) {
                      const newMsgs = [...prev];
                      newMsgs[existingIndex] = { 
                        ...newMsgs[existingIndex], 
                        ...payload.new as ChatMessage, 
                        isPending: false 
                      };
                      OfflineStore.set(CACHE_KEY, newMsgs);
                      return newMsgs;
                    }
                    const newMsgs = [...prev, payload.new as ChatMessage];
                    OfflineStore.set(CACHE_KEY, newMsgs);
                    // PENTING: Auto-scroll saat pesan baru dari realtime masuk
                    setTimeout(scrollToBottom, 100);
                    return newMsgs;
                  });
                }
              )
              .subscribe();
          }
        }
      } catch (err) {
        console.error("Gagal memuat chat:", err);
      } finally {
        setIsLoading(false);
      }
    };

    initChat();

    // Proper Cleanup
    return () => {
      mounted = false;
      if (activeChannel) {
        supabase.removeChannel(activeChannel);
      }
    };
  }, [activeClientId]);

  // Mengirim Pesan
  // Mengirim Pesan (Teks & Gambar)
  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if ((!inputMsg.trim() && !selectedFile) || !roomId) return;

    let finalAttachmentUrl = undefined;
    let finalMsgText = inputMsg.trim() || undefined;

    // Jika ada gambar yang dipilih, unggah dulu
    if (selectedFile) {
      setIsUploading(true);
      try {
        const fileExt = selectedFile.name.split('.').pop();
        const fileName = `${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`;
        const filePath = `${clientName}/${fileName}`;

        const { error: uploadError } = await supabase.storage
          .from('chat_attachments')
          .upload(filePath, selectedFile, { cacheControl: '3600', upsert: false });

        if (uploadError) throw uploadError;

        const { data: publicUrlData } = supabase.storage
          .from('chat_attachments')
          .getPublicUrl(filePath);

        finalAttachmentUrl = publicUrlData.publicUrl;
        
        // Hapus preview
        setSelectedFile(null);
        if (previewUrl) URL.revokeObjectURL(previewUrl);
        setPreviewUrl(null);
      } catch (err) {
        console.error("Gagal mengunggah gambar:", err);
        alert("Gagal mengunggah gambar. Pastikan Anda punya koneksi internet yang baik dan bucket 'chat_attachments' tersedia.");
        setIsUploading(false);
        return; // Hentikan pengiriman jika gambar gagal diunggah
      }
    }

    setInputMsg(''); // Kosongkan input
    
    const isOnline = NetworkMonitor.isOnline();
    const tempId = crypto.randomUUID();

    // Optimistic UI update
    const tempMsg: ChatMessage = {
      id: tempId,
      sender_type: 'CLIENT',
      message: finalMsgText,
      created_at: new Date().toISOString(),
      attachment_url: finalAttachmentUrl,
      isPending: !isOnline
    };
    
    setMessages(prev => {
      const newMsgs = [...prev, tempMsg];
      OfflineStore.set(`chat_messages_${roomId}`, newMsgs);
      return newMsgs;
    });

    try {
      const payload = {
        id: tempId,
        room_id: roomId,
        sender_type: 'CLIENT',
        message: finalMsgText,
        attachment_url: finalAttachmentUrl
      };

      if (isOnline) {
        await supabase.from('chat_messages').insert([payload]);
      } else {
        await SyncQueue.enqueue({
          table: 'chat_messages',
          action: 'INSERT',
          payload
        });
      }
    } catch (err) {
      console.error("Gagal mengirim pesan:", err);
    } finally {
      setIsUploading(false);
    }
  };

  // Memilih Gambar (Preview)
  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    if (file.size > 5 * 1024 * 1024) {
      alert("Ukuran gambar terlalu besar! Maksimal 5MB.");
      return;
    }

    setSelectedFile(file);
    const objectUrl = URL.createObjectURL(file);
    setPreviewUrl(objectUrl);
    
    e.target.value = ''; // Reset input agar bisa memilih file yang sama lagi
  };

  const clearPreview = () => {
    setSelectedFile(null);
    if (previewUrl) URL.revokeObjectURL(previewUrl);
    setPreviewUrl(null);
  };

  return (
    <div className="flex flex-col h-screen bg-slate-50 w-full max-w-md mx-auto shadow-xl overflow-hidden relative">
      {/* Header */}
      <div className="bg-white px-4 py-4 flex items-center justify-between border-b border-slate-100 shadow-sm z-10 sticky top-0">
        <div className="flex items-center gap-4">
          <button 
            onClick={() => navigate('/')}
            className="p-2 -ml-2 rounded-full hover:bg-slate-100 transition-colors text-slate-600"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center border border-blue-200">
              <span className="text-blue-600 font-bold">CS</span>
            </div>
            <div>
              <h1 className="font-bold text-slate-800 leading-tight">Customer Support</h1>
              <p className="text-xs text-green-500 font-medium">Online</p>
            </div>
          </div>
        </div>
        
        <button className="p-2 text-slate-400 hover:text-slate-600 transition-colors">
          <Info className="w-5 h-5" />
        </button>
      </div>

      {/* Message Area */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-[#f8fafc] bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]">
        
        {/* Enkripsi Notice */}
        <div className="flex justify-center mb-6">
          <div className="bg-yellow-50 border border-yellow-200 px-4 py-2 rounded-xl text-xs text-yellow-700 shadow-sm text-center max-w-xs">
            🔒 Pesan Anda terenkripsi secara *end-to-end* dengan server.
          </div>
        </div>

        {isLoading ? (
          <div className="flex justify-center items-center py-10">
            <Loader2 className="w-8 h-8 text-blue-500 animate-spin" />
          </div>
        ) : messages.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-40 text-slate-400">
            <p className="text-sm">Belum ada pesan.</p>
            <p className="text-xs mt-1">Kirim pesan pertama Anda sekarang!</p>
          </div>
        ) : (
          messages.map((msg, idx) => {
            const isMe = msg.sender_type === 'CLIENT';
            
            // Format waktu sederhana HH:MM
            const time = new Date(msg.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

            return (
              <div key={msg.id || idx} className={`flex ${isMe ? 'justify-end' : 'justify-start'}`}>
                <div 
                  className={`max-w-[80%] px-4 py-2 rounded-2xl shadow-sm relative group
                    ${isMe 
                      ? 'bg-blue-600 text-white rounded-br-sm' 
                      : 'bg-white text-slate-800 rounded-bl-sm border border-slate-100'
                    }
                  `}
                >
                  {msg.message && <p className="text-[15px] leading-relaxed break-words">{msg.message}</p>}
                  
                  {msg.attachment_url && (
                    <div className="mt-2 rounded-xl overflow-hidden border border-black/10">
                      <img 
                        src={msg.attachment_url} 
                        alt="Lampiran" 
                        className="max-w-full h-auto max-h-64 object-cover hover:opacity-95 transition-opacity cursor-pointer"
                        onClick={() => window.open(msg.attachment_url, '_blank')}
                      />
                    </div>
                  )}

                  <div className={`flex items-center justify-end gap-1 mt-1 font-medium ${isMe ? 'text-blue-200' : 'text-slate-400'}`}>
                    <span className="text-[10px] block text-right">
                      {time}
                    </span>
                    {isMe && (
                      msg.isPending 
                        ? <Check className="w-3 h-3" /> 
                        : <CheckCheck className="w-3 h-3" />
                    )}
                  </div>
                </div>
              </div>
            );
          })
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Preview Overlay */}
      {previewUrl && (
        <div className="absolute bottom-20 left-4 right-4 bg-white rounded-2xl shadow-2xl border border-slate-200 p-4 z-20 animate-in slide-in-from-bottom-5">
          <div className="flex justify-between items-center mb-3">
            <span className="text-sm font-bold text-slate-700">Kirim Gambar</span>
            <button 
              onClick={clearPreview}
              className="p-1 bg-slate-100 rounded-full text-slate-500 hover:text-red-500 hover:bg-red-50 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
          <div className="relative rounded-xl overflow-hidden bg-slate-100 flex justify-center items-center h-48 border border-slate-200">
            <img src={previewUrl} alt="Preview" className="max-w-full max-h-full object-contain" />
          </div>
        </div>
      )}

      {/* Input Area */}
      <div className="bg-white border-t border-slate-100 p-3 z-10 relative">
        <form onSubmit={handleSendMessage} className="flex items-end gap-2">
          
          {/* Attachment Button */}
          <div className="relative">
            <input 
              type="file" 
              id="file-upload" 
              className="hidden" 
              accept="image/*"
              disabled={isUploading}
              onChange={handleFileSelect}
            />
            <label 
              htmlFor="file-upload"
              className={`w-11 h-11 flex items-center justify-center rounded-full transition-colors flex-shrink-0
                ${isUploading ? 'text-slate-300 cursor-not-allowed pointer-events-none' : 'text-slate-400 hover:text-blue-500 hover:bg-blue-50 cursor-pointer'}
              `}
            >
              <Paperclip className="w-5 h-5" />
            </label>
          </div>

          <div className="flex-1 bg-slate-50 border border-slate-200 rounded-2xl overflow-hidden focus-within:ring-2 focus-within:ring-blue-100 transition-all flex items-center">
            <textarea
              value={inputMsg}
              onChange={(e) => setInputMsg(e.target.value)}
              placeholder={previewUrl ? "Tambahkan keterangan... (opsional)" : "Ketik pesan Anda..."}
              className="w-full bg-transparent p-3 max-h-32 min-h-[44px] outline-none text-sm text-slate-700 resize-none"
              rows={1}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault();
                  handleSendMessage(e);
                }
              }}
            />
          </div>
          
          <button
            type="submit"
            disabled={(!inputMsg.trim() && !selectedFile) || isUploading}
            className="w-11 h-11 bg-blue-600 text-white rounded-full flex items-center justify-center flex-shrink-0 disabled:opacity-50 transition-all transform hover:scale-105 active:scale-95 shadow-md shadow-blue-500/20"
          >
            {isUploading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Send className="w-5 h-5 ml-1" />}
          </button>
        </form>
      </div>
    </div>
  );
}
