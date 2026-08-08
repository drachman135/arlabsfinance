import { useState, useEffect } from 'react';
import { KeyRound, Loader2, ShieldCheck, ShieldAlert, Clock } from 'lucide-react';
import { LicenseService } from '../../core/license/LicenseService';
import { supabase } from '../../core/supabase';
interface LicenseActivationProps {
  onActivationSuccess: () => void;
}

export function LicenseActivation({ onActivationSuccess }: LicenseActivationProps) {
  const [licenseKey, setLicenseKey] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);
  const [isWaitingConfirm, setIsWaitingConfirm] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);

  // Listener untuk menunggu persetujuan dari perangkat lain
  useEffect(() => {
    if (!isWaitingConfirm || !sessionId || !licenseKey) return;

    const channel = supabase
      .channel(`session_wait_${sessionId}`)
      .on(
        'postgres_changes',
        {
          event: '*', // Listen for UPDATE or DELETE
          schema: 'public',
          table: 'license_sessions',
          filter: `id=eq.${sessionId}`,
        },
        (payload) => {
          if (payload.eventType === 'UPDATE' && payload.new.status === 'ACTIVE') {
            // Disetujui!
            setIsWaitingConfirm(false);
            setIsSuccess(true);
            
            // Simpan data final
            LicenseService.saveLicenseLocally({
              status: 'ACTIVE',
              license_type: 'TRIAL', // Asumsi default atau dari payload sebelumnya
              expiration_date: null,
              client_id: licenseKey,
              license_key: licenseKey,
              session_id: sessionId
            });

            setTimeout(() => {
              onActivationSuccess();
            }, 1500);
          } else if (payload.eventType === 'DELETE' || (payload.eventType === 'UPDATE' && payload.new.status === 'REJECTED')) {
            // Ditolak
            setIsWaitingConfirm(false);
            setSessionId(null);
            setErrorMsg('Permintaan login ditolak oleh perangkat utama Anda.');
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [isWaitingConfirm, sessionId, licenseKey, onActivationSuccess]);

  const handleActivate = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMsg('');

    if (!licenseKey || licenseKey.length < 5) {
      setErrorMsg('Harap masukkan format License Key yang valid (misal: AR-XXXX-XXXX).');
      return;
    }

    setIsLoading(true);

    const response = await LicenseService.activateLicense(licenseKey);

    if (response.success) {
      if (response.data && response.data.status === 'REQUIRES_CONFIRMATION') {
        setIsWaitingConfirm(true);
        setSessionId(response.data.session_id);
        setIsLoading(false);
      } else {
        setIsSuccess(true);
        // Tunggu sesaat agar notifikasi terbaca user, lalu panggil callback sukses
        setTimeout(() => {
          onActivationSuccess();
        }, 1500);
      }
    } else {
      setErrorMsg(response.message);
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 flex flex-col items-center justify-center p-6 relative overflow-hidden">

      {/* Background Decor */}
      <div className="absolute top-[-20%] left-[-10%] w-[50%] h-[50%] bg-blue-500/20 rounded-full blur-[120px] pointer-events-none"></div>
      <div className="absolute bottom-[-20%] right-[-10%] w-[50%] h-[50%] bg-purple-500/20 rounded-full blur-[120px] pointer-events-none"></div>

      <div className="w-full max-w-md bg-white/10 backdrop-blur-xl border border-white/20 p-8 rounded-3xl shadow-2xl relative z-10">
        <form onSubmit={handleActivate} className="flex flex-col items-center">

          {/* Logo / Icon */}
          <div className="w-20 h-20 bg-blue-600 rounded-2xl flex items-center justify-center mb-6 shadow-lg shadow-blue-500/30">
            <KeyRound className="w-10 h-10 text-white" />
          </div>

          <h1 className="text-2xl font-bold text-white mb-2 text-center">
            Kode aktivasi
          </h1>
          <p className="text-slate-300 text-center mb-8 text-sm">
            Perangkat ini belum memiliki kode aktivasi. Masukkan Kode Aktivasi Anda untuk melanjutkan.
          </p>

          {/* Error Message */}
          {errorMsg && (
            <div className="w-full bg-red-500/20 border border-red-500/50 text-red-200 text-sm p-4 rounded-xl mb-6 flex items-start gap-3">
              <ShieldAlert className="w-5 h-5 shrink-0 mt-0.5" />
              <span>{errorMsg}</span>
            </div>
          )}

          {/* Success Message */}
          {isSuccess && (
            <div className="w-full bg-green-500/20 border border-green-500/50 text-green-200 text-sm p-4 rounded-xl mb-6 flex items-center justify-center font-medium animate-pulse">
              <span className="mr-2">✅</span>
              Aktivasi Berhasil, Mengalihkan...
            </div>
          )}

          {/* Waiting Confirmation Message */}
          {isWaitingConfirm && (
            <div className="w-full bg-blue-500/20 border border-blue-500/50 text-blue-200 text-sm p-4 rounded-xl mb-6 flex flex-col items-center justify-center text-center">
              <Clock className="w-8 h-8 mb-2 animate-bounce" />
              <span className="font-semibold mb-1">Menunggu Persetujuan</span>
              <p className="text-xs text-blue-300">
                Silakan buka aplikasi di perangkat Anda yang sudah aktif dan tekan tombol <b>"Izinkan"</b>.
              </p>
            </div>
          )}

          {/* License Key Field */}
          {!isWaitingConfirm && !isSuccess && (
            <div className="w-full mb-8">
              <label className="block text-sm font-medium text-slate-300 mb-2">
                Kode aktivasi
              </label>
              <input
                type="text"
                disabled={isLoading}
                value={licenseKey}
                onChange={(e) => setLicenseKey(e.target.value.toUpperCase())}
                placeholder="AR-XXXX-XXXX"
                className="block w-full px-4 py-3 bg-slate-900/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all disabled:opacity-50 tracking-widest font-mono text-center uppercase"
              />
            </div>
          )}

          {/* Activate Button */}
          {!isWaitingConfirm && !isSuccess && (
            <button
              type="submit"
              disabled={isLoading || !licenseKey}
              className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center h-12 shadow-lg shadow-blue-600/20"
            >
              {isLoading ? (
                <Loader2 className="h-5 w-5 animate-spin" />
              ) : (
                <>
                  <ShieldCheck className="w-5 h-5 mr-2" />
                  Aktivasi Sekarang
                </>
              )}
            </button>
          )}

        </form>
      </div>
    </div>
  );
}
