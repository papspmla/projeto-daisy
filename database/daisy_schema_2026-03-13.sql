CREATE TABLE chemistry_import(
  collection_date TEXT,
  report_date TEXT,
  glucose_mmol_L REAL,
  sdma_ug_dL REAL,
  creatinine_umol_L REAL,
  urea_mmol_L REAL,
  phosphorus_mmol_L REAL,
  calcium_mmol_L REAL,
  magnesium_mmol_L REAL,
  sodium_mmol_L REAL,
  potassium_mmol_L REAL,
  chloride_mmol_L REAL,
  total_protein_g_L REAL,
  albumin_g_L REAL,
  globulin_g_L REAL,
  alt_U_L REAL,
  ast_U_L REAL,
  alp_U_L REAL,
  ggt_U_L REAL,
  gldh_U_L REAL,
  bilirubin_total_umol_L REAL,
  cholesterol_mmol_L REAL,
  triglycerides_mmol_L REAL,
  amylase_U_L REAL,
  lipase_U_L REAL,
  ck_U_L REAL,
  fructosamine_umol_L REAL,
  crp_mg_L REAL,
  source TEXT,
  notes TEXT
);
CREATE TABLE chemistry_staging (
  collection_date          TEXT NOT NULL,
  report_date              TEXT,

  glucose_mmol_L           REAL,
  sdma_ug_dL               REAL,
  creatinine_umol_L        REAL,
  urea_mmol_L              REAL,
  phosphorus_mmol_L        REAL,
  calcium_mmol_L           REAL,
  magnesium_mmol_L         REAL,
  sodium_mmol_L            REAL,
  potassium_mmol_L         REAL,
  chloride_mmol_L          REAL,

  total_protein_g_L        REAL,
  albumin_g_L              REAL,
  globulin_g_L             REAL,

  alt_U_L                  REAL,
  ast_U_L                  REAL,
  alp_U_L                  REAL,
  ggt_U_L                  REAL,
  gldh_U_L                 REAL,
  bilirubin_total_umol_L   REAL,

  cholesterol_mmol_L       REAL,
  triglycerides_mmol_L     REAL,

  amylase_U_L              REAL,
  lipase_U_L               REAL,
  ck_U_L                   REAL,

  fructosamine_umol_L      REAL,
  crp_mg_L                 REAL,

  source                   TEXT,
  notes                    TEXT
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    species TEXT,
    breed TEXT,
    sex TEXT,
    date_of_birth DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE medication (
  id                 INTEGER PRIMARY KEY,
  patient_id         INTEGER NOT NULL,
  medication_name    TEXT NOT NULL,
  dose               REAL,
  dose_unit          TEXT,
  frequency          TEXT,
  start_date         TEXT,
  end_date           TEXT,
  continuous_use     INTEGER NOT NULL DEFAULT 0,
  indication         TEXT,
  prescribing_vet    TEXT,
  source             TEXT,
  notes              TEXT
);
CREATE TABLE diet (
  id                 INTEGER PRIMARY KEY,
  patient_id         INTEGER NOT NULL,
  start_date         TEXT NOT NULL,
  body_weight_kg     REAL,
  meals_per_day      INTEGER,
  meals_equal        INTEGER,
  description        TEXT,
  estimated_kcal_day REAL NOT NULL,
  source             TEXT,
  notes              TEXT
);
CREATE TABLE cardiac_auscultation (
  id                    INTEGER PRIMARY KEY,
  patient_id            INTEGER NOT NULL,
  collection_date       TEXT NOT NULL,
  collection_time       TEXT,
  auscultation_site     TEXT,
  position              TEXT,
  rhythm                TEXT,
  murmur_present        INTEGER,
  murmur_grade          TEXT,
  interpretation        TEXT,
  audio_reference       TEXT,
  spectrogram_reference TEXT,
  source                TEXT,
  notes                 TEXT
);
CREATE INDEX idx_medication_patient ON medication(patient_id);
CREATE INDEX idx_diet_patient ON diet(patient_id);
CREATE INDEX idx_auscultation_patient ON cardiac_auscultation(patient_id);
CREATE TABLE culture_isolate (
  id INTEGER PRIMARY KEY,
  culture_id INTEGER NOT NULL,
  organism TEXT,
  growth TEXT,
  FOREIGN KEY(culture_id) REFERENCES urine_culture(id)
);
CREATE INDEX idx_culture_isolate_culture
ON culture_isolate(culture_id);
CREATE TABLE schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS "antibiogram" (
  id INTEGER PRIMARY KEY,
  isolate_id INTEGER NOT NULL,
  antibiotic TEXT,
  interpretation TEXT,
  mic TEXT,
  FOREIGN KEY(isolate_id) REFERENCES culture_isolate(id)
);
CREATE TABLE IF NOT EXISTS "urine" (
  id INTEGER PRIMARY KEY,
  collection_date TEXT NOT NULL,
  report_date TEXT,
  usg REAL,
  ph REAL,
  protein_strip TEXT,
  blood_strip TEXT,
  glucose_strip TEXT,
  ketones_strip TEXT,
  nitrite_strip TEXT,
  leukocytes_sediment_hpf TEXT,
  erythrocytes_sediment_hpf TEXT,
  bacteria_present TEXT,
  epithelial_cells TEXT,
  casts_present TEXT,
  crystals_present TEXT,
  cystatin_b_ng_mL REAL,
  urine_creatinine_umol_L REAL,
  urine_protein_mg_L REAL,
  upc_ratio REAL,
  culture_result TEXT,
  organism TEXT,
  source TEXT,
  notes TEXT,
  patient_id INTEGER,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_urine_collection_date
ON urine(collection_date);
CREATE UNIQUE INDEX idx_urine_patient_date
ON urine(patient_id, collection_date);
CREATE TABLE IF NOT EXISTS "weight" (
  id INTEGER PRIMARY KEY,
  collection_date TEXT NOT NULL,
  weight_kg REAL,
  condition TEXT,
  source TEXT,
  notes TEXT,
  patient_id INTEGER,
  feeding_state TEXT,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_weight_collection_date
ON weight(collection_date);
CREATE UNIQUE INDEX idx_weight_patient_date_state
ON weight(patient_id, collection_date, feeding_state);
CREATE TABLE IF NOT EXISTS "urine_culture" (
  id INTEGER PRIMARY KEY,
  patient_id INTEGER,
  collection_date TEXT NOT NULL,
  report_date TEXT,
  specimen TEXT,
  source TEXT,
  notes TEXT,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE UNIQUE INDEX idx_urine_culture_patient_date
ON urine_culture(patient_id, collection_date);
CREATE TABLE IF NOT EXISTS "blood_pressure" (
  id INTEGER PRIMARY KEY,
  collection_date TEXT NOT NULL,
  collection_time TEXT,
  systolic_mmHg REAL,
  diastolic_mmHg REAL,
  map_mmHg REAL,
  heart_rate_bpm REAL,
  body_position TEXT,
  measurement_site TEXT,
  condition TEXT,
  source TEXT,
  notes TEXT,
  patient_id INTEGER,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_bp_collection_date
ON blood_pressure(collection_date);
CREATE UNIQUE INDEX idx_bp_patient_datetime
ON blood_pressure(patient_id, collection_date, collection_time);
CREATE TABLE IF NOT EXISTS "temperature" (
  id INTEGER PRIMARY KEY,
  collection_date TEXT NOT NULL,
  collection_time TEXT,
  temperature_c REAL,
  context TEXT,
  source TEXT,
  notes TEXT,
  patient_id INTEGER,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_temp_collection_date
ON temperature(collection_date);
CREATE UNIQUE INDEX idx_temperature_patient_datetime
ON temperature(patient_id, collection_date, collection_time);
CREATE TABLE IF NOT EXISTS "chemistry" (
  id                       INTEGER PRIMARY KEY,
  collection_date          TEXT NOT NULL,
  report_date              TEXT,

  glucose_mmol_L           REAL,
  sdma_ug_dL               REAL,
  creatinine_umol_L        REAL,
  urea_mmol_L              REAL,
  phosphorus_mmol_L        REAL,
  calcium_mmol_L           REAL,
  magnesium_mmol_L         REAL,
  sodium_mmol_L            REAL,
  potassium_mmol_L         REAL,
  chloride_mmol_L          REAL,

  total_protein_g_L        REAL,
  albumin_g_L              REAL,
  globulin_g_L             REAL,

  alt_U_L                  REAL,
  ast_U_L                  REAL,
  alp_U_L                  REAL,
  ggt_U_L                  REAL,
  gldh_U_L                 REAL,
  bilirubin_total_umol_L   REAL,

  cholesterol_mmol_L       REAL,
  triglycerides_mmol_L     REAL,

  amylase_U_L              REAL,
  lipase_U_L               REAL,
  ck_U_L                   REAL,

  fructosamine_umol_L      REAL,
  crp_mg_L                 REAL,

  source                   TEXT,
  notes                    TEXT,
  patient_id               INTEGER,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_chem_collection_date
ON chemistry(collection_date);
CREATE UNIQUE INDEX idx_chemistry_patient_date
ON chemistry(patient_id, collection_date);
CREATE TABLE IF NOT EXISTS "thyroid" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  collection_date TEXT NOT NULL,
  report_date TEXT,
  t4_total REAL,
  tsh REAL,
  t3_total REAL,
  ft4 REAL,
  ft3 REAL,
  source TEXT,
  notes TEXT,
  patient_id INTEGER,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE TABLE IF NOT EXISTS "hematology" (
  id                         INTEGER PRIMARY KEY,
  collection_date            TEXT NOT NULL,
  report_date                TEXT,

  erythrocytes_10e12_L       REAL,
  hematocrit_L_L             REAL,
  hemoglobin_g_L             REAL,

  mcv_fL                     REAL,
  mch_pg                     REAL,
  mchc_g_L                   REAL,

  leukocytes_10e9_L          REAL,
  platelets_10e9_L           REAL,

  neutrophils_percent        REAL,
  lymphocytes_percent        REAL,
  monocytes_percent          REAL,
  eosinophils_percent        REAL,
  basophils_percent          REAL,

  neutrophils_abs_10e9_L     REAL,
  lymphocytes_abs_10e9_L     REAL,
  monocytes_abs_10e9_L       REAL,
  eosinophils_abs_10e9_L     REAL,
  basophils_abs_10e9_L       REAL,

  reticulocytes_percent      REAL,
  reticulocytes_abs_K_uL     REAL,
  reticulocyte_hemoglobin_pg REAL,

  source                     TEXT,
  notes                      TEXT,
  patient_id                 INTEGER NOT NULL,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_hema_collection_date
  ON hematology(collection_date);
CREATE TABLE estrous_cycle (
  id               INTEGER PRIMARY KEY,
  cycle_start_date TEXT NOT NULL,
  cycle_end_date   TEXT,
  phase            TEXT,
  day_of_cycle     INTEGER,
  observations     TEXT,
  source           TEXT,
  notes            TEXT,
  patient_id       INTEGER NOT NULL,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_estrous_start_date
  ON estrous_cycle(cycle_start_date);
CREATE TABLE stool (
  id              INTEGER PRIMARY KEY,
  patient_id      INTEGER NOT NULL,
  collection_date TEXT NOT NULL,
  collection_time TEXT,
  bristol_score   INTEGER,
  consistency     TEXT,
  color           TEXT,
  mucus_present   INTEGER,
  blood_present   INTEGER,
  source          TEXT,
  notes           TEXT,
  FOREIGN KEY(patient_id) REFERENCES patients(patient_id)
);
CREATE INDEX idx_stool_patient
ON stool(patient_id);
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
