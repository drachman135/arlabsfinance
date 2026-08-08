import { useState, useEffect, useCallback } from 'react';
import { ArrowLeft, Loader2, BookOpen, Wallet, RefreshCw } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../../core/supabase';
import { LicenseService } from '../../core/license/LicenseService';

import { OfflineStore } from '../../core/offline/OfflineStore';

interface KasbonEntry {
  id: string;
  description: string;
  type: 'DEBT' | 'PAYMENT';
  amount: number;
  transaction_date: string;
}

export function InvoicesScreen() {
  const navigate = useNavigate();
  const [ledger, setLedger] = useState<KasbonEntry[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);
  
  const activeClientId = LicenseService.getLicenseLocally()?.license_key;

  const fetchLedger = useCallback(async (showLoading = true) => {
    if (!activeClientId) {
      setIsLoading(false);
      return;
    }

    const CACHE_KEY = `invoices_data_${activeClientId}`;

    try {
      if (showLoading) {
        const cached = await OfflineStore.get<KasbonEntry[]>(CACHE_KEY);
        if (cached) {
          setLedger(cached);
          setIsLoading(false);
        } else {
          setIsLoading(true);
        }
      }

      const { data, error } = await supabase
        .from('kasbon_ledger')
        .select('*')
        .eq('client_id', activeClientId)
        .order('transaction_date', { ascending: false });

      if (error) {
        console.error("Error fetching kasbon:", error);
      } else if (data) {
        setLedger(data as KasbonEntry[]);
        await OfflineStore.set(CACHE_KEY, data);
      }
    } catch (err) {
      console.error("Gagal memuat kasbon:", err);
    } finally {
      if (showLoading) setIsLoading(false);
    }
  }, [activeClientId]);

  useEffect(() => {
    fetchLedger(true);
  }, [fetchLedger]);

  const handleManualRefresh = async () => {
    setIsRefreshing(true);
    await fetchLedger(false);
    setIsRefreshing(false);
  };

  // Kalkulasi
  const totalDebt = ledger.filter(l => l.type === 'DEBT').reduce((sum, l) => sum + Number(l.amount || 0), 0);
  const totalPaid = ledger.filter(l => l.type === 'PAYMENT').reduce((sum, l) => sum + Number(l.amount || 0), 0);
  const outstanding = totalDebt - totalPaid;

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
            <div className="flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-blue-600" />
              <h1 className="font-bold text-slate-800 text-lg">Buku Kasbon</h1>
            </div>
          </div>
          <button 
            onClick={handleManualRefresh}
            disabled={isRefreshing}
            className={`p-2 bg-blue-100 text-blue-600 rounded-full hover:bg-blue-200 transition-colors ${isRefreshing ? 'opacity-50' : ''}`}
            title="Refresh Data"
          >
            <RefreshCw className={`w-5 h-5 ${isRefreshing ? 'animate-spin' : ''}`} />
          </button>
        </div>

        {/* Ringkasan Saldo (Sticky) */}
        <div className="p-4 bg-slate-50 z-10 shrink-0">
          <div className="bg-gradient-to-br from-slate-800 to-slate-900 rounded-3xl p-6 shadow-xl text-white relative overflow-hidden">
            <div className="absolute top-0 right-0 w-32 h-32 bg-white/5 rounded-bl-full pointer-events-none"></div>
            
            <div className="flex items-center gap-2 mb-2">
              <Wallet className="w-4 h-4 text-slate-400" />
              <p className="text-sm font-medium text-slate-300">Sisa Kasbon Anda</p>
            </div>
            
            <h3 className="text-4xl font-bold mb-6 text-yellow-400">
              Rp {Math.max(0, outstanding).toLocaleString('id-ID')}
            </h3>
            
            <div className="grid grid-cols-2 gap-4 border-t border-slate-700 pt-4">
              <div>
                <p className="text-xs font-medium text-slate-400 mb-1">Total Kasbon</p>
                <p className="text-sm font-bold text-red-400">Rp {totalDebt.toLocaleString('id-ID')}</p>
              </div>
              <div>
                <p className="text-xs font-medium text-slate-400 mb-1">Sudah Dibayar</p>
                <p className="text-sm font-bold text-green-400">Rp {totalPaid.toLocaleString('id-ID')}</p>
              </div>
            </div>
          </div>
        </div>

        <div className="flex-1 overflow-y-auto px-4 pb-4">
          <h2 className="font-bold text-slate-700 mb-4 px-1">Riwayat Transaksi</h2>
          
          {isLoading ? (
            <div className="flex justify-center items-center py-10">
              <Loader2 className="w-8 h-8 text-blue-500 animate-spin" />
            </div>
          ) : ledger.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-40 text-slate-400 bg-white rounded-3xl border border-slate-100 shadow-sm">
              <BookOpen className="w-10 h-10 mb-2 opacity-30" />
              <p className="text-sm font-medium">Buku kasbon masih kosong.</p>
            </div>
          ) : (
            <div className="mb-10 space-y-3">
              
              {ledger.map((entry) => {
                const isDebt = entry.type === 'DEBT';
                
                return (
                  <div key={entry.id} className="relative flex items-center justify-between group">
                    <div className="bg-white p-4 rounded-2xl shadow-sm border border-slate-100 w-full hover:shadow-md transition-shadow">
                      {entry.description && entry.description.trim() !== '' ? (
                        <>
                          <div className="flex justify-between items-start mb-2">
                            <h4 className="font-bold text-slate-800 text-sm leading-tight pr-4">
                              {entry.description}
                            </h4>
                            <p className={`font-bold whitespace-nowrap text-sm ${isDebt ? 'text-red-500' : 'text-green-500'}`}>
                              {isDebt ? '+' : '-'} Rp {Number(entry.amount || 0).toLocaleString('id-ID')}
                            </p>
                          </div>
                          
                          <p className="text-[11px] text-slate-400 font-medium">
                            {new Date(entry.transaction_date).toLocaleDateString('id-ID', { 
                              day: 'numeric', month: 'short', year: 'numeric',
                              hour: '2-digit', minute: '2-digit'
                            })}
                          </p>
                        </>
                      ) : (
                        <div className="flex justify-between items-center">
                          <p className="text-[11px] text-slate-400 font-medium">
                            {new Date(entry.transaction_date).toLocaleDateString('id-ID', { 
                              day: 'numeric', month: 'short', year: 'numeric',
                              hour: '2-digit', minute: '2-digit'
                            })}
                          </p>
                          <p className={`font-bold whitespace-nowrap text-sm ${isDebt ? 'text-red-500' : 'text-green-500'}`}>
                            {isDebt ? '+' : '-'} Rp {Number(entry.amount || 0).toLocaleString('id-ID')}
                          </p>
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
  );
}
