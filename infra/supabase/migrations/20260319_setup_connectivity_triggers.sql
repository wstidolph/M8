-- Feature: User Connectivity Triggers (012)
-- Purpose: Invoke Edge Function on Gift creation or status update.

-- 1. Gift Notification Function (Trigger)
CREATE OR REPLACE FUNCTION public.handle_gift_connectivity()
RETURNS TRIGGER AS $$
DECLARE
    notif_type TEXT;
    payload JSONB;
BEGIN
    -- Decide notification type
    IF (TG_OP = 'INSERT') THEN
        IF (NEW.status = 'PENDING_REVIEW') THEN
            notif_type := 'GUARDIAN_GATE';
            payload := jsonb_build_object(
                'guardianEmail', (SELECT guardian_email FROM profiles WHERE id = NEW.author_id), -- Placeholder logic
                'questionerName', 'Your Child',
                'reviewLink', 'https://m8-web.vercel.app/guardian/approve?id=' || NEW.gift_id
            );
        ELSE
            notif_type := 'GIFT_INVITE';
            payload := jsonb_build_object(
                'target', NEW.target_contact,
                'label', 'A Mystical Friend', -- Placeholder
                'deepLink', 'm8ball://accept?id=' || NEW.gift_id
            );
        END IF;
    ELSIF (TG_OP = 'UPDATE' AND OLD.status != 'REJECTED' AND NEW.status = 'REJECTED') THEN
        notif_type := 'GIFT_REJECTED';
        payload := jsonb_build_object(
            'authorEmail', (SELECT email FROM auth.users WHERE id = NEW.author_id),
            'label', 'Your Secret Gift',
            'reason', NEW.rejection_reason
        );
    END IF;

    -- Call Edge Function via HTTP (Assuming net-extension is enabled in Supabase project)
    -- In standard Supabase, this is often done via Webhooks UI.
    -- Here we provide the SQL pattern for Reference.
    IF (notif_type IS NOT NULL) THEN
        PERFORM net.http_post(
            url := 'https://' || (SELECT current_setting('request.headers')::json->>'host') || '/functions/v1/send_connectivity',
            headers := jsonb_build_object(
                'Content-Type', 'application/json',
                'Authorization', 'Bearer ' || (SELECT current_setting('app.settings.service_role_key'))
            ),
            body := jsonb_build_object(
                'type', notif_type,
                'payload', payload
            )
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Create Triggers
CREATE TRIGGER on_gift_created
AFTER INSERT ON public.gifts
FOR EACH ROW
EXECUTE FUNCTION public.handle_gift_connectivity();

CREATE TRIGGER on_gift_rejected
AFTER UPDATE ON public.gifts
FOR EACH ROW
WHEN (OLD.status != 'REJECTED' AND NEW.status = 'REJECTED')
EXECUTE FUNCTION public.handle_gift_connectivity();
