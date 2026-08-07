import React, { useState } from 'react';
import { User, Mail, Phone, Loader2, ArrowLeft, CheckCircle2 } from 'lucide-react';
import { supabase } from '../../core/supabase';
import { useNavigate } from 'react-router-dom';

export function ClientRegistration() {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg('');
    
    if (!name.trim()) {
      setErrorMsg('Nama wajib diisi.');
      return;
    }

    setIsLoading(true);

    try {
      // Masukkan ke tabel client_profiles dengan membuat ID manual (uuid)
      const { error } = await supabase.from('client_profiles').insert({
        id: crypto.randomUUID(), // <-- Perbaikan error "null value in column id"
        name: name.trim(),
        phone: phone.trim() || null, // null jika kosong agar rapi di DB
        email: email.trim() || null,
        status: 'pending',
      });

      if (error) {
        throw error;
      }

      setIsSuccess(true);
    } catch (err: any) {
      setErrorMsg(err.message || 'Terjadi kesalahan saat mendaftar. Silakan coba lagi.');
    } finally {
      setIsLoading(false);
    }
  };

  if (isSuccess) {
    return (
      <div className="min-h-screen bg-slate-900 flex flex-col items-center justify-center p-6">
        <div className="w-full max-w-md bg-white/10 backdrop-blur-xl border border-white/20 p-8 rounded-3xl shadow-2xl text-center">
          <div className="w-20 h-20 bg-green-500/20 rounded-full flex items-center justify-center mx-auto mb-6">
            <CheckCircle2 className="w-10 h-10 text-green-400" />
          </div>
          <h1 className="text-2xl font-bold text-white mb-4">Pendaftaran Berhasil</h1>
          <p className="text-slate-300 mb-8">
            Data Anda telah dikirim dan sedang menunggu persetujuan (status: <span className="font-semibold text-yellow-400">pending</span>). 
            Pemilik aplikasi (Owner) akan meninjau dan membuatkan License Key untuk Anda.
          </p>
          <button
            onClick={() => navigate('/activation')}
            className="w-full bg-slate-800 hover:bg-slate-700 border border-slate-600 text-white font-semibold py-3 px-6 rounded-xl transition-colors"
          >
            Kembali ke Halaman Aktivasi
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-900 flex flex-col items-center justify-center p-6 relative overflow-hidden">
      {/* Background Decor */}
      <div className="absolute top-[-20%] right-[-10%] w-[50%] h-[50%] bg-blue-500/10 rounded-full blur-[120px] pointer-events-none"></div>
      
      <div className="w-full max-w-md bg-white/10 backdrop-blur-xl border border-white/20 p-8 rounded-3xl shadow-2xl relative z-10">
        
        <button 
          onClick={() => navigate('/activation')}
          className="flex items-center text-slate-400 hover:text-white mb-6 transition-colors"
        >
          <ArrowLeft className="w-4 h-4 mr-2" />
          Kembali
        </button>

        <form onSubmit={handleRegister} className="flex flex-col">
          <h1 className="text-2xl font-bold text-white mb-2">
            Pendaftaran Klien
          </h1>
          <p className="text-slate-300 mb-8 text-sm">
            Isi formulir ini untuk mengajukan pembuatan akun dan lisensi ke Pemilik (Owner).
          </p>

          {/* Error Message */}
          {errorMsg && (
            <div className="w-full bg-red-500/20 border border-red-500/50 text-red-200 text-sm p-4 rounded-xl mb-6">
              {errorMsg}
            </div>
          )}

          {/* Nama (Wajib) */}
          <div className="w-full mb-4">
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Nama Lengkap <span className="text-red-400">*</span>
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <User className="h-5 w-5 text-slate-400" />
              </div>
              <input
                type="text"
                disabled={isLoading}
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Masukkan nama Anda"
                className="block w-full pl-10 pr-4 py-3 bg-slate-900/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all disabled:opacity-50"
              />
            </div>
          </div>

          {/* Phone (Opsional) */}
          <div className="w-full mb-4">
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Nomor WhatsApp <span className="text-slate-500 text-xs">(Opsional)</span>
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Phone className="h-5 w-5 text-slate-400" />
              </div>
              <input
                type="tel"
                disabled={isLoading}
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="0812xxxxxx"
                className="block w-full pl-10 pr-4 py-3 bg-slate-900/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all disabled:opacity-50"
              />
            </div>
          </div>

          {/* Email (Opsional) */}
          <div className="w-full mb-8">
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Email <span className="text-slate-500 text-xs">(Opsional)</span>
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Mail className="h-5 w-5 text-slate-400" />
              </div>
              <input
                type="email"
                disabled={isLoading}
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="nama@email.com"
                className="block w-full pl-10 pr-4 py-3 bg-slate-900/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all disabled:opacity-50"
              />
            </div>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={isLoading}
            className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-50 flex items-center justify-center h-12 shadow-lg shadow-blue-600/20"
          >
            {isLoading ? <Loader2 className="h-5 w-5 animate-spin" /> : 'Kirim Pendaftaran'}
          </button>
        </form>
      </div>
    </div>
  );
}
