import { useState, useEffect } from 'react';
import { LicenseService, type LicenseData } from './LicenseService';
import { supabase } from '../supabase';

export function useLicense() {
  const [licenseData, setLicenseData] = useState<LicenseData | null>(null);
  const [isValidating, setIsValidating] = useState<boolean>(true);
  const [isLicenseActive, setIsLicenseActive] = useState<boolean>(false);
  const [validationMessage, setValidationMessage] = useState<string | null>(null);

  useEffect(() => {
    checkLicense();
  }, []);

  // Monitor deletion of the active license via Supabase Realtime
  useEffect(() => {
    if (!isLicenseActive || !licenseData?.license_key) return;

    const channel = supabase
      .channel(`license_monitor_${licenseData.license_key}`)
      .on(
        'postgres_changes',
        {
          event: 'DELETE',
          schema: 'public',
          table: 'licenses',
          filter: `license_key=eq.${licenseData.license_key}`
        },
        () => {
          console.warn('License was deleted from the server.');
          LicenseService.clearLicense();
          setValidationMessage("Lisensi Anda telah dihapus oleh pemilik.");
          setIsLicenseActive(false);
          setLicenseData(null);
        }
      )
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'license_sessions',
          filter: `license_key=eq.${licenseData.license_key}`
        },
        (payload) => {
          if (payload.new.status === 'REVOKE' && payload.new.id === licenseData.session_id) {
            console.warn('Session was revoked by another device.');
            LicenseService.clearLicense();
            setValidationMessage("Sesi Anda telah diambil alih oleh perangkat lain.");
            setIsLicenseActive(false);
            setLicenseData(null);
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [isLicenseActive, licenseData?.license_key, licenseData?.session_id]);

  // Bulletproof Polling Fallback (Cek status tiap 5 detik)
  useEffect(() => {
    if (!isLicenseActive || !licenseData?.session_id) return;

    const interval = setInterval(async () => {
      try {
        const { data: sessionData, error: sessionError } = await supabase
          .from('license_sessions')
          .select('status')
          .eq('id', licenseData.session_id)
          .single();
          
        if (!sessionError && sessionData && sessionData.status === 'REVOKE') {
          console.warn('Session revoked detected via polling');
          LicenseService.clearLicense();
          setValidationMessage("Sesi Anda telah diambil alih oleh perangkat lain.");
          setIsLicenseActive(false);
          setLicenseData(null);
        }
      } catch (e) {
        // Abaikan error jaringan
      }
    }, 5000);

    return () => clearInterval(interval);
  }, [isLicenseActive, licenseData?.session_id]);

  const checkLicense = async () => {
    setIsValidating(true);
    setValidationMessage(null);
    
    try {
      const data = LicenseService.getLicenseLocally();
      
      if (!data) {
        // Tidak ada data lisensi, biarkan redirect diam-diam
        setIsLicenseActive(false);
        setLicenseData(null);
        return;
      }

      if (data.status !== 'ACTIVE') {
        setValidationMessage(`Lisensi Anda tidak aktif. Status saat ini: ${data.status}`);
        setIsLicenseActive(false);
        setLicenseData(data);
        return;
      }

      // Verifikasi sesi di backend jika online
      if (data.session_id) {
        try {
          const { data: sessionData, error: sessionError } = await supabase
            .from('license_sessions')
            .select('status')
            .eq('id', data.session_id)
            .single();
            
          if (!sessionError && sessionData && sessionData.status === 'REVOKE') {
            setValidationMessage("Sesi Anda telah diambil alih oleh perangkat lain.");
            LicenseService.clearLicense();
            setIsLicenseActive(false);
            setLicenseData(null);
            return;
          }
        } catch (e) {
           // Abaikan error jaringan, anggap masih aktif
        }
      }

      // Validasi Expiration Date dengan Anti-Tamper Time
      if (data.expiration_date) {
        const serverTime = await LicenseService.getServerTime();
        const expirationTime = new Date(data.expiration_date);

        if (serverTime.getTime() > expirationTime.getTime()) {
          // Lisensi Expired
          setValidationMessage("Masa berlaku Lisensi Anda telah kedaluwarsa!");
          setIsLicenseActive(false);
          setLicenseData({ ...data, status: 'EXPIRED' });
          return;
        }
      }

      setIsLicenseActive(true);
      setLicenseData(data);
    } catch (error) {
      console.error('Error validating license', error);
      setValidationMessage('Terjadi kesalahan saat memvalidasi lisensi lokal.');
      setIsLicenseActive(false);
    } finally {
      setIsValidating(false);
    }
  };

  return {
    licenseData,
    isValidating,
    isLicenseActive,
    validationMessage,
    refreshLicense: checkLicense
  };
}
