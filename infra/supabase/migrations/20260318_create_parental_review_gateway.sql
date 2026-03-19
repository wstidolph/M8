-- Feature: Parental Review Gateway (009)
-- Purpose: Age-verification and Guardian approval flows.

-- 1. Profiles Table (Extended User Metadata)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    full_name TEXT,
    date_of_birth DATE,
    guardian_email TEXT,
    is_age_verified BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view and edit their own profile" 
ON public.profiles 
FOR ALL 
USING (auth.uid() = id);

-- 2. TRIGGER DEFINITION
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (
    id, 
    email, 
    date_of_birth, 
    guardian_email
  )
  VALUES (
    new.id, 
    new.email, 
    (new.raw_user_meta_data->>'date_of_birth')::DATE,
    new.raw_user_meta_data->>'guardian_email'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 3. Update Gifts Table Status Enum
-- Since PostgreSQL ENUMs are a bit rigid in migrations, we use a CHECK constraint update.
ALTER TABLE public.gifts DROP CONSTRAINT IF EXISTS gifts_status_check;
ALTER TABLE public.gifts ADD CONSTRAINT gifts_status_check 
CHECK (status IN ('ACTIVE', 'DELETED', 'EXPIRED', 'PENDING_REVIEW', 'REJECTED'));

-- 4. Review Metadata for Gifts
ALTER TABLE public.gifts ADD COLUMN IF NOT EXISTS reviewed_at TIMESTAMPTZ;
ALTER TABLE public.gifts ADD COLUMN IF NOT EXISTS reviewed_by TEXT; -- Guardian Email or ID

-- 5. Helper Function: Is Underage
CREATE OR REPLACE FUNCTION public.is_underage(u_id UUID) 
RETURNS BOOLEAN AS $$
DECLARE
    dob DATE;
BEGIN
    SELECT date_of_birth INTO dob FROM public.profiles WHERE id = u_id;
    IF dob IS NULL THEN RETURN FALSE; -- Not verified yet
    END IF;
    RETURN (dob > (CURRENT_DATE - INTERVAL '13 years'));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
