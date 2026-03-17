SNAPSHOT_PROJETO_DAISY_v2_0_0
=============================

DATE
2026-03-12

SYSTEM STATE
Post-recovery snapshot following microbiology schema reconstruction and
database stabilization.

DATABASE ENGINE
SQLite (transitional)

DATABASE FILE
~/projeto_daisy/database/daisy.db

CLINICAL DATA STATUS

urine table
-----------
11 records confirmed
Integrity validated
Unique constraint verified.

MICROBIOLOGY STRUCTURE

urine_culture
--------------
8 records

culture_isolate
---------------
1 isolate

7 | Streptococcus canis | high count

antibiogram
-----------
28 antibiotic susceptibility records linked to isolate 7.

FINAL RELATIONAL STRUCTURE

urine_culture
      ↓
culture_isolate
      ↓
antibiogram

FOREIGN KEY CORRECTIONS

culture_isolate(culture_id)
→ references urine_culture(id)

MIGRATION SYSTEM

tools/migrate.sh created.

schema_migrations table active.

Baseline registered:

V001__baseline.sql

schema_migrations contents

V001 | 2026-03-12

PROJECT ARCHITECTURE DECISION

Daisy will become MULTI-PATIENT.

SQLite is retained temporarily.

The primary database engine will migrate to PostgreSQL
in the next development session.

PENDING TECHNICAL IMPROVEMENT

Add automatic backup before migrations inside migrate.sh.

Estimated change: ~3 lines of code.

END OF SNAPSHOT
