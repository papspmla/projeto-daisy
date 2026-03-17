SNAPSHOT_PROJETO_DAISY_v2_0_5
Date: 2026-03-15
Project: Projeto Daisy
Host: ubuntu-8gb-nbg1-4
Root: ~/projeto_daisy

------------------------------------------------------------
PROJECT STATE
------------------------------------------------------------

This snapshot records architectural decisions and operational
structure of the Daisy system after the session of 2026-03-15.

The session focused on:

• reinforcement of the Engineering Charter
• clarification of ingestion architecture
• formal definition of data authority hierarchy
• introduction of development landmarks
• restructuring of operational status storage

The system continues its evolution toward a consolidated
Go-based clinical analysis backend.

------------------------------------------------------------
ENGINEERING CHARTER ALIGNMENT
------------------------------------------------------------

All architectural decisions in this session respect the
Engineering Charter principles:

• conservative evolution
• Go as primary implementation language
• Bash restricted to operational wrappers
• SQLite as the current operational database
• preservation of original clinical evidence
• AI as analytical assistant, never authoritative writer
• clear separation of responsibilities between system layers

------------------------------------------------------------
SOURCE OF TRUTH HIERARCHY
------------------------------------------------------------

The Daisy system formally defines the authority hierarchy of data.

1. ORIGINAL CLINICAL EVIDENCE

Examples:

• laboratory PDFs
• ultrasound reports
• clinical images
• auscultation audio

These files constitute the primary immutable clinical evidence.

------------------------------------------------------------

2. STRUCTURED DATABASE

SQLite database stores:

• structured clinical measurements
• metadata
• references to original files

This database represents the official structured dataset.

------------------------------------------------------------

3. ANALYTICAL DERIVATIONS

Derived data may include:

• physiological interpreters
• trend analysis
• clinical models
• computed alerts

Derived data never replaces original measurements.

------------------------------------------------------------

4. SEMANTIC LAYER (FUTURE)

Future RAG systems will provide:

• contextual document retrieval
• semantic analysis

The semantic layer is not a source of authoritative clinical data.

------------------------------------------------------------
IMPORT DIRECTORY POLICY
------------------------------------------------------------

Directory:

~/projeto_daisy/import

is formally designated as:

TEMPORARY INGESTION STAGING AREA.

Typical contents include:

• PDF extraction artifacts
• intermediate CSV files
• raw document layouts
• parsing experiments

This directory is NOT a permanent clinical data repository.

Permanent clinical data locations are limited to:

~/projeto_daisy/data
~/projeto_daisy/media
~/projeto_daisy/database

Files inside import/ may be discarded at any time without
affecting the clinical integrity of the system.

------------------------------------------------------------
GO-FIRST IMPLEMENTATION POLICY
------------------------------------------------------------

All new development should be implemented in Go whenever
technically feasible.

Go is the primary implementation language of the system.

Bash scripts remain restricted to:

• build helpers
• operational wrappers
• minimal administrative tasks

Existing ingestion scripts will be progressively migrated
to Go components.

Migration is expected to occur incrementally during future
development sessions.

------------------------------------------------------------
DOCUMENT PIPELINE PREPARATION
------------------------------------------------------------

The document consolidation phase now explicitly includes:

• extraction of text from clinical PDFs
• normalization of document content
• preparation of semantic chunking

This prepares the system for a future RAG layer without
compromising the relational database architecture.

------------------------------------------------------------
STATUS STORAGE ARCHITECTURE
------------------------------------------------------------

Operational status records are now stored as independent
session files.

Directory:

~/projeto_daisy/00_admin/Status_Daisy/

Each development session generates one status file.

Example:

STATUS_DAISY_v1_31.md

The file:

~/projeto_daisy/00_admin/status_daisy.md

now functions only as an index pointing to the most recent
status record.

This prevents the operational status file from growing
indefinitely and keeps status records modular.

------------------------------------------------------------
CURRENT LANDMARK STATUS
------------------------------------------------------------

LANDMARK 1 — BACKEND CORE STABILIZATION

Status: IN PROGRESS (advanced phase)

The system already includes:

• operational SQLite database
• structured clinical directory architecture
• preserved clinical document repository
• physiological interpreters implemented in Go
• compiled Go clinical binaries
• versioned project snapshots
• operational logging

Remaining requirements:

1. complete ingestion of remaining clinical documents
2. consolidate ingestion pipelines in Go
3. gradually replace ingestion scripts

------------------------------------------------------------
ARCHITECTURAL CHARACTERIZATION
------------------------------------------------------------

The Daisy system now represents a hybrid clinical
computational architecture composed of:

• clinical evidence repository
• relational clinical database
• physiological interpretation engine
• longitudinal trend analysis

Existing Go modules already implement clinical interpretation
capabilities for renal, metabolic and hepatic physiology.

This architecture enables longitudinal physiological modeling
based on structured clinical records.

------------------------------------------------------------
NEXT SESSION PRIORITY
------------------------------------------------------------

Primary task for the next development session:

Design and begin implementation of a unified Go ingestion
engine responsible for completing ingestion of the clinical
documents currently stored in:

~/projeto_daisy/data/pdf_repository

This step advances the project toward the completion
of Landmark 1.

------------------------------------------------------------
END OF SNAPSHOT v2_0_5
------------------------------------------------------------
