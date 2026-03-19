"use client";

import { CreditCard, Calendar, CheckCircle, Clock, AlertCircle } from "lucide-react";

export interface Transaction {
  txn_id: string;
  amount: number;
  currency: string;
  provider: string;
  status: "PENDING" | "SUCCEEDED" | "FAILED";
  created_at: string;
  gift_label?: string;
}

interface TransactionsLogProps {
  transactions: Transaction[];
}

export function TransactionsLog({ transactions }: TransactionsLogProps) {
  if (transactions.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center p-20 text-center border-2 border-dashed border-slate-800/50 rounded-3xl bg-slate-900/20">
        <div className="w-16 h-16 bg-slate-800/30 rounded-full flex items-center justify-center mb-4">
          <CreditCard className="w-8 h-8 text-slate-600" />
        </div>
        <h3 className="text-xl font-bold text-slate-300">No Transactions Yet</h3>
        <p className="text-slate-500 max-w-sm mt-2">
          When you distribute an Answer Set, receipt logic and payment history will appear here.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-4 animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div className="flex items-center gap-2 mb-6">
        <CreditCard className="w-5 h-5 text-blue-400" />
        <h2 className="text-xl font-bold text-white tracking-tight">Payment History</h2>
      </div>

      <div className="overflow-hidden bg-slate-900/40 border border-slate-800/50 rounded-2xl shadow-xl">
        <table className="w-full text-left">
          <thead>
            <tr className="bg-slate-950/50 border-b border-slate-800/80">
              <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest">Date</th>
              <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest">Description</th>
              <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest text-right">Amount</th>
              <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest text-center">Status</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-800/50">
            {transactions.map((txn) => (
              <tr key={txn.txn_id} className="hover:bg-blue-500/5 transition-colors group">
                <td className="px-6 py-5 whitespace-nowrap">
                  <div className="flex items-center gap-2">
                    <Calendar className="w-3 h-3 text-slate-500" />
                    <span className="text-sm font-medium text-slate-300">
                      {new Date(txn.created_at).toLocaleDateString()}
                    </span>
                  </div>
                </td>
                <td className="px-6 py-5">
                  <div className="flex flex-col">
                    <span className="text-sm font-bold text-slate-200">
                      Distribution: {txn.gift_label || "Mystic Gift"}
                    </span>
                    <span className="text-[10px] font-mono text-slate-500 uppercase mt-0.5">
                      REF: {txn.txn_id.slice(0, 8)}... via {txn.provider}
                    </span>
                  </div>
                </td>
                <td className="px-6 py-5 text-right font-mono font-bold text-white">
                  ${txn.amount.toFixed(2)}
                </td>
                <td className="px-6 py-5">
                  <div className="flex justify-center flex-col items-center">
                    {txn.status === "SUCCEEDED" ? (
                      <div className="flex items-center gap-1.5 px-3 py-1 bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 rounded-full text-[10px] font-black uppercase tracking-tighter">
                        <CheckCircle className="w-3 h-3" />
                        Success
                      </div>
                    ) : txn.status === "PENDING" ? (
                      <div className="flex items-center gap-1.5 px-3 py-1 bg-amber-500/10 border border-amber-500/20 text-amber-400 rounded-full text-[10px] font-black uppercase tracking-tighter">
                        <Clock className="w-3 h-3 animate-spin" />
                        Processing
                      </div>
                    ) : (
                      <div className="flex items-center gap-1.5 px-3 py-1 bg-red-500/10 border border-red-500/20 text-red-400 rounded-full text-[10px] font-black uppercase tracking-tighter">
                        <AlertCircle className="w-3 h-3" />
                        Failed
                      </div>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      
      {/* Simulation Notice for Phase 1 */}
      <div className="flex items-center gap-3 p-4 bg-slate-900/50 border border-slate-800 rounded-xl mt-6">
        <div className="w-2 h-2 bg-blue-500 rounded-full animate-pulse shrink-0" />
        <p className="text-xs text-slate-500 leading-relaxed italic">
          Phase 1: Displays both real and simulated transactions for auditing purposes. Real money is not moved for &quot;MOCK&quot; provider types.
        </p>
      </div>
    </div>
  );
}
