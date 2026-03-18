"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InvitationSchema = exports.DeliveryStatusEnum = exports.PaymentStatusEnum = exports.AnswerSchema = exports.AnswerSetSchema = exports.AnswerSetStatusEnum = exports.TargetMethodEnum = exports.UserSchema = exports.AuthMethodEnum = exports.UserRoleEnum = void 0;
const zod_1 = require("zod");
// ==========================================
// 1. User
// ==========================================
exports.UserRoleEnum = zod_1.z.enum(["AUTHOR", "QUESTIONER", "ADMIN"]);
exports.AuthMethodEnum = zod_1.z.enum(["EMAIL", "PHONE", "OAUTH"]);
exports.UserSchema = zod_1.z.object({
    user_id: zod_1.z.string().uuid(),
    auth_method: exports.AuthMethodEnum,
    email_address: zod_1.z.string().email().optional(),
    phone_number: zod_1.z.string().optional(),
    role: exports.UserRoleEnum,
    is_underage: zod_1.z.boolean().default(false),
    date_of_birth: zod_1.z.coerce.date().optional(),
    created_at: zod_1.z.coerce.date(),
    last_login: zod_1.z.coerce.date().optional(),
});
// ==========================================
// 2. AnswerSet
// ==========================================
exports.TargetMethodEnum = zod_1.z.enum(["EMAIL", "PHONE"]);
exports.AnswerSetStatusEnum = zod_1.z.enum([
    "DRAFT",
    "PAID",
    "PENDING_REVIEW", // Used when Questioner is underage
    "SENT",
    "ACCEPTED",
    "REJECTED",
]);
exports.AnswerSetSchema = zod_1.z.object({
    set_id: zod_1.z.string().uuid(),
    author_id: zod_1.z.string().uuid(), // FK to User
    target_method: exports.TargetMethodEnum,
    label: zod_1.z.string().max(255),
    status: exports.AnswerSetStatusEnum,
    expiration_date: zod_1.z.coerce.date().optional(),
    created_at: zod_1.z.coerce.date(),
});
// ==========================================
// 3. Answer
// ==========================================
exports.AnswerSchema = zod_1.z.object({
    answer_id: zod_1.z.string().uuid(),
    set_id: zod_1.z.string().uuid(), // FK to AnswerSet
    response_text: zod_1.z.string().max(70, "Response text must be 70 characters or less"), // PRD strict limit
    associated_question: zod_1.z.string().max(255).optional(),
    sequence_order: zod_1.z.number().int().min(0).max(7), // Max 8 answers (0-7 indexes)
});
// ==========================================
// 4. Invitation / Transaction
// ==========================================
exports.PaymentStatusEnum = zod_1.z.enum(["PENDING", "COMPLETED", "FAILED"]);
exports.DeliveryStatusEnum = zod_1.z.enum(["QUEUED", "SENT", "DELIVERED", "FAILED"]);
exports.InvitationSchema = zod_1.z.object({
    invite_id: zod_1.z.string().uuid(),
    set_id: zod_1.z.string().uuid(), // FK to AnswerSet
    target_contact: zod_1.z.string(), // E.g. phone number string or email address
    deep_link_url: zod_1.z.string().url(),
    payment_status: exports.PaymentStatusEnum,
    delivery_status: exports.DeliveryStatusEnum,
    sent_at: zod_1.z.coerce.date().optional(),
});
