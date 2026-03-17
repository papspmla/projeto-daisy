PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

CREATE TABLE vulva_images (
  id                INTEGER PRIMARY KEY,
  vulva_id          INTEGER NOT NULL,
  patient_id        INTEGER NOT NULL,

  file_path         TEXT NOT NULL,
  captured_at       TEXT,
  original_filename TEXT,
  file_hash         TEXT,

  source            TEXT,
  notes             TEXT,

  FOREIGN KEY(vulva_id) REFERENCES vulva(id),
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);

CREATE INDEX idx_vulva_images_vulva
ON vulva_images(vulva_id);

CREATE INDEX idx_vulva_images_patient
ON vulva_images(patient_id);

COMMIT;
PRAGMA foreign_keys = ON;
