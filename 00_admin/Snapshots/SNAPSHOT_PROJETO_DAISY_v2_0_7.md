SNAPSHOT_PROJETO_DAISY_v2_0_7
Date: 2026-03-15
Project: Projeto Daisy
Host: ubuntu-8gb-nbg1-4
Root: ~/projeto_daisy

------------------------------------------------------------
PROJECT STATE
------------------------------------------------------------

This snapshot records the architectural stabilization of
the Daisy ingestion system following operational testing
of TXT ingestion through Google Drive.

The system now has a defined and immutable ingestion rule.

------------------------------------------------------------
LEAD RULE — SINGLE INGEST ENGINE
------------------------------------------------------------

Projeto Daisy will use a single ingestion engine written
in Go.

All ingestion logic must reside inside this engine.

The purpose of this engine is to populate the Daisy
database with the real clinical data of Daisy as quickly
as possible.

During the ingestion process:

• existing tables should be used whenever possible
• new tables may be created when required
• schema corrections or expansions are allowed when
  real data demands it

Multiple independent ingestion scripts are forbidden.

------------------------------------------------------------
INGESTION PIPELINE
------------------------------------------------------------

The Daisy system will operate with an inbox-based
ingestion pipeline.

All incoming files must first enter:

data/99_inbox

The ingestion engine will read exclusively from this
directory.

After processing:

• data is written to the SQLite database
• files are moved to their final storage directory

Example pipeline:

External sources
(Google Drive / manual uploads)
        ↓
data/99_inbox
        ↓
daisy-ingest (Go)
        ↓
SQLite database
        ↓
final storage directories

------------------------------------------------------------
TXT INGESTION TEST
------------------------------------------------------------

The TXT ingestion workflow from Google Drive to the VPS
was successfully tested.

The file bp_daisy_test.txt was:

1. downloaded from Google Drive
2. normalized to Unix format
3. moved to the final directory

This validates the operational viability of TXT clinical
record ingestion.

------------------------------------------------------------
NEXT DEVELOPMENT PRIORITY
------------------------------------------------------------

Implement the unified Go ingestion engine
(daisy-ingest).

The first objective of the engine will be to populate
existing Daisy tables with real clinical data.

------------------------------------------------------------
END OF SNAPSHOT v2_0_7
------------------------------------------------------------
