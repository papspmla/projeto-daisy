BEGIN;

INSERT INTO daisy.reference_ranges (analyte, species, unit, min_value, max_value, lab_id)
VALUES
('albumin_g_L','canine','g/L',23,40,1),
('alp_U_L','canine','U/L',23,212,1),
('alt_U_L','canine','U/L',10,125,1),
('amylase_U_L','canine','U/L',500,1500,1),
('ast_U_L','canine','U/L',0,50,1),
('bilirubin_total_umol_L','canine','umol/L',0,15,1),
('calcium_mmol_L','canine','mmol/L',1.98,3.00,1),
('chloride_mmol_L','canine','mmol/L',109,122,1),
('cholesterol_mmol_L','canine','mmol/L',2.84,8.27,1),
('ck_U_L','canine','U/L',10,200,1),
('crp_mg_L','canine','mg/L',0,10,1),
('fructosamine_umol_L','canine','umol/L',177,314,1),
('ggt_U_L','canine','U/L',0,11,1),
('globulin_g_L','canine','g/L',25,45,1),
('glucose_mmol_L','canine','mmol/L',4.11,7.94,1),
('lipase_U_L','canine','U/L',200,1800,1),
('magnesium_mmol_L','canine','mmol/L',0.58,0.99,1),
('phosphorus_mmol_L','canine','mmol/L',0.81,2.19,1),
('potassium_mmol_L','canine','mmol/L',3.5,5.8,1),
('sdma_ug_dL','canine','ug/dL',0,14,1),
('sodium_mmol_L','canine','mmol/L',144,160,1),
('total_protein_g_L','canine','g/L',52,82,1),
('triglycerides_mmol_L','canine','mmol/L',0.11,1.13,1),
('urea_mmol_L','canine','mmol/L',2.5,9.6,1);

COMMIT;
