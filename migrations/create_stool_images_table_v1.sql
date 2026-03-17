PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

CREATE TABLE stool_images (
  id                INTEGER PRIMARY KEY,
  stool_id          INTEGER NOT NULL,
  patient_id        INTEGER NOT NULL,

  file_path         TEXT NOT NULL,
  captured_at       TEXT,     -- timestamp extraído do metadata da foto
  original_filename TEXT,
  file_hash         TEXT,

  source            TEXT,
  notes             TEXT,

  FOREIGN KEY(stool_id) REFERENCES stool(id),
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);

CREATE INDEX idx_stool_images_stool
ON stool_images(stool_id);

CREATE INDEX idx_stool_images_patient
ON stool_images(patient_id);

COMMIT;
PRAGMA foreign_keys = ON;
