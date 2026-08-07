import { useState } from 'react';
import { KeyRound, Loader2, ShieldCheck, ShieldAlert } from 'lucide-react';
import { LicenseService } from '../../core/license/LicenseService';

interface LicenseActivationProps {
  onActivationSuccess: () => void;
}

export function LicenseActivation({ onActivationSuccess }: LicenseActivationProps) {
  const [licenseKey, setLicenseKey] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);

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
      setIsSuccess(true);
      // Tunggu sesaat agar notifikasi terbaca user, lalu panggil callback sukses
      setTimeout(() => {
        onActivationSuccess();
      }, 1500);
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

          {/* License Key Field */}
          <div className="w-full mb-8">
            <label className="block text-sm font-medium text-slate-300 mb-2">
              Kode aktivasi
            </label>
            <input
              type="text"
              disabled={isLoading || isSuccess}
              value={licenseKey}
              onChange={(e) => setLicenseKey(e.target.value.toUpperCase())}
              placeholder="AR-XXXX-XXXX"
              className="block w-full px-4 py-3 bg-slate-900/50 border border-slate-700 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all disabled:opacity-50 tracking-widest font-mono text-center uppercase"
            />
          </div>

          {/* Activate Button */}
          <button
            type="submit"
            disabled={isLoading || !licenseKey || isSuccess}
            className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center h-12 shadow-lg shadow-blue-600/20"
          >
            {isLoading ? (
              <Loader2 className="h-5 w-5 animate-spin" />
            ) : isSuccess ? (
              'Berhasil'
            ) : (
              <>
                <ShieldCheck className="w-5 h-5 mr-2" />
                Aktivasi Sekarang
              </>
            )}
          </button>

        </form>
      </div>
    </div>
  );
}
