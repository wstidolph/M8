-- Table: dynamic_answers
-- Purpose: Provides dynamic response sets for the M8 Mystic Orb.
-- Features: Weighted selection, Mood categorical influence.

CREATE TABLE IF NOT EXISTS public.dynamic_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    text TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('positive', 'neutral', 'negative')),
    weight FLOAT NOT NULL DEFAULT 1.0,
    is_event BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS (Row Level Security)
ALTER TABLE public.dynamic_answers ENABLE ROW LEVEL SECURITY;

-- Allow public read (assuming public app access)
CREATE POLICY "Public Read Access" 
ON public.dynamic_answers 
FOR SELECT 
USING (is_active = TRUE);

-- Insert initial "Mystic" answers (US2 sample set)
INSERT INTO public.dynamic_answers (text, category, weight) VALUES
('The cosmic winds are favorable.', 'positive', 1.0),
('A alignment of stars confirms it.', 'positive', 1.0),
('Shadows obscure the path, ask later.', 'neutral', 1.0),
('The void remains silent.', 'negative', 1.0),
('Ethereal energy points to NO.', 'negative', 1.0),
('Gravity pulls towards YES.', 'positive', 1.0);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_dynamic_answers_modtime
BEFORE UPDATE ON public.dynamic_answers
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
