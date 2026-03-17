-- =========================================================
-- V002 — Add method column to blood_pressure
-- =========================================================

-- Context:
-- DN-004 defines that blood pressure measurement method
-- (oscillometric vs doppler) is a structural field.

ALTER TABLE blood_pressure
ADD COLUMN method TEXT;

-- Optional: future constraint can be added if desired
-- CHECK (method IN ('oscillometric', 'doppler'));
