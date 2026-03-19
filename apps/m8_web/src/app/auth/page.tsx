"use client";

import { useState } from "react";
import { supabase } from "@/lib/supabase";
import { useRouter } from "next/navigation";
import Link from "next/link";

export default function AuthPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [dob, setDob] = useState("");
  const [guardianEmail, setGuardianEmail] = useState("");
  const [isSignUp, setIsSignUp] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  // Age Calculation for UX
  const age = dob ? Math.floor((new Date().getTime() - new Date(dob).getTime()) / 31557600000) : null;
  const isUnderage = age !== null && age < 13;

  const handleAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);

    try {
      if (isSignUp) {
        if (isUnderage && !guardianEmail) {
          throw new Error("Parental Guardian Email is required for users under 13.");
        }

        const { error: signUpError } = await supabase.auth.signUp({ 
          email, 
          password,
          options: {
            emailRedirectTo: `${window.location.origin}/auth/callback`,
            data: {
              date_of_birth: dob,
              guardian_email: guardianEmail || null,
              is_age_verified: true,
            }
          }
        });
        if (signUpError) throw signUpError;
        alert("Check your email for the confirmation link!");
      } else {
        const { error: signInError } = await supabase.auth.signInWithPassword({ email, password });
        if (signInError) throw signInError;
        router.push("/");
        router.refresh();
      }
    } catch (err: any) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 flex items-center justify-center p-6 selection:bg-blue-500/30">
      {/* Background Glow */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden flex justify-center items-center">
        <div className="absolute w-[600px] h-[600px] bg-blue-600/10 rounded-full blur-[120px]" />
      </div>

      <div className="relative z-10 w-full max-w-md bg-slate-900/60 backdrop-blur-xl border border-slate-800/60 rounded-3xl p-8 shadow-2xl">
        <div className="text-center mb-8">
          <Link href="/" className="text-sm text-slate-500 hover:text-blue-400 transition-colors uppercase tracking-widest font-bold">
            ← Back to Preview
          </Link>
          <h1 className="text-3xl font-extrabold text-transparent bg-clip-text bg-linear-to-r from-blue-400 to-indigo-300 mt-4">
            {isSignUp ? "Join M8 Creator" : "Author Sign In"}
          </h1>
          <p className="text-slate-400 mt-2">
            {isSignUp ? "Secure your mystical creations." : "Manage your gifted answer sets."}
          </p>
        </div>

        {error && (
          <div className="mb-6 p-4 bg-red-900/20 border border-red-500/30 rounded-xl text-red-400 text-sm">
            {error}
          </div>
        )}

        <form onSubmit={handleAuth} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-slate-400 mb-2">Email Address</label>
            <input 
              type="email" 
              required
              placeholder="e.g. author@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-slate-950/50 border border-slate-700/50 rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-slate-400 mb-2">Password</label>
            <input 
              type="password" 
              required
              minLength={6}
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-slate-950/50 border border-slate-700/50 rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
            />
          </div>

          {isSignUp && (
            <div className="grid grid-cols-1 gap-4 pt-2">
              <div>
                <label className="block text-sm font-medium text-slate-400 mb-2">Birthdate (Age Verification)</label>
                <input 
                  type="date" 
                  required={isSignUp}
                  value={dob}
                  onChange={(e) => setDob(e.target.value)}
                  className="w-full bg-slate-950/50 border border-slate-700/50 rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all"
                />
              </div>
              {isUnderage && (
                <div className="animate-in fade-in slide-in-from-top-2 duration-300">
                  <label className="block text-sm text-orange-400 mb-2 uppercase tracking-widest text-[10px] font-bold">
                    Guardian Email (Required Under 13)
                  </label>
                  <input 
                    type="email" 
                    required={isUnderage}
                    placeholder="Parent/Guardian Email"
                    value={guardianEmail}
                    onChange={(e) => setGuardianEmail(e.target.value)}
                    className="w-full bg-orange-900/10 border border-orange-500/30 rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 focus:ring-orange-500 transition-all"
                  />
                  <p className="text-[10px] text-slate-500 mt-2">
                    M8 adheres to COPPA requirements. Gifted content requires parental approval.
                  </p>
                </div>
              )}
            </div>
          )}

          <button 
            type="submit"
            disabled={isLoading}
            className={`w-full py-4 rounded-xl font-bold shadow-lg transition-all mt-4 ${
              isLoading 
                ? 'bg-slate-700 text-slate-400 cursor-not-allowed'
                : 'bg-linear-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white shadow-blue-900/40'
            }`}
          >
            {isLoading ? 'Verifying...' : isSignUp ? 'Sign Up' : 'Sign In'}
          </button>
        </form>

        <div className="mt-8 text-center text-sm">
          <button 
            onClick={() => setIsSignUp(!isSignUp)}
            className="text-slate-400 hover:text-blue-400 transition-colors"
          >
            {isSignUp ? "Already have an account? Sign In" : "New to M8? Create an account"}
          </button>
        </div>

        <p className="mt-8 text-[10px] text-center text-slate-600 uppercase tracking-tighter">
          Adhere to the M8 Constitution v1.0
        </p>
      </div>
    </div>
  );
}
