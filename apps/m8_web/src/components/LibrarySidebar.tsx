"use client";

import React from "react";

export interface AnswerSet {
  set_id: string;
  label: string;
  is_deleted: boolean;
  created_at: string;
}

interface LibrarySidebarProps {
  sets: AnswerSet[];
  activeSetId?: string;
  onSelect: (set: AnswerSet) => void;
  onDelete: (setId: string) => void;
  onClone: (set: AnswerSet) => void;
  onNew: () => void;
}

export const LibrarySidebar: React.FC<LibrarySidebarProps> = ({ 
  sets, 
  activeSetId, 
  onSelect, 
  onDelete, 
  onClone,
  onNew
}) => {
  return (
    <div className="w-full lg:w-72 flex flex-col h-full bg-slate-900/40 backdrop-blur-xl border-r border-slate-800/60 p-6 overscroll-contain">
      <div className="flex justify-between items-center mb-8">
        <h2 className="text-sm font-bold text-slate-500 uppercase tracking-widest">Library</h2>
        <button 
          onClick={onNew}
          className="text-blue-400 hover:text-blue-300 text-xs font-bold transition-colors"
        >
          + NEW SET
        </button>
      </div>

      <div className="flex-1 space-y-4 overflow-y-auto pr-2 custom-scrollbar">
        {sets.length === 0 && (
          <p className="text-xs text-slate-600 italic">No saved mystical templates yet.</p>
        )}
        
        {sets.map((set) => (
          <div 
            key={set.set_id}
            className={`group relative p-4 rounded-xl border transition-all cursor-pointer ${
              activeSetId === set.set_id 
                ? 'bg-blue-600/10 border-blue-500/40 shadow-[0_0_20px_rgba(37,99,235,0.1)]' 
                : 'bg-slate-900/40 border-slate-800/40 hover:border-slate-700/60'
            }`}
            onClick={() => onSelect(set)}
          >
            <div className="flex flex-col">
              <span className={`text-sm font-semibold truncate ${
                activeSetId === set.set_id ? 'text-blue-200' : 'text-slate-300'
              }`}>
                {set.label}
              </span>
              <span className="text-[10px] text-slate-600 mt-1 uppercase tracking-tighter">
                Created: {new Date(set.created_at).toLocaleDateString()}
              </span>
            </div>

            {/* Float Menu for Clone/Delete */}
            <div className="absolute right-2 top-2 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
               <button 
                onClick={(e) => { e.stopPropagation(); onClone(set); }}
                title="Clone Set"
                className="p-1.5 rounded-md hover:bg-indigo-500/20 text-indigo-400"
               >
                 <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                   <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 7v8a2 2 0 002 2h6M8 7V5a2 2 0 012-2h4.586a1 1 0 01.707.293l4.414 4.414a1 1 0 01.293.707V15a2 2 0 01-2 2h-2M8 7H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2v-2" />
                 </svg>
               </button>
               <button 
                onClick={(e) => { e.stopPropagation(); onDelete(set.set_id); }}
                title="Delete Set"
                className="p-1.5 rounded-md hover:bg-red-500/20 text-red-400"
               >
                 <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                   <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                 </svg>
               </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
