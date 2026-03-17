SNAPSHOT_PROJETO_DAISY_v2_0_1
=============================

DATE
2026-03-13

CONTEXT
Post-audit corrective snapshot.
This snapshot supersedes optimistic wording from prior documents
and records only facts directly confirmed in the live SQLite database
and recent backups.

PRIMARY RULE
trabalho -> verificação factual -> snapshot

No future snapshot is valid unless the claimed structural state
has first been confirmed by direct database inspection.

DATABASE ENGINE
SQLite (transitional)

DATABASE FILE
~/projeto_daisy/database/daisy.db

AUDIT STATUS
A factual audit of the live SQLite database was completed.

The audit used:
- .schema
- PRAGMA table_info
- PRAGMA foreign_key_list
- PRAGMA index_list
- direct row counts
- comparison against recent SQLite backups

MAIN FACTUAL CONCLUSION
No clinical data loss was identified.

The main issue was not destruction of data, but mismatch between
prior textual consolidation and the actual declarative schema state.

BACKUP STATUS
Backups remain intact and usable.

Relevant inspected backups included:
- daisy_schema_stable_2026-03-12_205437.db
- daisy_2026-03-12_214834.db
- daisy_sqlite_2026-03-13.db

Conclusion:
- no later regression was detected
- the incorrect antibiogram FK already existed in the "stable" backup
- backups remain valid rollback and comparison points

MICROBIOLOGY STATUS
urine_culture
-------------
8 records

culture_isolate
---------------
1 record

antibiogram
-----------
28 records

Factual linkage confirmed:
- all 28 antibiogram rows reference isolate_id = 7
- isolate_id = 7 exists in culture_isolate

MICROBIOLOGY SCHEMA CORRECTION APPLIED
Previous incorrect FK:
antibiogram.isolate_id -> culture_isolate_bad.id

Corrected FK now active:
antibiogram.isolate_id -> culture_isolate.id

Validated by:
PRAGMA foreign_key_list('antibiogram')

CHEMISTRY STATUS
chemistry remains structurally intact.

Confirmed:
- all clinical columns preserved
- patient_id preserved
- UNIQUE(collection_date) removed
- UNIQUE(patient_id, collection_date) preserved

Pending:
- FK to patients not yet added

THYROID STATUS
thyroid remains structurally intact.

Confirmed:
- clinical columns preserved
- patient_id preserved
- legacy global uniqueness by collection_date removed

Pending:
- FK to patients not yet added

TABLES THAT NOW HAVE FK TO patients(patient_id)
- urine
- weight
- urine_culture
- blood_pressure
- temperature

Validated by PRAGMA foreign_key_list on each table.

ROW COUNTS CONFIRMED AFTER CORRECTIONS
- urine = 11
- weight = 206
- urine_culture = 8
- blood_pressure = 0
- temperature = 0

PATIENT STATUS
patients table:
- 1 record
- Daisy = patient_id 1

REMAINING PENDING STRUCTURAL WORK
1. Add FK to patients in:
   - chemistry
   - thyroid

2. Adapt these tables to multipatient model:
   - hematology
   - endocrine
   - estrous_cycle

IMPORTANT SESSION NOTE
A faulty command was emitted during this session for chemistry.
Subsequent factual inspection confirmed that chemistry remained intact.
No chemistry reingestion was required.

This snapshot records the verified end state only.

NEXT TASK
Resume in new session with strict closed scope:

1) chemistry -> add FK to patients
2) thyroid -> add FK to patients
3) hematology -> adapt to multipatient
4) endocrine -> adapt to multipatient
5) estrous_cycle -> adapt to multipatient
6) validate schema, foreign keys and row counts
7) only then emit next snapshot

FINAL RULE
Snapshot and status_daisy are now governed by:

trabalho -> verificação factual -> snapshot

END OF SNAPSHOT
