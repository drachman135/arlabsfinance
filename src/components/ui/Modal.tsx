import { X, CheckCircle2, AlertTriangle, AlertCircle } from 'lucide-react';

interface ModalProps {
  isOpen: boolean;
  title: string;
  message: string;
  type?: 'alert' | 'confirm';
  confirmText?: string;
  cancelText?: string;
  onConfirm: () => void;
  onCancel?: () => void;
}

export function Modal({ 
  isOpen, 
  title, 
  message, 
  type = 'alert',
  confirmText = 'OK',
  cancelText = 'Batal',
  onConfirm,
  onCancel
}: ModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-sm overflow-hidden animate-in zoom-in-95 duration-200">
        <div className="p-6 text-center">
          <h3 className="text-xl font-bold text-slate-800 mb-2">{title}</h3>
          <p className="text-slate-500 mb-6">{message}</p>
          
          <div className="flex gap-3 justify-center">
            {type === 'confirm' && (
              <button 
                onClick={onCancel}
                className="flex-1 py-2.5 px-4 rounded-xl font-semibold text-slate-600 bg-slate-100 hover:bg-slate-200 transition-colors"
              >
                {cancelText}
              </button>
            )}
            <button 
              onClick={onConfirm}
              className={`flex-1 py-2.5 px-4 rounded-xl font-semibold text-white transition-colors ${
                type === 'confirm' ? 'bg-red-500 hover:bg-red-600' : 'bg-blue-600 hover:bg-blue-700'
              }`}
            >
              {confirmText}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
