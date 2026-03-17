-- Projeto Daisy — SQLite Schema v1.0
-- Units: Internal SI (European) standard. Conversions happen at query layer.
-- Rule: numeric clinical parameters allow NULL (not measured); dates are mandatory.

PRAGMA foreign_keys = ON;

-- =========================
-- 1) BLOOD PRESSURE
-- =========================
CREATE TABLE IF NOT EXISTS blood_pressure (
  id                 INTEGER PRIMARY KEY,
  collection_date    TEXT NOT NULL,   -- YYYY-MM-DD
  collection_time    TEXT,            -- HH:MM (optional)

  systolic_mmHg      REAL,
  diastolic_mmHg     REAL,
  map_mmHg           REAL,
  heart_rate_bpm     REAL,

  body_position      TEXT,
  measurement_site   TEXT,
  condition          TEXT,

  source             TEXT,
  notes              TEXT
);

CREATE INDEX IF NOT EXISTS idx_bp_collection_date
  ON blood_pressure(collection_date);

-- =========================
-- 2) CHEMISTRY (Serum biochemistry)
-- =========================
CREATE TABLE IF NOT EXISTS chemistry (
  id                       INTEGER PRIMARY KEY,
  collection_date          TEXT NOT NULL,  -- YYYY-MM-DD (date of sample)
  report_date              TEXT,           -- YYYY-MM-DD (date of report)

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

CREATE INDEX IF NOT EXISTS idx_chem_collection_date
  ON chemistry(collection_date);

-- =========================
-- 3) HEMATOLOGY (CBC)
-- =========================
CREATE TABLE IF NOT EXISTS hematology (
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
  notes                      TEXT
);

CREATE INDEX IF NOT EXISTS idx_hema_collection_date
  ON hematology(collection_date);

-- =========================
-- 4) ENDOCRINE (Thyroid, etc.)
-- =========================
CREATE TABLE IF NOT EXISTS endocrine (
  id                               INTEGER PRIMARY KEY,
  collection_date                  TEXT NOT NULL,
  report_date                      TEXT,

  t4_total_nmol_L                  REAL,
  t3_nmol_L                        REAL,
  free_t4_pmol_L                   REAL,
  tsh_ng_mL                        REAL,
  thyroglobulin_antibodies_percent REAL,

  source                           TEXT,
  notes                            TEXT
);

CREATE INDEX IF NOT EXISTS idx_endo_collection_date
  ON endocrine(collection_date);

-- =========================
-- 5) URINE (UA + renal urine markers + culture summary)
-- =========================
CREATE TABLE IF NOT EXISTS urine (
  id                      INTEGER PRIMARY KEY,
  collection_date         TEXT NOT NULL,
  report_date             TEXT,

  usg                     REAL,
  ph                      REAL,

  protein_strip           TEXT,
  blood_strip             TEXT,
  glucose_strip           TEXT,
  ketones_strip           TEXT,
  nitrite_strip           TEXT,

  leukocytes_sediment_hpf TEXT,   -- e.g. "1-4", ">50"
  erythrocytes_sediment_hpf TEXT, -- e.g. "1-4", ">50"
  bacteria_present        TEXT,   -- e.g. "None", "Few", "Marked"
  epithelial_cells        TEXT,
  casts_present           TEXT,
  crystals_present        TEXT,

  cystatin_b_ng_mL        REAL,
  urine_creatinine_umol_L REAL,
  urine_protein_mg_L      REAL,
  upc_ratio               REAL,

  culture_result          TEXT,   -- e.g. "No growth", "Moderate growth"
  organism                TEXT,   -- free text (can store multiple organisms)

  source                  TEXT,
  notes                   TEXT
);

CREATE INDEX IF NOT EXISTS idx_urine_collection_date
  ON urine(collection_date);

-- =========================
-- 6) WEIGHT
-- =========================
CREATE TABLE IF NOT EXISTS weight (
  id                 INTEGER PRIMARY KEY,
  collection_date    TEXT NOT NULL,
  weight_kg          REAL,
  condition          TEXT,  -- e.g. AJ
  source             TEXT,
  notes              TEXT
);

CREATE INDEX IF NOT EXISTS idx_weight_collection_date
  ON weight(collection_date);

-- =========================
-- 7) TEMPERATURE
-- =========================
CREATE TABLE IF NOT EXISTS temperature (
  id                 INTEGER PRIMARY KEY,
  collection_date    TEXT NOT NULL,
  collection_time    TEXT,
  temperature_c      REAL,
  context            TEXT,
  source             TEXT,
  notes              TEXT
);

CREATE INDEX IF NOT EXISTS idx_temp_collection_date
  ON temperature(collection_date);

-- =========================
-- 8) ESTROUS CYCLE
-- =========================
CREATE TABLE IF NOT EXISTS estrous_cycle (
  id               INTEGER PRIMARY KEY,
  cycle_start_date TEXT NOT NULL,
  cycle_end_date   TEXT,
  phase            TEXT,    -- e.g. proestrus, estrus, diestrus, anestrus
  day_of_cycle     INTEGER, -- optional integer day count
  observations     TEXT,
  source           TEXT,
  notes            TEXT
);

CREATE INDEX IF NOT EXISTS idx_estrous_start_date
  ON estrous_cycle(cycle_start_date);
