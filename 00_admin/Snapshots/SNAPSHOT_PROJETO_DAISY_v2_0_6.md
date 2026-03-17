SNAPSHOT_PROJETO_DAISY_v2_0_6
Date: 2026-03-15
Project: Projeto Daisy
Host: ubuntu-8gb-nbg1-4
Root: ~/projeto_daisy

------------------------------------------------------------
PROJECT STATE
------------------------------------------------------------

This snapshot records the system architecture following
the session of 2026-03-15 dedicated to external ingestion
infrastructure preparation.

The system now includes a defined external data entry
interface through Google Drive and a planned automated
synchronization mechanism.

------------------------------------------------------------
GOOGLE DRIVE INGESTION ARCHITECTURE
------------------------------------------------------------

External data ingestion now uses a structured Google Drive
directory named:

VPS-DAISY

Internal organization:

VPS-DAISY
   Imagens
      Stools
      Vulva
      Ultrasound
      Skin

   Audio
      Auscultation

   Registros
      Temperature
      BloodPressure
      Weight
      Diet
      Medication
      Estrous

Images, audio recordings and TXT clinical records will be
uploaded by the user to these folders.

Future system component daisy-sync will monitor these
directories and automatically retrieve new files to the VPS.

------------------------------------------------------------
EXTERNAL INGESTION WORKFLOW
------------------------------------------------------------

The ingestion workflow is defined as:

Clinical observation
   → Notes entry (iPhone)
   → TXT creation (desktop)
   → upload to Google Drive
   → detection by daisy-sync
   → ingestion by daisy-ingest
   → storage in SQLite database

This preserves the separation between:

• raw clinical evidence
• structured relational storage
• derived analytical layers

------------------------------------------------------------
TXT CLINICAL RECORD FORMAT
------------------------------------------------------------

TXT files serve as the structured ingestion format for
several clinical parameters.

Mandatory rule:

All TXT files must explicitly declare the patient.

Example:

Paciente: Daisy

Temperature records preserve the existing tabular
structure used by the operator.

Blood pressure sessions record full raw measurement sets
including measurement method, limb used and environmental
conditions.

The ingestion engine will perform protocol-consistent
computation of the final mean blood pressure.

------------------------------------------------------------
ENGINEERING BLUEPRINT
------------------------------------------------------------

The Engineering Blueprint defines the future architecture
of the unified ingestion engine.

Core components:

1. daisy-sync

Responsible for monitoring the Google Drive ingestion
structure and retrieving newly uploaded files.

2. daisy-ingest

Unified Go ingestion engine responsible for parsing:

• PDF clinical reports
• TXT clinical logs
• clinical images
• auscultation audio

The ingestion engine will determine file type based on
directory origin and file metadata.

------------------------------------------------------------
LANDMARK STATUS
------------------------------------------------------------

LANDMARK 1 — BACKEND CORE STABILIZATION

Status: IN PROGRESS (advanced phase)

Completed components:

• SQLite clinical database
• structured clinical directory architecture
• clinical document repository
• physiological interpreters in Go
• versioned project snapshots
• Google Drive ingestion architecture

Remaining work:

1. implement daisy-sync
2. implement unified Go ingestion engine
3. complete ingestion of remaining clinical PDFs

------------------------------------------------------------
NEXT SESSION PRIORITY
------------------------------------------------------------

Design the architecture of the daisy-ingest unified Go
ingestion engine responsible for processing files retrieved
from the Google Drive ingestion structure.

This engine will replace multiple ingestion scripts and
serve as the central ingestion mechanism of the Daisy
system.

------------------------------------------------------------
END OF SNAPSHOT v2_0_6
------------------------------------------------------------
