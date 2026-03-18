import { z } from "zod";
export declare const UserRoleEnum: z.ZodEnum<["AUTHOR", "QUESTIONER", "ADMIN"]>;
export type UserRole = z.infer<typeof UserRoleEnum>;
export declare const AuthMethodEnum: z.ZodEnum<["EMAIL", "PHONE", "OAUTH"]>;
export type AuthMethod = z.infer<typeof AuthMethodEnum>;
export declare const UserSchema: z.ZodObject<{
    user_id: z.ZodString;
    auth_method: z.ZodEnum<["EMAIL", "PHONE", "OAUTH"]>;
    email_address: z.ZodOptional<z.ZodString>;
    phone_number: z.ZodOptional<z.ZodString>;
    role: z.ZodEnum<["AUTHOR", "QUESTIONER", "ADMIN"]>;
    is_underage: z.ZodDefault<z.ZodBoolean>;
    date_of_birth: z.ZodOptional<z.ZodDate>;
    created_at: z.ZodDate;
    last_login: z.ZodOptional<z.ZodDate>;
}, "strip", z.ZodTypeAny, {
    user_id: string;
    auth_method: "EMAIL" | "PHONE" | "OAUTH";
    role: "AUTHOR" | "QUESTIONER" | "ADMIN";
    is_underage: boolean;
    created_at: Date;
    email_address?: string | undefined;
    phone_number?: string | undefined;
    date_of_birth?: Date | undefined;
    last_login?: Date | undefined;
}, {
    user_id: string;
    auth_method: "EMAIL" | "PHONE" | "OAUTH";
    role: "AUTHOR" | "QUESTIONER" | "ADMIN";
    created_at: Date;
    email_address?: string | undefined;
    phone_number?: string | undefined;
    is_underage?: boolean | undefined;
    date_of_birth?: Date | undefined;
    last_login?: Date | undefined;
}>;
export type User = z.infer<typeof UserSchema>;
export declare const TargetMethodEnum: z.ZodEnum<["EMAIL", "PHONE"]>;
export type TargetMethod = z.infer<typeof TargetMethodEnum>;
export declare const AnswerSetStatusEnum: z.ZodEnum<["DRAFT", "PAID", "PENDING_REVIEW", "SENT", "ACCEPTED", "REJECTED"]>;
export type AnswerSetStatus = z.infer<typeof AnswerSetStatusEnum>;
export declare const AnswerSetSchema: z.ZodObject<{
    set_id: z.ZodString;
    author_id: z.ZodString;
    target_method: z.ZodEnum<["EMAIL", "PHONE"]>;
    label: z.ZodString;
    status: z.ZodEnum<["DRAFT", "PAID", "PENDING_REVIEW", "SENT", "ACCEPTED", "REJECTED"]>;
    expiration_date: z.ZodOptional<z.ZodDate>;
    created_at: z.ZodDate;
}, "strip", z.ZodTypeAny, {
    status: "DRAFT" | "PAID" | "PENDING_REVIEW" | "SENT" | "ACCEPTED" | "REJECTED";
    created_at: Date;
    set_id: string;
    author_id: string;
    target_method: "EMAIL" | "PHONE";
    label: string;
    expiration_date?: Date | undefined;
}, {
    status: "DRAFT" | "PAID" | "PENDING_REVIEW" | "SENT" | "ACCEPTED" | "REJECTED";
    created_at: Date;
    set_id: string;
    author_id: string;
    target_method: "EMAIL" | "PHONE";
    label: string;
    expiration_date?: Date | undefined;
}>;
export type AnswerSet = z.infer<typeof AnswerSetSchema>;
export declare const AnswerSchema: z.ZodObject<{
    answer_id: z.ZodString;
    set_id: z.ZodString;
    response_text: z.ZodString;
    associated_question: z.ZodOptional<z.ZodString>;
    sequence_order: z.ZodNumber;
}, "strip", z.ZodTypeAny, {
    set_id: string;
    answer_id: string;
    response_text: string;
    sequence_order: number;
    associated_question?: string | undefined;
}, {
    set_id: string;
    answer_id: string;
    response_text: string;
    sequence_order: number;
    associated_question?: string | undefined;
}>;
export type Answer = z.infer<typeof AnswerSchema>;
export declare const PaymentStatusEnum: z.ZodEnum<["PENDING", "COMPLETED", "FAILED"]>;
export type PaymentStatus = z.infer<typeof PaymentStatusEnum>;
export declare const DeliveryStatusEnum: z.ZodEnum<["QUEUED", "SENT", "DELIVERED", "FAILED"]>;
export type DeliveryStatus = z.infer<typeof DeliveryStatusEnum>;
export declare const InvitationSchema: z.ZodObject<{
    invite_id: z.ZodString;
    set_id: z.ZodString;
    target_contact: z.ZodString;
    deep_link_url: z.ZodString;
    payment_status: z.ZodEnum<["PENDING", "COMPLETED", "FAILED"]>;
    delivery_status: z.ZodEnum<["QUEUED", "SENT", "DELIVERED", "FAILED"]>;
    sent_at: z.ZodOptional<z.ZodDate>;
}, "strip", z.ZodTypeAny, {
    set_id: string;
    invite_id: string;
    target_contact: string;
    deep_link_url: string;
    payment_status: "PENDING" | "COMPLETED" | "FAILED";
    delivery_status: "SENT" | "FAILED" | "QUEUED" | "DELIVERED";
    sent_at?: Date | undefined;
}, {
    set_id: string;
    invite_id: string;
    target_contact: string;
    deep_link_url: string;
    payment_status: "PENDING" | "COMPLETED" | "FAILED";
    delivery_status: "SENT" | "FAILED" | "QUEUED" | "DELIVERED";
    sent_at?: Date | undefined;
}>;
export type Invitation = z.infer<typeof InvitationSchema>;
