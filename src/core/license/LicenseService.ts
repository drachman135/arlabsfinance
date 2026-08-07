import FingerprintJS from '@fingerprintjs/fingerprintjs';
import CryptoJS from 'crypto-js';

// Kunci enkripsi dinamis agar tidak mudah ditebak
// (Bisa juga ditambahkan import.meta.env.VITE_ENCRYPTION_KEY jika ada)
const ENCRYPTION_KEY = import.meta.env.VITE_ENCRYPTION_KEY || 'arlabs-finance-secure-key-2024';
const STORAGE_KEY = 'secure_license_prefs';

export interface LicenseData {
  status: 'ACTIVE' | 'NOT_ACTIVATED' | 'EXPIRED';
  license_type: string;
  expiration_date: string | null;
  client_id?: string;
  client_name?: string;
  license_key?: string;
}

export class LicenseService {
  /**
   * Mengambil Device ID Unik menggunakan Browser Fingerprinting
   */
  static async getDeviceId(): Promise<string> {
    const fp = await FingerprintJS.load();
    const result = await fp.get();
    return result.visitorId;
  }

  /**
   * Menyimpan Data Lisensi secara Terenkripsi (AES)
   */
  static saveLicenseLocally(data: LicenseData) {
    try {
      const jsonStr = JSON.stringify(data);
      const encrypted = CryptoJS.AES.encrypt(jsonStr, ENCRYPTION_KEY).toString();
      localStorage.setItem(STORAGE_KEY, encrypted);
    } catch (error) {
      console.error('Failed to encrypt license data:', error);
    }
  }

  /**
   * Mengambil dan Dekripsi Data Lisensi dari Local Storage
   */
  static getLicenseLocally(): LicenseData | null {
    try {
      const encrypted = localStorage.getItem(STORAGE_KEY);
      if (!encrypted) return null;

      const decryptedBytes = CryptoJS.AES.decrypt(encrypted, ENCRYPTION_KEY);
      const decryptedString = decryptedBytes.toString(CryptoJS.enc.Utf8);
      
      if (!decryptedString) return null;
      
      return JSON.parse(decryptedString) as LicenseData;
    } catch (error) {
      console.error('Failed to decrypt license data:', error);
      return null;
    }
  }

  /**
   * Mengambil Waktu Server (Anti-Tamper Time)
   */
  static async getServerTime(): Promise<Date> {
    try {
      // Mengambil header date dari request ke URL proyek
      const response = await fetch(window.location.origin, { method: 'HEAD' });
      const dateHeader = response.headers.get('date');
      if (dateHeader) {
        return new Date(dateHeader);
      }
      return new Date(); // Fallback jika gagal
    } catch (e) {
      return new Date(); // Fallback
    }
  }

  /**
   * Menghapus Lisensi Lokal
   */
  static clearLicense() {
    localStorage.removeItem(STORAGE_KEY);
  }

  /**
   * Memanggil API Aktivasi Lisensi
   */
    static async activateLicense(licenseKey: string): Promise<{ success: boolean; data?: any; message: string }> {
    try {
      const deviceId = await this.getDeviceId();
      // Menggunakan nama paket asli agar sesuai dengan pengecekan Edge Function bawaan Anda
      const packageName = 'com.ardevlabs.finance'; 
      
      const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';
      const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

      // Kadang user mengetik huruf besar padahal di database huruf kecil (uuid)
      let formattedKey = licenseKey.trim();
      
      // Jika formatnya 'AR-' diikuti oleh UUID panjang, kita ubah bagian UUID-nya jadi huruf kecil
      // karena UUID.randomUUID() di Android default-nya huruf kecil
      if (formattedKey.startsWith('AR-') && formattedKey.length > 30) {
        const prefix = formattedKey.substring(0, 3); // "AR-"
        const uuidPart = formattedKey.substring(3).toLowerCase();
        formattedKey = prefix + uuidPart;
      }

      const response = await fetch(`${supabaseUrl}/functions/v1/activate-license`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${supabaseAnonKey}`
        },
        body: JSON.stringify({
          license_key: formattedKey,
          device_id: deviceId,
          package_name: packageName
        })
      });

      const result = await response.json();
      console.log("Response dari Server:", result);
      
      if (response.ok && result.success) {
        // Berhasil dari server. Gunakan fallback 'ACTIVE' jika backend lupa mengirim field status
        const finalStatus = result.status || result.Status || 'ACTIVE';

        this.saveLicenseLocally({
          status: finalStatus,
          license_type: result.license_type || result.LicenseType || 'TRIAL',
          expiration_date: result.expiration_date || result.ExpirationDate || null,
          client_id: result.client_id || result.ClientId || null, // Menyimpan ID Klien
          client_name: result.client_name || result.ClientName || 'Klien ArLABS', // Menyimpan nama klien jika ada
          license_key: licenseKey // Simpan kunci lisensi asli
        });
        return { success: true, message: result.message, data: result };
      } else {
        return { success: false, message: result.message || result.error || 'Gagal mengaktivasi lisensi' };
      }
    } catch (error: any) {
      console.error("Activation Error:", error);
      return { success: false, message: error.message || 'Kesalahan koneksi ke server atau Fingerprint diblokir' };
    }
  }
}
