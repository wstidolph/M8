import { z } from "zod";

// ==========================================
// 1. User
// ==========================================
export const UserRoleEnum = z.enum(["AUTHOR", "QUESTIONER", "ADMIN"]);
export type UserRole = z.infer<typeof UserRoleEnum>;

export const AuthMethodEnum = z.enum(["EMAIL", "PHONE", "OAUTH"]);
export type AuthMethod = z.infer<typeof AuthMethodEnum>;

export const UserSchema = z.object({
  user_id: z.string().uuid(),
  auth_method: AuthMethodEnum,
  email_address: z.string().email().optional(),
  phone_number: z.string().optional(),
  role: UserRoleEnum,
  is_underage: z.boolean().default(false),
  date_of_birth: z.coerce.date().optional(),
  created_at: z.coerce.date(),
  last_login: z.coerce.date().optional(),
});
export type User = z.infer<typeof UserSchema>;

// ==========================================
// 2. AnswerSet
// ==========================================
export const TargetMethodEnum = z.enum(["EMAIL", "PHONE"]);
export type TargetMethod = z.infer<typeof TargetMethodEnum>;

export const AnswerSetStatusEnum = z.enum([
  "DRAFT",
  "PAID",
  "PENDING_REVIEW", // Used when Questioner is underage
  "SENT",
  "ACCEPTED",
  "REJECTED",
]);
export type AnswerSetStatus = z.infer<typeof AnswerSetStatusEnum>;

export const AnswerSetSchema = z.object({
  set_id: z.string().uuid(),
  author_id: z.string().uuid(), // FK to User
  target_method: TargetMethodEnum,
  label: z.string().max(255),
  status: AnswerSetStatusEnum,
  expiration_date: z.coerce.date().optional(),
  created_at: z.coerce.date(),
});
export type AnswerSet = z.infer<typeof AnswerSetSchema>;

// ==========================================
// 3. Answer
// ==========================================
export const AnswerSchema = z.object({
  answer_id: z.string().uuid(),
  set_id: z.string().uuid(), // FK to AnswerSet
  response_text: z.string().max(70, "Response text must be 70 characters or less"), // PRD strict limit
  associated_question: z.string().max(255).optional(),
  sequence_order: z.number().int().min(0).max(7), // Max 8 answers (0-7 indexes)
});
export type Answer = z.infer<typeof AnswerSchema>;

// ==========================================
// 4. Invitation / Transaction
// ==========================================
export const PaymentStatusEnum = z.enum(["PENDING", "COMPLETED", "FAILED"]);
export type PaymentStatus = z.infer<typeof PaymentStatusEnum>;

export const DeliveryStatusEnum = z.enum(["QUEUED", "SENT", "DELIVERED", "FAILED"]);
export type DeliveryStatus = z.infer<typeof DeliveryStatusEnum>;

export const InvitationSchema = z.object({
  invite_id: z.string().uuid(),
  set_id: z.string().uuid(), // FK to AnswerSet
  target_contact: z.string(), // E.g. phone number string or email address
  deep_link_url: z.string().url(),
  payment_status: PaymentStatusEnum,
  delivery_status: DeliveryStatusEnum,
  sent_at: z.coerce.date().optional(),
});
export type Invitation = z.infer<typeof InvitationSchema>;
