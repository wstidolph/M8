import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

/**
 * M8 User Connectivity Edge Function (012)
 * Purpose: Automated SMS (Twilio) & Email (Resend) Dispatcher.
 */

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY") || "";
const TWILIO_ACCOUNT_SID = Deno.env.get("TWILIO_ACCOUNT_SID") || "";
const TWILIO_AUTH_TOKEN = Deno.env.get("TWILIO_AUTH_TOKEN") || "";
const TWILIO_PHONE_NUMBER = Deno.env.get("TWILIO_PHONE_NUMBER") || "";

serve(async (req) => {
  const { type, payload } = await req.json();

  try {
    switch (type) {
      case "GIFT_INVITE":
        await sendInvite(payload);
        break;
      case "GUARDIAN_GATE":
        await sendGuardianReview(payload);
        break;
      case "GIFT_REJECTED":
        await sendRejectionFeedback(payload);
        break;
      default:
        throw new Error("Unknown notification type: " + type);
    }

    return new Response(JSON.stringify({ success: true }), { 
      headers: { "Content-Type": "application/json" } 
    });
  } catch (e: any) {
    console.error("Connectivity Failure:", e);
    return new Response(JSON.stringify({ error: e.message }), { 
      status: 500, 
      headers: { "Content-Type": "application/json" } 
    });
  }
});

async function sendInvite({ target, label, deepLink }: any) {
  const isEmail = target.includes("@");
  if (isEmail) {
    await sendWithResend(target, "A Mystical Gift from M8", `
      <h1>You have a new M8 Gift!</h1>
      <p>From: <strong>${label}</strong></p>
      <p>Tap to accept your mystical responses: <a href="${deepLink}">${deepLink}</a></p>
    `);
  } else {
    await sendWithTwilio(target, `M8: New gift from ${label}! Tap to accept: ${deepLink}`);
  }
}

async function sendGuardianReview({ guardianEmail, questionerName, reviewLink }: any) {
  await sendWithResend(guardianEmail, "Parental Review Required: M8 Mystical Content", `
    <h1>Attention: Parental Review Gateway</h1>
    <p>Your child (<strong>${questionerName}</strong>) has received mystical content that requires your approval.</p>
    <p>Please review and approve or reject here: <a href="${reviewLink}">${reviewLink}</a></p>
  `);
}

async function sendRejectionFeedback({ authorEmail, label, reason }: any) {
  await sendWithResend(authorEmail, "Update: Mystical Gift Status (Rejected)", `
    <p>Your gift "<strong>${label}</strong>" was reviewed by a Guardian and filtered.</p>
    <p><strong>Reason provided:</strong> ${reason}</p>
    <p>You can revise and resend from your Author Dashboard.</p>
  `);
}

// --- PROVIDER STUBS (Phase 1 Ready) ---

async function sendWithResend(to: string, subject: string, html: string) {
  if (!RESEND_API_KEY) {
    console.log("[MOCK REDEND] Sending Email to:", to, "Subject:", subject);
    return;
  }
  
  await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${RESEND_API_KEY}`,
    },
    body: JSON.stringify({
      from: "M8 Mystical <no-reply@m8.com>",
      to,
      subject,
      html,
    }),
  });
}

async function sendWithTwilio(to: string, body: string) {
  if (!TWILIO_ACCOUNT_SID) {
    console.log("[MOCK TWILIO] Sending SMS to:", to, "Body:", body);
    return;
  }

  const endpoint = `https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json`;
  const auth = btoa(`${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}`);

  await fetch(endpoint, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": `Basic ${auth}`,
    },
    body: new URLSearchParams({
      From: TWILIO_PHONE_NUMBER,
      To: to,
      Body: body,
    }).toString(),
  });
}
