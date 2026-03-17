PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

CREATE TABLE vulva (
  id              INTEGER PRIMARY KEY,
  patient_id      INTEGER NOT NULL,

  observation_date TEXT NOT NULL,
  observation_time TEXT,

  edema_present    INTEGER,
  discharge_present INTEGER,
  discharge_color  TEXT,
  discharge_type   TEXT,

  odor_present     INTEGER,
  inflammation_present INTEGER,

  source           TEXT,
  notes            TEXT,

  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);

CREATE INDEX idx_vulva_patient
ON vulva(patient_id);

COMMIT;
PRAGMA foreign_keys = ON;
