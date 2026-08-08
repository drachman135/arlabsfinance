import { useEffect, useState, useCallback } from 'react';
import { 
  ReceiptText, 
  MessageCircle, 
  CheckCircle2, 
  AlertCircle,
  Loader2,
  RefreshCw,
  Download
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { App as CapacitorApp } from '@capacitor/app';
import { Modal } from '../../components/ui/Modal';
import { LicenseService } from '../../core/license/LicenseService';
import { supabase } from '../../core/supabase';
import { PullToRefresh } from '../../components/ui/PullToRefresh';
import { LogOut } from 'lucide-react';

interface Transaction {
  id: string;
  title: string;
  type: 'payment' | 'invoice';
  status: string;
  amount: number;
  date: string;
}





import { OfflineStore } from '../../core/offline/OfflineStore';

export function DashboardScreen() {
  const navigate = useNavigate();
  const [clientName, setClientName] = useState('Klien ArLABS');
  const [clientId, setClientId] = useState<string | null>(null);
  const [showExitModal, setShowExitModal] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);



  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [unreadChat, setUnreadChat] = useState(0);

  const [pendingSession, setPendingSession] = useState<any>(null);
  const [isManagingSession, setIsManagingSession] = useState(false);
  const [showLogoutModal, setShowLogoutModal] = useState(false);
  const [isLoggingOut, setIsLoggingOut] = useState(false);
  
  const [showDownloadConfirm, setShowDownloadConfirm] = useState(false);
  const [isDownloading, setIsDownloading] = useState(false);
  const [downloadProgress, setDownloadProgress] = useState(0);

  useEffect(() => {
    // Ambil data klien dari lisensi yang tersimpan
    const licenseData = LicenseService.getLicenseLocally();
    if (licenseData) {
      if (licenseData.client_name) setClientName(licenseData.client_name);
      if (licenseData.client_id) setClientId(licenseData.client_id);
    }

    // Menangani tombol back fisik di Android (Capacitor)
    const backButtonListener = CapacitorApp.addListener('backButton', () => {
      setShowExitModal(true);
    });

    return () => {
      backButtonListener.then(listener => listener.remove());
    };
  }, []);

  const fetchDashboardData = useCallback(async (showLoading = true) => {
    const savedLicense = LicenseService.getLicenseLocally();
    const activeClientId = clientId || (savedLicense ? savedLicense.license_key : null);

    if (!activeClientId) {
      console.warn("Tidak ada Client ID atau License Key untuk fetch data dashboard");
      return;
    }

    const CACHE_KEY = `dashboard_data_${activeClientId}`;

    try {
      // 1. Optimistic Cache Read
      if (showLoading) {
        const cached = await OfflineStore.get<any>(CACHE_KEY);
        if (cached) {

          setClientName(cached.clientName);
          setTransactions(cached.transactions);
          setUnreadChat(cached.unreadChat);
          setIsLoading(false); // Matikan loading karena data cache sudah ada
        } else {
          setIsLoading(true);
        }
      }

      // 2. Fetch Data Real (Background)
      const newData: any = {
        clientName: 'Klien ArLABS' // fallback
      };



      // 2b. Ambil Nama Customer
      if (savedLicense && savedLicense.license_key) {
        const { data: customerData, error: customerError } = await supabase
          .from('licenses')
          .select('customer_name')
          .eq('license_key', savedLicense.license_key)
          .maybeSingle();
          
        if (customerError) {
          console.error("Gagal mengambil nama dari tabel licenses:", customerError);
        } else if (!customerData) {
          console.warn("Lisensi tidak ditemukan (mungkin telah dihapus). Logout otomatis...");
          LicenseService.clearLicense();
          window.location.href = '/activation';
          return;
        }
          
        if (customerData && customerData.customer_name) {
          newData.clientName = customerData.customer_name;
          setClientName(customerData.customer_name);
        }
      }

      // 2c. Ambil Riwayat Transaksi Terakhir (Kasbon Ledger)
      const actualLicenseKey = savedLicense?.license_key?.trim() || '';
      const { data: txData } = await supabase
        .from('kasbon_ledger')
        .select('id, description, type, amount, transaction_date')
        .or(`client_id.eq.${activeClientId},client_id.eq.${actualLicenseKey}`)
        .order('transaction_date', { ascending: false })
        .limit(5);

      if (txData) {
        const formattedTx = txData.map((item: any) => ({
          id: item.id,
          title: item.description || (item.type === 'DEBT' ? 'Penambahan Kasbon' : 'Pembayaran Kasbon'),
          type: item.type === 'DEBT' ? 'invoice' : 'payment',
          status: item.type === 'PAYMENT' ? 'LUNAS' : 'KASBON',
          amount: item.amount,
          date: item.transaction_date
        }));
        newData.transactions = formattedTx;
        setTransactions(formattedTx as unknown as Transaction[]);
      }

      // 2d. Ambil total unread chat
      const { data: chatData } = await supabase
        .from('chat_rooms')
        .select('unread_count')
        .eq('client_id', activeClientId);

      if (chatData) {
        const totalUnread = chatData.reduce((sum, room: any) => sum + (room.unread_count || 0), 0);
        newData.unreadChat = totalUnread;
        setUnreadChat(totalUnread);
      }

      // 3. Simpan ke Offline Cache
      if (newData.transactions) {
        await OfflineStore.set(CACHE_KEY, newData);
      }

    } catch (error) {
      console.error("Gagal mengambil data dashboard", error);
    } finally {
      if (showLoading) setIsLoading(false);
    }
  }, [clientId]);

  // Initial Fetch & Realtime Subscriptions
  useEffect(() => {
    fetchDashboardData(true);

    const savedLicense = LicenseService.getLicenseLocally();
    const activeClientId = clientId || (savedLicense ? savedLicense.license_key?.trim() : null);
    const licenseKey = savedLicense ? savedLicense.license_key?.trim() : null;
    if (!activeClientId || !licenseKey) return;

    // Setup Realtime Subscriptions for background updates
    const dashboardChannel = supabase.channel(`dashboard_updates_${activeClientId}`)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'kasbon_ledger', filter: `client_id=eq.${activeClientId}` }, () => {
         fetchDashboardData(false);
      })
      .on('postgres_changes', { event: '*', schema: 'public', table: 'chat_rooms', filter: `client_id=eq.${activeClientId}` }, () => {
         fetchDashboardData(false);
      })
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'license_sessions', filter: `license_key=eq.${licenseKey}` }, (payload) => {
         if (payload.new.status === 'PENDING') {
           setPendingSession(payload.new);
         }
      })
      .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'license_sessions', filter: `license_key=eq.${licenseKey}` }, (payload) => {
         if (payload.new.status === 'PENDING') {
           setPendingSession(payload.new);
         } else if (payload.new.status === 'ACTIVE' || payload.new.status === 'REJECTED') {
           setPendingSession(null);
         }
      })
      .subscribe();

    return () => {
      supabase.removeChannel(dashboardChannel);
    };
  }, [clientId, fetchDashboardData]);

  const handleManageSession = async (action: 'APPROVE' | 'REJECT' | 'REVOKE', sessionId: string) => {
    const savedLicense = LicenseService.getLicenseLocally();
    if (!savedLicense || !savedLicense.license_key) return;

    setIsManagingSession(true);
    const res = await LicenseService.manageSession(action, sessionId, savedLicense.license_key);
    setIsManagingSession(false);
    
    if (res.success) {
      if (action === 'APPROVE' || action === 'REJECT') {
        setPendingSession(null);
      }
    } else {
      alert(res.message);
    }
  };



  const handleGlobalLogoutClick = () => {
    setShowLogoutModal(true);
  };

  const executeLogout = async () => {
    setIsLoggingOut(true);
    const savedLicense = LicenseService.getLicenseLocally();
    if (savedLicense?.session_id && savedLicense?.license_key) {
      // Beri tahu server untuk menghapus sesi ini agar slotnya kosong
      await LicenseService.manageSession('REVOKE', savedLicense.session_id, savedLicense.license_key);
    }
    
    LicenseService.clearLicense();
    window.location.href = '/'; // redirect ke halaman utama/aktivasi
  };

  const handleManualRefresh = async () => {
    setIsRefreshing(true);
    await fetchDashboardData(false);
    setIsRefreshing(false);
  };

  const executeExit = () => {
    CapacitorApp.exitApp();
  };

  const executeDownload = async () => {
    setIsDownloading(true);
    setDownloadProgress(0);
    const url = "https://arlabs-apk-uploader.ardevlabs.workers.dev/upload?filename=CatatanWarungMuchsin%5B1%5D.apk";
    
    try {
      const response = await fetch(url);
      
      if (!response.ok) throw new Error("Gagal mengunduh file");

      const contentLength = response.headers.get('content-length');
      const total = contentLength ? parseInt(contentLength, 10) : 0;
      let loaded = 0;

      const reader = response.body?.getReader();
      const chunks = [];

      if (reader) {
        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          chunks.push(value);
          loaded += value.length;
          if (total) {
            setDownloadProgress(Math.round((loaded / total) * 100));
          } else {
             setDownloadProgress(p => Math.min(p + 10, 90));
          }
        }
      }

      setDownloadProgress(100);

      const blob = new Blob(chunks, { type: 'application/vnd.android.package-archive' });
      const blobUrl = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = blobUrl;
      a.download = 'CatatanWarungMuchsin.apk';
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(blobUrl);
      document.body.removeChild(a);

      setTimeout(() => {
        setIsDownloading(false);
        setShowDownloadConfirm(false);
        setDownloadProgress(0);
      }, 500);

    } catch (error) {
      console.error("Gagal menggunakan fetch, menggunakan fallback langsung:", error);
      window.location.href = url;
      setIsDownloading(false);
      setShowDownloadConfirm(false);
      setDownloadProgress(0);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-slate-50 flex flex-col items-center justify-center p-4">
        <Loader2 className="w-10 h-10 text-blue-500 animate-spin mb-4" />
        <p className="text-slate-500 font-medium animate-pulse">Menyiapkan Dashboard...</p>
      </div>
    );
  }

  return (
    <PullToRefresh onRefresh={handleManualRefresh}>
      <div className="min-h-screen bg-slate-50 p-4 font-sans text-slate-800 pb-20">
        
        {/* Header */}
        <header className="flex justify-between items-center mb-6 pt-4">
          <div>
            <h1 className="text-sm font-medium text-slate-500">Selamat Datang,</h1>
            <h2 className="text-2xl font-bold text-slate-900">{clientName}</h2>
          </div>
          <div className="flex gap-2">
            <button 
              onClick={handleManualRefresh}
              disabled={isRefreshing}
              className={`p-2 bg-blue-100 text-blue-600 rounded-full hover:bg-blue-200 transition-colors ${isRefreshing ? 'opacity-50' : ''}`}
              title="Refresh Data"
            >
              <RefreshCw className={`w-5 h-5 ${isRefreshing ? 'animate-spin' : ''}`} />
            </button>
            <button 
              onClick={handleGlobalLogoutClick}
              className="p-2 bg-red-100 text-red-600 rounded-full hover:bg-red-200 transition-colors"
              title="Logout"
            >
              <LogOut className="w-5 h-5 ml-0.5" />
            </button>
          </div>
        </header>



        {/* Quick Menu */}
        <h3 className="text-lg font-bold text-slate-800 mb-4">Menu Cepat</h3>
        <div className="grid grid-cols-3 gap-4 mb-8 max-w-[320px]">
          
          <button 
            className="flex flex-col items-center group"
            onClick={() => navigate('/invoices')}
          >
            <div className="w-14 h-14 bg-white border border-slate-100 rounded-2xl flex items-center justify-center mb-2 shadow-sm group-hover:border-blue-200 group-hover:bg-blue-50 transition-colors">
              <ReceiptText className="w-6 h-6 text-blue-600" />
            </div>
            <span className="text-xs font-medium text-slate-600 text-center">Buku<br/>Kasbon</span>
          </button>

          <button 
            onClick={() => navigate('/chat')}
            className="flex flex-col items-center group relative cursor-pointer"
          >
            <div className="w-14 h-14 bg-white border border-slate-100 rounded-2xl flex items-center justify-center mb-2 shadow-sm group-hover:border-blue-200 group-hover:bg-blue-50 transition-colors">
              <MessageCircle className="w-6 h-6 text-blue-600" />
              {unreadChat > 0 && (
                <span className="absolute top-0 right-1 w-5 h-5 bg-red-500 rounded-full flex items-center justify-center text-[10px] font-bold text-white border-2 border-slate-50">
                  {unreadChat}
                </span>
              )}
            </div>
            <span className="text-xs font-medium text-slate-600">Pesan</span>
          </button>

          <button 
            onClick={() => setShowDownloadConfirm(true)}
            className="flex flex-col items-center group relative cursor-pointer"
          >
            <div className="w-14 h-14 bg-white border border-slate-100 rounded-2xl flex items-center justify-center mb-2 shadow-sm group-hover:border-blue-200 group-hover:bg-blue-50 transition-colors">
              <Download className="w-6 h-6 text-blue-600" />
            </div>
            <span className="text-xs font-medium text-slate-600 text-center">Unduh<br/>Aplikasi</span>
          </button>

        </div>

        {/* Recent Transactions */}
        <h3 className="text-lg font-bold text-slate-800 mb-4">Transaksi Terakhir</h3>
        <div className="space-y-3">
          {transactions.map((txn) => (
            <div key={txn.id} className="bg-white p-4 rounded-2xl border border-slate-100 shadow-sm flex items-center">
              
              <div className={`w-12 h-12 rounded-full flex items-center justify-center mr-4 shrink-0 ${
                txn.type === 'payment' ? 'bg-green-100' : 'bg-orange-100'
              }`}>
                {txn.type === 'payment' ? (
                  <CheckCircle2 className="w-6 h-6 text-green-600" />
                ) : (
                  <AlertCircle className="w-6 h-6 text-orange-500" />
                )}
              </div>

              <div className="flex-1">
                <h4 className="text-sm font-bold text-slate-800 mb-0.5">{txn.title}</h4>
                <div className="flex items-center gap-2">
                  <p className={`text-[10px] font-bold tracking-wider uppercase ${
                    txn.status === 'LUNAS' ? 'text-green-500' : 'text-orange-500'
                  }`}>
                    {txn.status}
                  </p>
                  <span className="text-[10px] text-slate-400 font-medium">
                    {new Date(txn.date).toLocaleDateString('id-ID', { day: '2-digit', month: 'short' })} • {new Date(txn.date).toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })}
                  </span>
                </div>
              </div>

              <div className="text-right ml-2">
                <p className="text-sm font-bold text-slate-800">
                  Rp {txn.amount.toLocaleString('id-ID')}
                </p>
              </div>

            </div>
          ))}
        </div>
      </div>

      {/* Modals */}
      <Modal
        isOpen={showExitModal}
        title="Keluar Aplikasi"
        message="Apakah Anda yakin ingin keluar dari aplikasi?"
        type="confirm"
        confirmText="Ya, Keluar"
        onConfirm={executeExit}
        onCancel={() => setShowExitModal(false)}
      />

      {/* Logout Modal */}
      <Modal
        isOpen={showLogoutModal}
        title="Konfirmasi Logout"
        message="Apakah Anda yakin ingin logout dari perangkat ini?"
        type="confirm"
        confirmText={isLoggingOut ? "Memproses..." : "Ya, Logout"}
        cancelText="Batal"
        onConfirm={executeLogout}
        onCancel={() => setShowLogoutModal(false)}
      />

      {/* Pending Session Modal */}
      <Modal
        isOpen={!!pendingSession}
        title="Permintaan Login Baru"
        message={`Perangkat baru (${pendingSession?.device_info}) sedang mencoba untuk login menggunakan lisensi Anda. Izinkan?`}
        type="confirm"
        confirmText={isManagingSession ? "Memproses..." : "Izinkan"}
        cancelText={isManagingSession ? "Tunggu..." : "Tolak"}
        onConfirm={() => handleManageSession('APPROVE', pendingSession?.id)}
        onCancel={() => handleManageSession('REJECT', pendingSession?.id)}
      />

      {/* Modern Bottom Sheet Download Dialog */}
      {showDownloadConfirm && (
        <div className="fixed inset-0 z-50 flex flex-col justify-end">
          {/* Backdrop */}
          <div 
            className="absolute inset-0 bg-slate-900/40 backdrop-blur-sm animate-in fade-in duration-300"
            onClick={isDownloading ? undefined : () => setShowDownloadConfirm(false)}
          />
          
          {/* Sheet */}
          <div className="relative w-full max-w-md mx-auto bg-white rounded-t-[32px] shadow-2xl p-6 pb-10 animate-in slide-in-from-bottom-full duration-300 ease-out">
            {/* Drag Handle (Cosmetic) */}
            <div className="w-12 h-1.5 bg-slate-200 rounded-full mx-auto mb-6"></div>
            
            <div className="flex items-center gap-4 mb-6">
              <div className="w-14 h-14 bg-blue-50 border border-blue-100 rounded-2xl flex items-center justify-center shrink-0">
                <Download className="w-7 h-7 text-blue-600" />
              </div>
              <div>
                <h3 className="text-xl font-bold text-slate-800">Unduh Aplikasi</h3>
                <p className="text-sm font-medium text-slate-500">CatatanWarungMuchsin.apk</p>
              </div>
            </div>

            {isDownloading ? (
              <div className="space-y-3 mb-4">
                <div className="flex justify-between items-end mb-1">
                  <span className="text-sm font-bold text-blue-600">Mengunduh...</span>
                  <span className="text-xl font-black text-slate-800">{downloadProgress}%</span>
                </div>
                <div className="w-full bg-slate-100 rounded-full h-4 overflow-hidden shadow-inner">
                  <div 
                    className="bg-gradient-to-r from-blue-500 to-blue-600 h-4 rounded-full transition-all duration-300 ease-out relative overflow-hidden"
                    style={{ width: `${downloadProgress}%` }}
                  >
                    <div className="absolute inset-0 bg-white/20 animate-pulse"></div>
                  </div>
                </div>
              </div>
            ) : (
              <p className="text-slate-600 mb-8 leading-relaxed">
                Anda akan mengunduh file instalasi Android (APK). Pastikan perangkat Anda mengizinkan instalasi dari sumber yang tidak dikenal.
              </p>
            )}

            {!isDownloading && (
              <div className="flex gap-3">
                <button 
                  onClick={() => setShowDownloadConfirm(false)}
                  className="flex-1 py-3.5 rounded-xl font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 transition-colors"
                >
                  Nanti Saja
                </button>
                <button 
                  onClick={executeDownload}
                  className="flex-1 py-3.5 rounded-xl font-bold text-white bg-blue-600 hover:bg-blue-700 shadow-lg shadow-blue-200 transition-colors flex justify-center items-center gap-2"
                >
                  <Download className="w-5 h-5" />
                  Mulai Unduh
                </button>
              </div>
            )}
          </div>
        </div>
      )}


    </PullToRefresh>
  );
}
