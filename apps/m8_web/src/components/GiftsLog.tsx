"use client";

import React from "react";

export interface Gift {
  gift_id: string;
  target_contact: string;
  status: 'ACTIVE' | 'DELETED' | 'EXPIRED';
  sent_at: string;
  expires_at: string;
  answer_sets: {
    label: string;
  };
}

interface GiftsLogProps {
  gifts: Gift[];
  onRevoke: (giftId: string) => void;
}

export const GiftsLog: React.FC<GiftsLogProps> = ({ gifts, onRevoke }) => {
  return (
    <div className="bg-slate-900/60 backdrop-blur-xl border border-slate-800/60 rounded-2xl p-8 shadow-xl">
      <h2 className="text-xl font-bold text-slate-100 mb-6">Mystical Delivery History</h2>
      
      <div className="overflow-x-auto">
        <table className="w-full text-left">
          <thead>
            <tr className="border-b border-slate-800 text-[10px] uppercase tracking-widest text-slate-500 font-bold">
              <th className="pb-4 px-4 font-bold">Label</th>
              <th className="pb-4 px-4 font-bold">Target</th>
              <th className="pb-4 px-4 font-bold">Status</th>
              <th className="pb-4 px-4 font-bold">Sent On</th>
              <th className="pb-4 px-4 text-right font-bold">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-800/50">
            {gifts.length === 0 && (
              <tr>
                <td colSpan={5} className="py-12 text-center text-slate-600 italic">
                  No mystical gifts sent yet.
                </td>
              </tr>
            )}
            
            {gifts.map((gift) => (
              <tr key={gift.gift_id} className="group hover:bg-white/5 transition-colors">
                <td className="py-4 px-4 text-sm font-semibold text-blue-200">
                  {gift.answer_sets?.label}
                </td>
                <td className="py-4 px-4 text-sm text-slate-400">
                  {gift.target_contact}
                </td>
                <td className="py-4 px-4">
                  <span className={`px-2 py-1 rounded-full text-[10px] font-bold uppercase ${
                    gift.status === 'ACTIVE' 
                      ? 'bg-green-500/10 text-green-400 border border-green-500/20' 
                      : gift.status === 'EXPIRED'
                      ? 'bg-orange-500/10 text-orange-400 border border-orange-500/20'
                      : 'bg-red-500/10 text-red-400 border border-red-500/20'
                  }`}>
                    {gift.status}
                  </span>
                </td>
                <td className="py-4 px-4 text-xs text-slate-500">
                  {new Date(gift.sent_at).toLocaleDateString()}
                </td>
                <td className="py-4 px-4 text-right">
                  {gift.status === 'ACTIVE' && (
                    <button 
                      onClick={() => onRevoke(gift.gift_id)}
                      className="text-xs font-bold text-red-500 hover:text-red-400 opacity-0 group-hover:opacity-100 transition-all uppercase tracking-tighter"
                    >
                      Revoke
                    </button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
