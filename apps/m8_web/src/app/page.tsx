import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
import { useRouter } from "next/navigation";
import { AnswerSetStatusEnum, TargetMethodEnum } from "@m8/shared";
import { User } from "@supabase/supabase-js";
import { DevicePreview, DeviceProfile } from "@/components/DevicePreview";
import { LibrarySidebar, AnswerSet } from "@/components/LibrarySidebar";
import { GiftsLog, Gift } from "@/components/GiftsLog";

type DashboardView = "CREATE" | "HISTORY";

export default function AuthorDashboard() {
  const [user, setUser] = useState<User | null>(null);
  const [view, setView] = useState<DashboardView>("CREATE");
  const [librarySets, setLibrarySets] = useState<AnswerSet[]>([]);
  const [gifts, setGifts] = useState<Gift[]>([]);
  const [activeSetId, setActiveSetId] = useState<string | null>(null);
  const [answers, setAnswers] = useState<string[]>(Array(8).fill(""));
  const [targetContact, setTargetContact] = useState("");
  const [label, setLabel] = useState("");
  const [activePreviewIndex, setActivePreviewIndex] = useState<number>(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [selectedProfile, setSelectedProfile] = useState<DeviceProfile>("phone");
  const [isPureMode, setIsPureMode] = useState(false);
  const router = useRouter();

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => subscription.unsubscribe();
  }, []);

  // Fetch library on user change
  useEffect(() => {
    if (user) {
      fetchLibrary();
      fetchGifts();
    } else {
      setLibrarySets([]);
      setGifts([]);
    }
  }, [user]);

  const fetchLibrary = async () => {
    const { data } = await supabase
      .from('AnswerSets')
      .select('*')
      .eq('author_id', user?.id)
      .eq('is_deleted', false)
      .order('created_at', { ascending: false });
    
    if (data) setLibrarySets(data);
  };

  const fetchGifts = async () => {
    const { data } = await supabase
      .from('gifts')
      .select('*, AnswerSets(label)')
      .eq('author_id', user?.id)
      .order('sent_at', { ascending: false });
    
    if (data) setGifts(data as unknown as Gift[]);
  };

  const handleRevokeGift = async (giftId: string) => {
    if (confirm("Revoke this gift? The Questioner will no longer be able to use these answers.")) {
      await supabase.from('gifts').update({ status: 'DELETED' }).eq('gift_id', giftId);
      fetchGifts();
    }
  };

  const loadSet = async (setId: string) => {
    const { data: answersData } = await supabase
      .from('Answers')
      .select('response_text, sequence_order')
      .eq('set_id', setId)
      .order('sequence_order', { ascending: true });
    
    if (answersData) {
      const newAnswers = Array(8).fill("");
      answersData.forEach(a => {
        newAnswers[a.sequence_order] = a.response_text;
      });
      setAnswers(newAnswers);
    }
  };

  const handleSelectSet = (set: AnswerSet) => {
    setActiveSetId(set.set_id);
    setLabel(set.label);
    loadSet(set.set_id);
  };

  const handleDeleteSet = async (setId: string) => {
    if (confirm("Are you sure you want to delete this mystical set? Existing gifts will remain active.")) {
      await supabase.from('AnswerSets').update({ is_deleted: true }).eq('set_id', setId);
      fetchLibrary();
      if (activeSetId === setId) handleNewSet();
    }
  };

  const handleCloneSet = async (set: AnswerSet) => {
    // 1. Create a copy with label change
    const newId = crypto.randomUUID();
    const { error: setError } = await supabase.from('AnswerSets').insert({
      set_id: newId,
      author_id: user?.id,
      label: `${set.label} (Copy)`,
      status: AnswerSetStatusEnum.enum.DRAFT,
      target_method: TargetMethodEnum.enum.EMAIL // Fallback
    });

    if (setError) return;

    // 2. Load and Copy answers
    const { data: sourceAnswers } = await supabase
      .from('Answers')
      .select('response_text, sequence_order')
      .eq('set_id', set.set_id);
    
    if (sourceAnswers) {
      const copies = sourceAnswers.map(a => ({
        answer_id: crypto.randomUUID(),
        set_id: newId,
        response_text: a.response_text,
        sequence_order: a.sequence_order
      }));
      await supabase.from('Answers').insert(copies);
    }

    fetchLibrary();
    alert("Set duplicated successfully.");
  };

  const handleNewSet = () => {
    setActiveSetId(null);
    setAnswers(Array(8).fill(""));
    setLabel("");
    setTargetContact("");
  };

  const handleAnswerChange = (index: number, value: string) => {
    if (value.length <= 70) {
      const newAnswers = [...answers];
      newAnswers[index] = value;
      setAnswers(newAnswers);
      setActivePreviewIndex(index);
    }
  };

  // Validation Logic (Principle IV / T006.5)
  const isTargetValid = targetContact.includes('@') 
    ? /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(targetContact) // Email Regex
    : targetContact.length >= 7 || targetContact.includes('-'); // Rough Phone check
  
  const hasMinAnswers = answers.filter(a => a.trim().length > 0).length >= 1;
  const canSubmit = isTargetValid && hasMinAnswers && !isSubmitting;
  const canSaveDraft = hasMinAnswers && !isSubmitting;

  const handleSaveDraft = async () => {
    if (!user) {
      alert("Please Sign In to save your mystical Answer Set.");
      router.push("/auth");
      return;
    }
    
    setIsSubmitting(true);
    try {
      const setId = activeSetId || crypto.randomUUID();
      const isEmail = targetContact.includes('@');
      const targetMethod = isEmail ? TargetMethodEnum.enum.EMAIL : TargetMethodEnum.enum.PHONE;

      // Upsert AnswerSet (Refactor T006.2)
      const { error: setError } = await supabase.from('AnswerSets').upsert({
        set_id: setId,
        author_id: user.id,
        target_method: targetMethod,
        label: label || "Mystic Draft",
        status: AnswerSetStatusEnum.enum.DRAFT,
        is_deleted: false,
        updated_at: new Date().toISOString(),
      });
      if (setError) throw setError;

      // Delete old and insert new answers (Clean slate upsert pattern)
      await supabase.from('Answers').delete().eq('set_id', setId);
      
      const answersToInsert = answers.map((responseText, index) => ({
        answer_id: crypto.randomUUID(),
        set_id: setId,
        response_text: responseText || "Concentrate and ask again",
        sequence_order: index,
      }));
      await supabase.from('Answers').insert(answersToInsert);

      setActiveSetId(setId);
      fetchLibrary();
      alert("Draft saved to library.");
    } catch (e: any) {
      alert("Save failed: " + e.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCheckout = async () => {
    if (!user) {
      alert("Please Sign In to save your mystical Answer Set.");
      router.push("/auth");
      return;
    }

    if (!isTargetValid) {
      alert("Please provide a valid target (Email or Phone Number).");
      return;
    }
    
    setIsSubmitting(true);
    
    try {
      let setId = activeSetId;

      // 1. If it's a new set, create it first
      if (!setId) {
        setId = crypto.randomUUID();
        const isEmail = targetContact.includes('@');
        const targetMethod = isEmail ? TargetMethodEnum.enum.EMAIL : TargetMethodEnum.enum.PHONE;

        const { error: setError } = await supabase.from('AnswerSets').insert({
          set_id: setId,
          author_id: user.id,
          target_method: targetMethod,
          label: label || "Mystic Responses",
          status: AnswerSetStatusEnum.enum.DRAFT,
        });
        if (setError) throw setError;

        const answersToInsert = answers.map((responseText, index) => ({
          answer_id: crypto.randomUUID(),
          set_id: setId,
          response_text: responseText || "Concentrate and ask again",
          sequence_order: index,
        }));
        const { error: answersError } = await supabase.from('Answers').insert(answersToInsert);
        if (answersError) throw answersError;
      }

      // 2. Check for Parental Review (US2)
      let initialStatus = 'ACTIVE';
      const { data: recipientProfile } = await supabase
        .from('profiles')
        .select('date_of_birth')
        .eq('email', targetContact)
        .single();
      
      if (recipientProfile?.date_of_birth) {
        const age = Math.floor((new Date().getTime() - new Date(recipientProfile.date_of_birth).getTime()) / 31557600000);
        if (age < 13) {
          initialStatus = 'PENDING_REVIEW';
        }
      }

      // 3. Create the Gift Instance (The actual delivery)
      const giftId = crypto.randomUUID();
      const { error: giftError } = await supabase.from('gifts').insert({
        gift_id: giftId,
        set_id: setId,
        author_id: user.id,
        target_contact: targetContact,
        status: initialStatus
      });

      if (giftError) throw giftError;

      const deepLink = `m8ball://accept?id=${giftId}`;
      alert(`Gift created! Distribution Link: ${deepLink}\n(Proceeding to Stripe Checkout simulation...)`);
      
      fetchLibrary();
      fetchGifts();
      setView("HISTORY");
    } catch (e: any) {
      console.error(e);
      alert("Failed to send gift: " + e.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  // The text currently shown in the "Orb" preview
  const previewText = answers[activePreviewIndex] || "Your answer here";

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 font-sans selection:bg-blue-500/30">
      {/* Background Graphic / Ambient Glow */}
      <div className="fixed inset-0 z-0 pointer-events-none overflow-hidden flex justify-center items-center">
        <div className="absolute top-[-20%] left-[-10%] w-[600px] h-[600px] bg-blue-600/10 rounded-full blur-[120px]" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[800px] h-[800px] bg-indigo-900/20 rounded-full blur-[150px]" />
      </div>

      <div className="relative z-10 min-h-screen flex">
        {/* Library Drawer - Feature 008 */}
        <div className="hidden lg:block">
          <LibrarySidebar 
            sets={librarySets}
            activeSetId={activeSetId || undefined}
            onSelect={handleSelectSet}
            onDelete={handleDeleteSet}
            onClone={handleCloneSet}
            onNew={handleNewSet}
          />
        </div>

        <div className="flex-1 max-w-7xl mx-auto p-6 lg:p-12 flex flex-col">
          {/* Header */}
          <header className="mb-8 flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-extrabold tracking-tight text-transparent bg-clip-text bg-linear-to-r from-blue-400 to-indigo-300">
                M8 Creator
              </h1>
              <p className="text-slate-400 mt-1">Craft your custom Answer Set</p>
            </div>
            <div className="flex items-center gap-4">
              {user ? (
                <div className="flex items-center gap-4">
                  <span className="text-sm text-slate-500 hidden sm:inline">{user.email}</span>
                  <button 
                    onClick={() => supabase.auth.signOut()}
                    className="text-sm text-slate-400 hover:text-red-400 transition-colors"
                  >
                    Log Out
                  </button>
                </div>
              ) : (
                <button 
                  onClick={() => router.push("/auth")}
                  className="text-sm text-blue-400 hover:text-blue-300 font-bold uppercase tracking-wider"
                >
                  Sign In
                </button>
              )}
              
            <div className="flex bg-slate-900 border border-slate-800 rounded-lg p-1 mr-4">
              <button 
                onClick={() => setView("CREATE")}
                className={`px-4 py-1.5 rounded-md text-xs font-bold transition-all ${
                  view === "CREATE" ? "bg-blue-600 text-white shadow-lg" : "text-slate-500 hover:text-slate-300"
                }`}
              >
                CREATE
              </button>
              <button 
                onClick={() => setView("HISTORY")}
                className={`px-4 py-1.5 rounded-md text-xs font-bold transition-all ${
                  view === "HISTORY" ? "bg-blue-600 text-white shadow-lg" : "text-slate-500 hover:text-slate-300"
                }`}
              >
                HISTORY
              </button>
            </div>

            <span className="text-sm text-slate-400 border border-slate-800 rounded-full px-4 py-1.5 bg-slate-900/50">
              {activeSetId ? "Editing Set" : "Draft Mode"}
            </span>
              <button 
                onClick={handleSaveDraft}
                disabled={!canSaveDraft}
                className="px-6 py-2 rounded-lg font-medium border border-slate-700 hover:bg-slate-800 text-slate-300 transition-all disabled:opacity-50"
              >
                Save Draft
              </button>
              <button 
                onClick={handleCheckout}
                disabled={!canSubmit}
                className={`px-6 py-2 rounded-lg font-medium shadow-lg transition-all ${
                  !canSubmit 
                    ? "bg-slate-800 text-slate-500 cursor-not-allowed border border-slate-700/50"
                    : "bg-linear-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white shadow-blue-900/20"
                }`}
              >
                {isSubmitting ? "Processing..." : "Checkout & Send"}
              </button>
            </div>
          </header>

          {/* Main Content Split */}
          {view === "CREATE" ? (
            <div className="flex-1 grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-16">
              
              {/* Left Panel: The Input Form */}
              <div className="lg:col-span-7 space-y-8">
                
                {/* Meta Information */}
                <section className="bg-slate-900/60 backdrop-blur-xl border border-slate-800/60 rounded-2xl p-6 shadow-xl">
                  <h2 className="text-xl font-semibold mb-4 text-slate-200">Delivery Details</h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-slate-400 mb-2">Target Questioner (Email/Phone)</label>
                      <input 
                        type="text" 
                        placeholder="e.g. 555-0199 or name@example.com"
                        value={targetContact}
                        onChange={(e) => setTargetContact(e.target.value)}
                        className={`w-full bg-slate-950/50 border rounded-lg px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 transition-all ${
                          targetContact.length > 0 && !isTargetValid 
                            ? "border-red-500/50 focus:ring-red-500/20" 
                            : "border-slate-700/50 focus:ring-blue-500 focus:border-transparent"
                        }`}
                      />
                      {targetContact.length > 0 && !isTargetValid && (
                        <p className="text-[10px] text-red-400 mt-2 uppercase tracking-widest font-bold">Invalid Format</p>
                      )}
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-400 mb-2">Set Label</label>
                      <input 
                        type="text" 
                        placeholder='e.g. "From John"'
                        value={label}
                        maxLength={30}
                        onChange={(e) => setLabel(e.target.value)}
                        className="w-full bg-slate-950/50 border border-slate-700/50 rounded-lg px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                      />
                    </div>
                  </div>
                </section>

                {/* Answer Inputs */}
                <section className="bg-slate-900/60 backdrop-blur-xl border border-slate-800/60 rounded-2xl p-6 shadow-xl">
                  <div className="flex justify-between items-end mb-6">
                    <div>
                      <h2 className="text-xl font-semibold text-slate-200">The 8 Answers</h2>
                      <p className="text-sm text-slate-400 mt-1">Keep it punchy. Max 70 characters each.</p>
                    </div>
                    <button className="text-sm text-blue-400 hover:text-blue-300 font-medium">
                      Load Common Answers
                    </button>
                  </div>

                  <div className="space-y-3">
                    {answers.map((answer, index) => (
                      <div 
                        key={index} 
                        className={`relative flex items-center bg-slate-950/40 border rounded-lg overflow-hidden transition-all ${
                          activePreviewIndex === index ? "border-blue-500/50 ring-1 ring-blue-500/20" : "border-slate-800/50 hover:border-slate-700"
                        }`}
                        onClick={() => setActivePreviewIndex(index)}
                      >
                        <div className="w-12 flex items-center justify-center font-mono text-slate-500 border-r border-slate-800/50 bg-slate-900/30">
                          {index + 1}
                        </div>
                        <input
                          type="text"
                          placeholder={`Mystical response #${index + 1}...`}
                          value={answer}
                          maxLength={70}
                          onChange={(e) => handleAnswerChange(index, e.target.value)}
                          className="flex-1 bg-transparent px-4 py-3 text-slate-200 placeholder-slate-600 focus:outline-none"
                        />
                        <div className={`pr-4 text-xs font-mono ${answer.length >= 70 ? "text-blue-400" : "text-slate-500"}`}>
                          {answer.length}/70
                        </div>
                      </div>
                    ))}
                  </div>
                </section>
              </div>

              {/* Right Panel: The Device Preview */}
              <div className="lg:col-span-5 flex flex-col items-center justify-center lg:justify-start lg:sticky lg:top-12 h-full">
                <h3 className="text-sm font-medium text-slate-400 mb-6 uppercase tracking-widest text-center">Live Device Preview</h3>
                
                <div className="flex bg-slate-900/80 p-1 rounded-xl border border-slate-800/80 mb-12 shadow-xl">
                  {(["phone", "watch", "desktop"] as DeviceProfile[]).map((profile) => (
                    <button 
                      key={profile}
                      onClick={() => setSelectedProfile(profile)}
                      className={`px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wider transition-all duration-300 ${
                        selectedProfile === profile 
                          ? "bg-blue-600 text-white shadow-[0_0_20px_rgba(37,99,235,0.4)]" 
                          : "text-slate-500 hover:text-slate-300"
                      }`}
                    >
                      {profile}
                    </button>
                  ))}
                </div>

                <div className="mb-12 flex items-center gap-3 bg-slate-900/50 px-4 py-2 rounded-full border border-slate-800">
                  <span className="text-[10px] text-slate-500 uppercase font-bold">Zero UI Mode</span>
                  <button 
                    onClick={() => setIsPureMode(!isPureMode)}
                    className={`w-10 h-5 rounded-full transition-all relative ${isPureMode ? "bg-blue-600" : "bg-slate-700"}`}
                  >
                    <div className={`absolute top-1 w-3 h-3 bg-white rounded-full transition-all ${isPureMode ? "left-6" : "left-1"}`} />
                  </button>
                </div>

                <DevicePreview 
                  text={previewText} 
                  profile={selectedProfile}
                  isPure={isPureMode}
                />

                <p className="text-slate-500 text-sm mt-8 text-center max-w-xs">
                  {isPureMode ? "Simulator decoupled from Creator UI controls (Principle I)." : "Live simulator with Creator-side debug metrics."}
                </p>
              </div>
            </div>
          ) : (
             <div className="flex-1 overflow-y-auto">
                <GiftsLog gifts={gifts} onRevoke={handleRevokeGift} />
             </div>
          )}
        </div>
      </div>
    </div>
  );
}
