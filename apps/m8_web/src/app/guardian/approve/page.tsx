"use client";

import { useEffect, useState, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";

function ApproveContent() {
  const searchParams = useSearchParams();
  const giftId = searchParams.get("id");
  const [gift, setGift] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    if (giftId) {
      fetchGift();
    }
  }, [giftId]);

  const fetchGift = async () => {
    const { data } = await supabase
      .from("gifts")
      .select("*, AnswerSets(label)")
      .eq("gift_id", giftId)
      .single();
    
    setGift(data);
    setLoading(false);
  };

  const handleApprove = async () => {
    const { error } = await supabase
      .from("gifts")
      .update({ 
        status: "ACTIVE",
        reviewed_at: new Date().toISOString(),
        reviewed_by: "guardian-mock@m8.com" // Placeholder for real email tomorrow
      })
      .eq("gift_id", giftId);
    
    if (error) alert(error.message);
    else {
      alert("Gift approved! The Questioner can now accept these answers.");
      router.push("/");
    }
  };

  if (loading) return <div className="p-20 text-slate-500">Loading gift details...</div>;
  if (!gift) return <div className="p-20 text-red-500">Gift not found or invalid link.</div>;

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-center p-6">
      <div className="w-full max-w-lg bg-slate-900 border border-slate-800 rounded-3xl p-10 shadow-2xl">
        <h1 className="text-2xl font-bold text-white mb-2">Guardian Approval</h1>
        <p className="text-slate-400 mb-8">Review the content sent to your child.</p>
        
        <div className="bg-slate-950 rounded-2xl p-6 border border-slate-800 mb-8">
          <p className="text-[10px] text-slate-500 uppercase font-bold tracking-widest mb-1">Answer Set Label</p>
          <p className="text-lg text-blue-400 mb-4">{gift.AnswerSets?.label}</p>
          <p className="text-sm text-slate-400 italic">"Once approved, these responses will be available for their M8 Orb."</p>
        </div>

        <div className="flex gap-4">
          <button 
            onClick={handleApprove}
            className="flex-1 bg-blue-600 hover:bg-blue-500 text-white py-4 rounded-xl font-bold transition-all"
          >
            Approve Answers
          </button>
          <button 
            onClick={() => router.push("/")}
            className="px-8 bg-slate-800 hover:bg-slate-700 text-slate-300 py-4 rounded-xl font-bold transition-all"
          >
            Reject
          </button>
        </div>
      </div>
    </div>
  );
}

export default function GuardianApprovePage() {
  return (
    <Suspense fallback={<div className="p-20 text-slate-500">Loading...</div>}>
      <ApproveContent />
    </Suspense>
  );
}
