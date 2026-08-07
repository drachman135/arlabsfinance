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
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [isLicenseActive, licenseData?.license_key]);

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
