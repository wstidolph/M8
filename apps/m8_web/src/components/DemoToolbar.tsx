import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { RefreshCcw, Bell, ShieldAlert, X } from "lucide-react";

export function DemoToolbar() {
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState<any[]>([]);
  const [isResetting, setIsResetting] = useState(false);

  useEffect(() => {
    if (!isOpen) return;

    // 1. Initial Fetch
    const fetchNotifications = async () => {
      const { data } = await supabase
        .from("demo_notifications")
        .select("*")
        .order("occurred_at", { ascending: false })
        .limit(5);
      setNotifications(data || []);
    };
    fetchNotifications();

    // 2. Realtime Subscription
    const channel = supabase
      .channel("demo-notifs")
      .on("postgres_changes", { event: "INSERT", schema: "public", table: "demo_notifications" }, 
         (payload) => setNotifications(prev => [payload.new, ...prev].slice(0, 5)))
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [isOpen]);

  const handleReset = async () => {
    setIsResetting(true);
    try {
      const { data, error } = await supabase.rpc("reset_mystical_state");
      if (error) throw error;
      alert("Mystical State Reset: " + data.message);
      window.location.reload();
    } catch (e: any) {
      alert("Reset failed: " + e.message);
    } finally {
      setIsResetting(false);
    }
  };

  return (
    <div className="fixed bottom-6 right-6 z-50 flex flex-col items-end gap-3 group">
      {/* Expanded Modal */}
      {isOpen && (
        <div className="w-80 bg-slate-900/90 backdrop-blur-2xl border border-blue-500/30 rounded-3xl p-6 shadow-2xl animate-in slide-in-from-bottom-4 duration-300">
          <div className="flex justify-between items-center mb-6">
            <h3 className="text-blue-400 font-bold uppercase tracking-widest text-xs flex items-center gap-2">
              <ShieldAlert className="w-4 h-4" /> Demo Toolbox
            </h3>
            <button onClick={() => setIsOpen(false)} className="text-slate-500 hover:text-white">
              <X className="w-4 h-4" />
            </button>
          </div>

          <button 
            onClick={handleReset}
            disabled={isResetting}
            className="w-full bg-slate-800 hover:bg-slate-700 text-slate-200 py-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-2 border border-slate-700"
          >
            <RefreshCcw className={`w-3 h-3 ${isResetting ? 'animate-spin' : ''}`} />
            {isResetting ? "Purging State..." : "Reset Environment"}
          </button>

          <div className="mt-8">
            <h4 className="text-slate-500 font-bold uppercase tracking-tight text-[10px] mb-3">
              Intercepted Messages
            </h4>
            <div className="space-y-3 max-h-60 overflow-y-auto pr-1 custom-scrollbar">
              {notifications.length === 0 ? (
                <p className="text-slate-600 text-[10px] italic">No notifications yet...</p>
              ) : (
                notifications.map(n => (
                  <div key={n.id} className="bg-slate-950/50 p-3 rounded-lg border border-slate-800/50 animate-in fade-in zoom-in-95 duration-200">
                    <p className="text-[10px] text-blue-400 font-bold mb-1 uppercase opacity-70">{n.type}</p>
                    <p className="text-[11px] text-slate-300 leading-relaxed font-mono">{n.body}</p>
                    <p className="text-[9px] text-slate-600 mt-2">
                      {new Date(n.occurred_at).toLocaleTimeString()}
                    </p>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      )}

      {/* Toggle Button */}
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="w-14 h-14 bg-blue-600 hover:bg-blue-500 text-white rounded-full shadow-xl shadow-blue-900/40 flex items-center justify-center transition-all hover:scale-110 active:scale-95"
      >
        <Bell className="w-6 h-6" />
        <span className="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full border-2 border-slate-950 animate-pulse" />
      </button>
    </div>
  );
}
