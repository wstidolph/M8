"use client";

import React from "react";

export type DeviceProfile = "phone" | "watch" | "desktop";

interface DevicePreviewProps {
  text: string;
  profile: DeviceProfile;
  isPure?: boolean;
}

export const DevicePreview: React.FC<DevicePreviewProps> = ({ text, profile, isPure = false }) => {
  // Config for different profiles
  const profiles = {
    phone: {
      width: "360px", // 9:16 Alignment (Feature 006)
      height: "640px",
      radius: "3rem",
      border: "8px",
      orbSize: "w-64 h-64",
      windowSize: "w-32 h-32",
      fontSize: "text-[10px]",
    },
    watch: {
      width: "300px",
      height: "300px",
      radius: "full",
      border: "12px",
      orbSize: "w-56 h-56",
      windowSize: "w-28 h-28",
      fontSize: "text-[9px]",
      isCircular: true,
    },
    desktop: {
      width: "480px",
      height: "320px",
      radius: "1rem",
      border: "4px",
      orbSize: "w-48 h-48",
      windowSize: "w-24 h-24",
      fontSize: "text-[8px]",
    }
  };

  const config = profiles[profile];

  return (
    <div className="flex flex-col items-center gap-6">
      {/* Device Frame */}
      <div 
        className="relative bg-slate-950 shadow-2xl flex flex-col items-center overflow-hidden transition-all duration-500 ease-in-out"
        style={{ 
          width: config.width, 
          height: config.height, 
          borderRadius: config.radius === "full" ? "50%" : config.radius,
          border: isPure ? "none" : `${config.border} solid #1e293b`, // Pure Mode (C1)
        }}
      >
        {/* Hardware details (Phone Notch) - Zero UI: Hide if Pure */}
        {!isPure && profile === "phone" && (
          <div className="absolute top-0 w-full flex justify-center z-20">
            <div className="w-32 h-6 bg-slate-800 rounded-b-2xl" />
          </div>
        )}

        {/* The M8 Simulation View */}
        <div className="absolute inset-0 bg-linear-to-b from-slate-900 to-black flex items-center justify-center overflow-hidden">
          
          {/* Glowing Orb */}
          <div className={`relative ${config.orbSize} flex items-center justify-center`}>
            {/* Pulsating Ambience - Feature 006 (G1) */}
            <div className="absolute inset-0 bg-blue-600/20 rounded-full blur-2xl animate-orb-pulsate" />
            
            <div className="absolute inset-4 bg-linear-to-br from-indigo-500/40 to-blue-900/80 rounded-full backdrop-blur-sm border border-blue-400/20 shadow-[0_0_50px_rgba(59,130,246,0.3)] animate-orb-pulsate" />
            
            {/* Answer Window */}
            <div className={`relative z-10 ${config.windowSize} flex items-center justify-center`}>
              <div 
                className="absolute inset-0 bg-blue-950/80 border border-blue-500/30 shadow-inner flex items-center justify-center p-2"
                style={{ clipPath: 'polygon(50% 0%, 0% 100%, 100% 100%)' }}
              >
                <p className={`text-blue-100 font-bold text-center leading-tight tracking-wider font-outfit drop-shadow-[0_0_8px_rgba(255,255,255,0.8)] mt-6 ${config.fontSize} wrap-break-word uppercase max-w-[80%] mx-auto opacity-90 transition-all duration-300`}>
                  {text || "SEARCHING..."}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Shiny reflection */}
        {!isPure && <div className="absolute inset-0 bg-linear-to-tr from-transparent via-white/5 to-transparent pointer-events-none" />}
      </div>

      {!isPure && (
        <div className="text-center">
          <span className="text-[10px] text-slate-500 uppercase tracking-[0.2em] font-bold">
            {profile === "watch" ? "Circular Wearable Mode" : `${profile} Preview`}
          </span>
        </div>
      )}
    </div>
  );
};
