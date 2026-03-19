import { z } from "zod";

// ==========================================
// 1. User & Profiles
// ==========================================
export const UserRoleEnum = z.enum(["AUTHOR", "QUESTIONER", "ADMIN"]);
export type UserRole = z.infer<typeof UserRoleEnum>;

export const ProfileSchema = z.object({
  id: z.string().uuid(),
  date_of_birth: z.string().optional(), // ISO string from DB
  guardian_email: z.string().email().optional(),
  created_at: z.string(),
});
export type Profile = z.infer<typeof ProfileSchema>;

// ==========================================
// 2. AnswerSet (The mystical content container)
// ==========================================
export const TargetMethodEnum = z.enum(["EMAIL", "PHONE"]);
export type TargetMethod = z.infer<typeof TargetMethodEnum>;

export const AnswerSetStatusEnum = z.enum(["DRAFT", "ACTIVE", "ARCHIVED"]);
export type AnswerSetStatus = z.infer<typeof AnswerSetStatusEnum>;

export const AnswerSetSchema = z.object({
  set_id: z.string().uuid(),
  author_id: z.string().uuid(),
  target_method: TargetMethodEnum,
  label: z.string().max(255),
  status: AnswerSetStatusEnum,
  created_at: z.string(),
  updated_at: z.string(),
});
export type AnswerSet = z.infer<typeof AnswerSetSchema>;

// ==========================================
// 3. Answer (Individual responses)
// ==========================================
export const AnswerSchema = z.object({
  answer_id: z.string().uuid(),
  set_id: z.string().uuid(),
  response_text: z.string().max(70, "Response text must be 70 characters or less"),
  sequence_order: z.number().int().min(0).max(7),
});
export type Answer = z.infer<typeof AnswerSchema>;

// ==========================================
// 4. Gift (The invitation/distribution instance)
// ==========================================
export const GiftStatusEnum = z.enum([
  "PENDING_REVIEW", // Age-gated approval tank (F009)
  "ACTIVE",         // Ready for Questioner acceptance (F010)
  "ACCEPTED",       // Questioner has accepted the gift
  "REJECTED",       // Questioner has declined
  "DELETED",        // Author has revoked access
  "EXPIRED",        // Time-out
]);
export type GiftStatus = z.infer<typeof GiftStatusEnum>;

export const GiftSchema = z.object({
  gift_id: z.string().uuid(),
  set_id: z.string().uuid(),
  author_id: z.string().uuid(),
  target_contact: z.string(),
  status: GiftStatusEnum,
  sent_at: z.string(),
  expires_at: z.string().nullable(),
  reviewed_at: z.string().nullable(),
  reviewed_by: z.string().nullable(),
});
export type Gift = z.infer<typeof GiftSchema>;

// ==========================================
// 5. Transaction (Payments F011)
// ==========================================
export const TransactionStatusEnum = z.enum(["PENDING", "SUCCEEDED", "FAILED"]);
export type TransactionStatus = z.infer<typeof TransactionStatusEnum>;

export const TransactionSchema = z.object({
  txn_id: z.string().uuid(),
  user_id: z.string().uuid(),
  gift_id: z.string().uuid(),
  amount: z.number(),
  provider: z.string(), // e.g., 'STRIPE', 'MOCK'
  status: TransactionStatusEnum,
  created_at: z.string(),
});
export type Transaction = z.infer<typeof TransactionSchema>;
