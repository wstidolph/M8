"use client";

import { useState } from "react";
import { Loader2, CreditCard, ShieldCheck, ArrowRight } from "lucide-react";

interface MockPaymentModalProps {
  isOpen: boolean;
  amount: number;
  onConfirm: () => Promise<void>;
  onCancel: () => void;
}

export function MockPaymentModal({ isOpen, amount, onConfirm, onCancel }: MockPaymentModalProps) {
  const [isProcessing, setIsProcessing] = useState(false);
  const [step, setStep] = useState<"READY" | "PROCESSING" | "SUCCESS">("READY");

  if (!isOpen) return null;

  const handlePay = async () => {
    setIsProcessing(true);
    setStep("PROCESSING");
    
    // Artificial Latency to simulate gateway communication (Phase 1 Stub)
    await new Promise((resolve) => setTimeout(resolve, 2000));
    
    try {
      await onConfirm();
      setStep("SUCCESS");
      await new Promise((resolve) => setTimeout(resolve, 1000));
    } catch (e) {
      console.error(e);
      alert("Mock Payment Failed. Please try again.");
      setStep("READY");
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-6 bg-slate-950/60 backdrop-blur-md animate-in fade-in duration-300">
      <div className="w-full max-w-md bg-slate-900 border border-slate-800 rounded-3xl shadow-2xl overflow-hidden">
        {/* Header */}
        <div className="p-8 pb-4 text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-blue-500/10 rounded-full mb-4 border border-blue-500/20">
            <CreditCard className="w-8 h-8 text-blue-400" />
          </div>
          <h2 className="text-2xl font-bold text-white tracking-tight">Checkout Summary</h2>
          <p className="text-slate-400 mt-2">M8 custom set delivery</p>
        </div>

        {/* Amount Card */}
        <div className="px-8 mb-6">
          <div className="bg-slate-950/50 border border-slate-800 rounded-2xl p-6 flex justify-between items-center">
            <span className="text-slate-400 font-medium">Total to Pay</span>
            <span className="text-3xl font-black text-white decoration-blue-500 underline decoration-2 underline-offset-4">
              ${amount.toFixed(2)}
            </span>
          </div>
        </div>

        {/* Info/Notice */}
        <div className="px-8 space-y-4 mb-8">
            <div className="flex items-start gap-3 p-4 bg-blue-500/5 rounded-xl border border-blue-500/10">
                <ShieldCheck className="w-5 h-5 text-blue-400 shrink-0 mt-0.5" />
                <div>
                   <p className="text-sm font-bold text-blue-300 uppercase tracking-widest text-[10px]">Phase 1: Mock Payment</p>
                   <p className="text-xs text-slate-400 mt-1 leading-relaxed">
                     This is a simulated transaction. No real money will be charged during development.
                   </p>
                </div>
            </div>
        </div>

        {/* Actions */}
        <div className="p-8 pt-0 flex gap-3">
          <button
            onClick={onCancel}
            disabled={isProcessing}
            className="px-6 py-4 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-2xl font-bold transition-all"
          >
            Cancel
          </button>
          <button
            onClick={handlePay}
            disabled={isProcessing || step === "SUCCESS"}
            className={`flex-1 flex items-center justify-center gap-2 py-4 rounded-2xl font-bold transition-all shadow-lg ${
                step === "SUCCESS" 
                ? "bg-emerald-600 text-white"
                : "bg-blue-600 hover:bg-blue-500 text-white shadow-blue-900/20 active:scale-[0.98]"
            }`}
          >
            {isProcessing ? (
              <>
                <Loader2 className="w-5 h-5 animate-spin" />
                Processing...
              </>
            ) : step === "SUCCESS" ? (
              <>
                <ShieldCheck className="w-5 h-5" />
                Success!
              </>
            ) : (
              <>
                Pay With Mock Provider
                <ArrowRight className="w-4 h-4 ml-1 opacity-50" />
              </>
            )}
          </button>
        </div>

        {/* Footer/Trust */}
        <div className="text-center p-4 bg-slate-950/20 border-t border-slate-800/50 flex items-center justify-center gap-2">
            <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
            <span className="text-[10px] text-slate-500 uppercase tracking-widest font-bold">
                Secure Simulation Active
            </span>
        </div>
      </div>
    </div>
  );
}
