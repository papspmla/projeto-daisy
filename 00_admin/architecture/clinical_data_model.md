# =========================================================
# Projeto Daisy
# Clinical Data Model
# =========================================================

Este documento descreve o modelo clínico atual do
Projeto Daisy após a introdução da arquitetura
multi-paciente.

Atualizado em: 2026-03-09

                         ┌──────────────────┐
                         │     patients     │
                         │──────────────────│
                         │ patient_id (PK)  │
                         │ name             │
                         │ species          │
                         │ breed            │
                         │ sex              │
                         │ date_of_birth    │
                         └─────────┬────────┘
                                   │
        ───────────────────────────┼───────────────────────────
                                   │

     ┌───────────────┐   ┌───────────────┐   ┌───────────────┐
     │   chemistry   │   │    thyroid    │   │     urine     │
     └───────────────┘   └───────────────┘   └───────────────┘

     ┌───────────────┐   ┌───────────────┐
     │  hematology   │   │   endocrine   │
     └───────────────┘   └───────────────┘


 MONITORIZAÇÃO FISIOLÓGICA
 ─────────────────────────────────

     ┌───────────────┐
     │ blood_pressure│
     └───────────────┘

     ┌───────────────┐
     │ temperature   │
     └───────────────┘

     ┌───────────────┐
     │ weight        │
     └───────────────┘


 EVENTOS BIOLÓGICOS
 ─────────────────────────────────

     ┌───────────────┐
     │ stool         │
     └───────────────┘

     ┌───────────────┐
     │ estrous_cycle │
     └───────────────┘


 INTERVENÇÕES CLÍNICAS
 ─────────────────────────────────

     ┌───────────────┐
     │ medication    │
     └───────────────┘

     ┌───────────────┐
     │ diet          │
     └───────────────┘


 EXAME CLÍNICO
 ─────────────────────────────────

     ┌───────────────────────┐
     │ cardiac_auscultation  │
     └───────────────────────┘

------------------------------------------------------------
DESIGN NOTE — DOCUMENT STORAGE ARCHITECTURE
Date: 16/03/2026
------------------------------------------------------------

The Daisy infrastructure contains two independent data layers.

1) Operational clinical database

Location:

    SQLite
    ~/projeto_daisy/database/daisy.db

Purpose:

    storage of structured daily clinical data
    ingestion by Daisy Ingest Engine (Go)

Examples of stored data:

    temperature
    blood_pressure
    weight
    diet
    stool
    vulva
    cardiac_auscultation

This database represents the primary operational data store.

------------------------------------------------------------

2) Document storage database

Location:

    PostgreSQL
    database: daisy_pg
    schema: daisy

Tables currently present:

    documents
    chunks
    lab_metadata
    reference_ranges

Purpose:

    storage of clinical documents
    text chunking
    preparation for semantic retrieval

Expected document types include:

    veterinary reports
    laboratory PDFs
    ultrasound reports
    long clinical notes

Document ingestion architecture:

    document → documents table
    document text → chunked → chunks table

Each document may generate multiple chunks for later
semantic indexing.

------------------------------------------------------------

Important architectural rule:

    PostgreSQL is NOT used for operational clinical data.

All daily structured clinical data remains stored in SQLite.

PostgreSQL is reserved exclusively for document corpus storage
and future RAG functionality.

------------------------------------------------------------

Long-term architecture vision:

    Structured clinical data → SQLite

    Clinical document corpus → PostgreSQL

    Semantic retrieval / embeddings → future RAG layer

------------------------------------------------------------
END OF DESIGN NOTE
------------------------------------------------------------

------------------------------------------------------------
DESIGN RULE — DATABASE AUTHORITY
Date: 16/03/2026
------------------------------------------------------------

The Daisy system operates with two separate databases:

    SQLite → operational clinical data
    PostgreSQL → document corpus

To avoid data divergence, the following rule is established:

    SQLite is the authoritative source for all
    structured clinical measurements.

PostgreSQL must never store primary clinical measurements.

PostgreSQL may only store:

    documents
    text chunks
    metadata
    semantic indexing data

If clinical information appears inside a document stored in
PostgreSQL, the structured values must always originate from
the SQLite database.

SQLite remains the single source of truth for:

    temperature
    blood_pressure
    weight
    diet
    stool
    vulva
    auscultation
    any other structured measurements.

------------------------------------------------------------
END OF DESIGN RULE
------------------------------------------------------------
