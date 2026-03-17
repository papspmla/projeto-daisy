-- PREVIEW ONLY (do not execute unless reviewed)
BEGIN;
INSERT INTO chemistry (collection_date, report_date, glucose_mmol_L, sdma_ug_dL, creatinine_umol_L, urea_mmol_L, phosphorus_mmol_L, calcium_mmol_L, magnesium_mmol_L, sodium_mmol_L, potassium_mmol_L, chloride_mmol_L, total_protein_g_L, albumin_g_L, globulin_g_L, alt_U_L, ast_U_L, alp_U_L, ggt_U_L, gldh_U_L, bilirubin_total_umol_L, cholesterol_mmol_L, triglycerides_mmol_L, amylase_U_L, lipase_U_L, ck_U_L, fructosamine_umol_L, crp_mg_L, source, notes)
VALUES ('2023-09-13','2023-09-13',4,8,97,4.3,1.3,2.7,0.8,149,4.5,110,69,34,35,53,38,65,4,7,6.8,7.3,0.9,474,77,252,246,2.9,'01 - IDEXX_SangueCompleto_13_09_2023.pdf','Report created on 13.09.2023 07:35; audit CSV: 01_2023-09-13_chem_audit.csv');
COMMIT;
-- After review you can run:
-- sqlite3 ~/projeto_daisy/database/daisy.db < 01_2023-09-13_insert_preview.sql
