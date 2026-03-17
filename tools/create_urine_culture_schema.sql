CREATE TABLE urine_culture (
  id INTEGER PRIMARY KEY,

  patient_id INTEGER,
  collection_date TEXT NOT NULL,
  report_date TEXT,

  specimen TEXT,          -- e.g. urine
  growth_result TEXT,     -- e.g. "No growth", "Moderate growth"
  organism TEXT,          -- organism identified

  source TEXT,
  notes TEXT
);

CREATE UNIQUE INDEX idx_urine_culture_patient_date
ON urine_culture(patient_id, collection_date);


CREATE TABLE antibiogram (
  id INTEGER PRIMARY KEY,

  culture_id INTEGER,
  antibiotic TEXT,
  interpretation TEXT,   -- S / I / R
  mic TEXT,

  FOREIGN KEY(culture_id) REFERENCES urine_culture(id)
);

CREATE INDEX idx_antibiogram_culture
ON antibiogram(culture_id);
