import { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { PushNotificationService } from './core/notifications/PushNotificationService';
import { NetworkMonitor } from './core/offline/NetworkMonitor';
import { SyncQueue } from './core/offline/SyncQueue';
import { useLicense } from './core/license/useLicense';
import { LicenseActivation } from './features/license/LicenseActivation';
import { ClientRegistration } from './features/auth/ClientRegistration';
import { Modal } from './components/ui/Modal';
import { LoginScreen } from './features/auth/LoginScreen';
import { DashboardScreen } from './features/dashboard/DashboardScreen';
import { ChatScreen } from './features/chat/ChatScreen';
import { InvoicesScreen } from './features/invoices/InvoicesScreen';
import { CustomSplashScreen } from './components/ui/CustomSplashScreen';

/**
 * Route Wrapper untuk mengecek lisensi
 */
const ProtectedLicenseRoute = ({ children }: { children: React.ReactNode }) => {
  const { isValidating, isLicenseActive, validationMessage } = useLicense();
  const location = useLocation();
  const [showModal, setShowModal] = useState(false);
  const [shouldRedirect, setShouldRedirect] = useState(false);

  useEffect(() => {
    if (validationMessage) {
      setShowModal(true);
    }
  }, [validationMessage]);

  useEffect(() => {
    if (isLicenseActive) {
      PushNotificationService.initialize();
    }
  }, [isLicenseActive]);

  const handleModalClose = () => {
    setShowModal(false);
    if (!isLicenseActive) {
      setShouldRedirect(true);
    }
  };

  if (isValidating) {
    return (
      <div className="min-h-screen bg-slate-900 flex flex-col items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-white mb-4"></div>
        <p className="text-slate-300 font-medium animate-pulse">Memvalidasi Lisensi...</p>
      </div>
    );
  }

  if (shouldRedirect || (!isLicenseActive && !validationMessage)) {
    return <Navigate to="/activation" state={{ from: location }} replace />;
  }

  if (!isLicenseActive && validationMessage) {
    return (
      <div className="min-h-screen bg-slate-50">
        <Modal 
          isOpen={showModal}
          title="Sesi Berakhir"
          message={validationMessage}
          type="alert"
          confirmText="Tutup"
          onConfirm={handleModalClose}
        />
      </div>
    );
  }

  return <>{children}</>;
};


/**
 * Main App Component
 */
function App() {
  const [showSplash, setShowSplash] = useState(true);

  useEffect(() => {
    const unsubscribe = NetworkMonitor.addListener((status) => {
      if (status.connected) {
        console.log('App is online. Processing sync queue...');
        SyncQueue.processQueue();
      }
    });

    return () => {
      unsubscribe();
    };
  }, []);

  if (showSplash) {
    return <CustomSplashScreen onFinish={() => setShowSplash(false)} />;
  }

  return (
    <BrowserRouter>
      <Routes>
        
        {/* Halaman Registrasi Klien */}
        <Route path="/register" element={<ClientRegistration />} />

        {/* Halaman Aktivasi Lisensi */}
        <Route 
          path="/activation" 
          element={
            <LicenseActivation 
              onActivationSuccess={() => window.location.href = '/'} // Refresh the app to re-validate
            />
          } 
        />

        {/* Halaman Login Biasa (Tergabung dalam Protected License) */}
        <Route 
          path="/login" 
          element={
            <ProtectedLicenseRoute>
              <LoginScreen 
                onNavigateToRegister={() => alert("Register belum tersedia")}
                onLoginSuccess={() => window.location.href = '/'}
              />
            </ProtectedLicenseRoute>
          } 
        />

        {/* Rute Utama (Dashboard) - Wajib punya lisensi */}
        <Route 
          path="/" 
          element={
            <ProtectedLicenseRoute>
              <DashboardScreen />
            </ProtectedLicenseRoute>
          } 
        />

        {/* Rute Chat - Wajib punya lisensi */}
        <Route 
          path="/chat" 
          element={
            <ProtectedLicenseRoute>
              <ChatScreen />
            </ProtectedLicenseRoute>
          } 
        />

        {/* Rute Piutang (Invoices) - Wajib punya lisensi */}
        <Route 
          path="/invoices" 
          element={
            <ProtectedLicenseRoute>
              <InvoicesScreen />
            </ProtectedLicenseRoute>
          } 
        />

        {/* Wildcard (Page Not Found fallback) */}
        <Route path="*" element={<Navigate to="/" replace />} />

      </Routes>
    </BrowserRouter>
  );
}

export default App;
