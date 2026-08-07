import React, { useState } from 'react';
import { Landmark, Mail, Lock, Eye, EyeOff, Loader2 } from 'lucide-react';
import { supabase } from '../../core/supabase';

interface LoginScreenProps {
  onNavigateToRegister: () => void;
  onLoginSuccess: () => void;
}

export function LoginScreen({ onNavigateToRegister, onLoginSuccess }: LoginScreenProps) {
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg('');
    
    if (!identifier || !password) {
      setErrorMsg('Harap masukkan email dan kata sandi Anda');
      return;
    }

    if (!identifier.includes('@')) {
      setErrorMsg('Login menggunakan nomor telepon belum diaktifkan. Silakan gunakan email.');
      return;
    }

    setIsLoading(true);
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email: identifier.trim(),
        password: password,
      });

      if (error) {
        setErrorMsg(error.message);
      } else {
        onLoginSuccess();
      }
    } catch (err: any) {
      setErrorMsg(err.message || 'Terjadi kesalahan sistem');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col items-center justify-center p-6">
      <div className="w-full max-w-md">
        <form onSubmit={handleLogin} className="flex flex-col items-center">
          
          {/* Logo */}
          <div className="w-20 h-20 bg-white rounded-full border border-slate-200 shadow-xl shadow-blue-500/10 flex items-center justify-center mb-8">
            <Landmark className="w-10 h-10 text-blue-600" />
          </div>

          {/* Title */}
          <h1 className="text-3xl font-bold text-slate-900 mb-2 text-center">
            Selamat Datang
          </h1>
          <p className="text-slate-500 text-center mb-10">
            Masuk ke akun ArLABS Finance Anda
          </p>

          {/* Error Message */}
          {errorMsg && (
            <div className="w-full bg-red-50 text-red-600 text-sm p-4 rounded-xl mb-6 border border-red-100">
              {errorMsg}
            </div>
          )}

          {/* Identifier Field */}
          <div className="w-full mb-4">
            <label className="block text-sm font-medium text-slate-700 mb-1">
              Email atau Nomor Telepon
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Mail className="h-5 w-5 text-slate-400" />
              </div>
              <input
                type="email"
                disabled={isLoading}
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                placeholder="Masukkan email atau nomor telepon Anda"
                className="block w-full pl-10 pr-3 py-3 border border-slate-300 rounded-xl text-sm placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all disabled:opacity-50 disabled:bg-slate-50"
              />
            </div>
          </div>

          {/* Password Field */}
          <div className="w-full mb-8">
            <label className="block text-sm font-medium text-slate-700 mb-1">
              Kata Sandi
            </label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Lock className="h-5 w-5 text-slate-400" />
              </div>
              <input
                type={showPassword ? 'text' : 'password'}
                disabled={isLoading}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Masukkan kata sandi Anda"
                className="block w-full pl-10 pr-10 py-3 border border-slate-300 rounded-xl text-sm placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all disabled:opacity-50 disabled:bg-slate-50"
              />
              <button
                type="button"
                disabled={isLoading}
                onClick={() => setShowPassword(!showPassword)}
                className="absolute inset-y-0 right-0 pr-3 flex items-center"
              >
                {showPassword ? (
                  <EyeOff className="h-5 w-5 text-slate-400 hover:text-slate-600" />
                ) : (
                  <Eye className="h-5 w-5 text-slate-400 hover:text-slate-600" />
                )}
              </button>
            </div>
          </div>

          {/* Login Button */}
          <button
            type="submit"
            disabled={isLoading}
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-70 disabled:cursor-not-allowed flex items-center justify-center h-12"
          >
            {isLoading ? <Loader2 className="h-5 w-5 animate-spin" /> : 'Masuk'}
          </button>

          {/* Register Link */}
          <button
            type="button"
            onClick={onNavigateToRegister}
            disabled={isLoading}
            className="mt-6 text-sm text-blue-600 hover:text-blue-800 font-medium transition-colors"
          >
            Belum punya akun? Daftar sekarang.
          </button>

        </form>
      </div>
    </div>
  );
}
