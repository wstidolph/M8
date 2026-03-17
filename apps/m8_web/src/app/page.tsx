"use client";

import { useState } from "react";

export default function AuthorDashboard() {
  const [answers, setAnswers] = useState<string[]>(Array(8).fill(""));
  const [targetContact, setTargetContact] = useState("");
  const [label, setLabel] = useState("");
  const [activePreviewIndex, setActivePreviewIndex] = useState<number>(0);

  const handleAnswerChange = (index: number, value: string) => {
    if (value.length <= 70) {
      const newAnswers = [...answers];
      newAnswers[index] = value;
      setAnswers(newAnswers);
      setActivePreviewIndex(index);
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

      <div className="relative z-10 max-w-7xl mx-auto p-6 lg:p-12 min-h-screen flex flex-col">
        {/* Header */}
        <header className="mb-8 flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-extrabold tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-300">
              M8 Creator
            </h1>
            <p className="text-slate-400 mt-1">Craft your custom Answer Set</p>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-sm text-slate-400 border border-slate-800 rounded-full px-4 py-1.5 bg-slate-900/50">
              Draft Mode
            </span>
            <button className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white px-6 py-2 rounded-lg font-medium shadow-lg shadow-blue-900/20 transition-all">
              Checkout & Send
            </button>
          </div>
        </header>

        {/* Main Content Split */}
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
                    className="w-full bg-slate-950/50 border border-slate-700/50 rounded-lg px-4 py-3 text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-400 mb-2">Set Label</label>
                  <input 
                    type="text" 
                    placeholder='e.g. "From John"'
                    value={label}
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
                      activePreviewIndex === index ? 'border-blue-500/50 ring-1 ring-blue-500/20' : 'border-slate-800/50 hover:border-slate-700'
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
                      onChange={(e) => handleAnswerChange(index, e.target.value)}
                      className="flex-1 bg-transparent px-4 py-3 text-slate-200 placeholder-slate-600 focus:outline-none"
                    />
                    <div className={`pr-4 text-xs font-mono ${answer.length > 60 ? 'text-amber-400' : 'text-slate-500'}`}>
                      {answer.length}/70
                    </div>
                  </div>
                ))}
              </div>
            </section>
          </div>

          {/* Right Panel: The Device Preview */}
          <div className="lg:col-span-5 flex flex-col items-center justify-center lg:justify-start lg:sticky lg:top-12 h-full">
            <h3 className="text-sm font-medium text-slate-400 mb-6 uppercase tracking-widest">Live Device Preview</h3>
            
            {/* Mock Smartphone Frame */}
            <div className="relative w-[320px] h-[650px] bg-slate-950 rounded-[3rem] border-8 border-slate-800 shadow-2xl flex flex-col items-center overflow-hidden">
              
              {/* Phone Notch/Dynamic Island */}
              <div className="absolute top-0 w-full flex justify-center z-20">
                <div className="w-32 h-6 bg-slate-800 rounded-b-2xl" />
              </div>

              {/* The M8 Orb View Simulation */}
              <div className="absolute inset-0 bg-gradient-to-b from-slate-900 to-black flex items-center justify-center overflow-hidden">
                
                {/* The glowing orb background */}
                <div className="relative w-64 h-64 flex items-center justify-center">
                  <div className="absolute inset-0 bg-blue-600/20 rounded-full blur-2xl animate-pulse" />
                  <div className="absolute inset-4 bg-gradient-to-br from-indigo-500/40 to-blue-900/80 rounded-full backdrop-blur-sm border border-blue-400/20 shadow-[0_0_50px_rgba(59,130,246,0.3)]" />
                  
                  {/* The fluid/triangle window */}
                  <div className="relative z-10 w-32 h-32 flex items-center justify-center">
                     {/* Triangle shape using clip-path */}
                    <div 
                      className="absolute inset-0 bg-blue-950/80 border border-blue-500/30 shadow-inner flex items-center justify-center p-2"
                      style={{ clipPath: 'polygon(50% 0%, 0% 100%, 100% 100%)' }}
                    >
                      {/* Triangle Text */}
                      <p className="text-blue-100 font-bold text-center leading-tight tracking-wide drop-shadow-[0_0_8px_rgba(255,255,255,0.8)] mt-6 text-[10px] break-words uppercase max-w-[80%] mx-auto opacity-90 transition-all duration-300">
                        {previewText}
                      </p>
                    </div>
                  </div>
                </div>

              </div>

              {/* Shiny reflection overlay */}
              <div className="absolute inset-0 bg-gradient-to-tr from-transparent via-white/5 to-transparent pointer-events-none" />
            </div>

            <p className="text-slate-500 text-sm mt-8 text-center max-w-xs">
              Preview updates instantly as you type. Actual positioning may float dynamically on device.
            </p>
          </div>

        </div>
      </div>
    </div>
  );
}
