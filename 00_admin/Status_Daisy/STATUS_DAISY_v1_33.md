STATUS_DAISY_v1.33
Date: 2026-03-15
System: Projeto Daisy

------------------------------------------------------------
SESSION SUMMARY
------------------------------------------------------------

This session stabilized the architectural direction of the
Projeto Daisy ingestion system after operational testing
of the TXT ingestion workflow.

During testing it became clear that the system required a
clear and immutable architectural rule for ingestion.

------------------------------------------------------------
LEAD RULE — SINGLE INGEST ENGINE
------------------------------------------------------------

A permanent architectural rule was established:

The Daisy system will use a single ingestion engine
implemented in Go.

All ingestion logic must reside inside this engine.

The goal of this engine is to populate the Daisy database
with the real clinical data of Daisy as quickly as possible.

During ingestion:

• existing tables should be used whenever possible
• new tables may be created when required
• schema adjustments are allowed when real data demands it

Multiple ingestion scripts must not be created.

------------------------------------------------------------
INGESTION PIPELINE DECISION
------------------------------------------------------------

The system will use an inbox-based ingestion pipeline.

All incoming files must first enter:

data/99_inbox

The future ingestion engine (daisy-ingest) will read only
this directory.

After processing:

• data will be written to the SQLite database
• files will be moved to their final storage location
  (03_pressao, 04_temperatura, etc.)

Pipeline structure:

External sources (Google Drive / manual uploads)
        ↓
data/99_inbox
        ↓
daisy-ingest (Go)
        ↓
SQLite database
        ↓
final storage directories

------------------------------------------------------------
TXT INGESTION VALIDATION
------------------------------------------------------------

Operational testing of TXT ingestion from Google Drive
to the VPS was successfully completed.

The test file bp_daisy_test.txt was:

1. downloaded from Google Drive
2. normalized to Unix format
3. moved to the final storage directory

This confirmed that the external TXT ingestion workflow
is viable.

------------------------------------------------------------
PROJECT STATE
------------------------------------------------------------

The Daisy architecture is now stabilized again.

The project focus returns to the main objective:

Populate the Daisy database with real Daisy clinical data
using the future Go ingestion engine.

------------------------------------------------------------
END OF STATUS v1.33
------------------------------------------------------------
