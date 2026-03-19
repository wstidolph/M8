// M8 Profanity Filter Utility (PRD Section 4.3)
// A lightweight filter to prevent inappropriate mystical gifts.

const BLACKLIST = [
  "badword1", // Placeholder - in a real app, use a mature library or OpenAI Moderation API
  "badword2",
];

/**
 * Checks if a string contains prohibited content.
 * @param text The text to validate
 * @returns true if clean, false if inappropriate content was found
 */
export function isContentAppropriate(text: string): boolean {
  if (!text) return true;
  
  const normalized = text.toLowerCase();
  
  // Basic substring check for MVP
  for (const word of BLACKLIST) {
    if (normalized.includes(word)) return false;
  }
  
  return true;
}

/**
 * Validates an entire set of answers.
 * @param answers Array of response strings
 */
export function validateAnswerSet(answers: string[]): { isValid: boolean; flagged?: string } {
  for (const answer of answers) {
    if (!isContentAppropriate(answer)) {
      return { isValid: false, flagged: answer };
    }
  }
  return { isValid: true };
}
