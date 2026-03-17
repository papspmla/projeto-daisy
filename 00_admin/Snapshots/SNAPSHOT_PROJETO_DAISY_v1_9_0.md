PROJETO DAISY
SNAPSHOT v1.9.0

Date: 2026-03-05

CURRENT SYSTEM STATE

The Daisy system now consists of two integrated layers:

1) SQLite (Clinical Source of Truth)
Stores structured laboratory results, longitudinal exam history and raw analyte values.

2) PostgreSQL (Interpretation Layer)
Stores documents, semantic chunks, laboratory metadata, reference ranges and temporal range logic.

REFERENCE RANGE SYSTEM

Tables implemented:
lab_metadata
reference_ranges

Features:
- temporal range versioning
- generated daterange column
- non-overlapping range enforcement
- laboratory metadata traceability

SAFETY MECHANISMS

Integrity constraint:
reference_ranges_no_overlap

This prevents conflicting clinical interpretation ranges.

FUNCTIONS

get_reference_range()

Automatically resolves the correct reference interval based on:
- analyte
- laboratory
- species
- unit
- exam date

REFERENCE RANGE COVERAGE

IDEXX Catalyst canine ranges inserted for 25 analytes.
All analytes present in the chemistry schema now have registered reference intervals.

FILESYSTEM STRUCTURE

~/projeto_daisy/

database/
SQLite clinical repository

tools/
industrial ingestion scripts

sql/
SQL scripts for database operations

import/
PDF laboratory reports

logs/
pipeline logs

CLINICAL PIPELINE

PDF → Raw Text → Parser → SQLite

SQLite → Postgres documents → chunks

Reference ranges retrieved dynamically.

OPEN TASKS

1) Build automated interpretation script

tools/interpret_chemistry_exam.sh

Purpose:
- read exam values from SQLite
- query ranges in Postgres
- classify analytes

2) Prepare interpretation output format

Suggested structure:

analyte
value
unit
range
status

3) Prepare integration with Daisy AI layer

NEXT SESSION START POINT

First task:
Design and implement tools/interpret_chemistry_exam.sh

This script will become the first automated clinical interpretation tool in the Daisy system.

ATENÇÃO:

Depois do interpretador pronto:
Implementar pgvector + tabela chunk_embeddings
Escolher um modelo (provavelmente text-embedding-3-small)
Embedar só um conjunto pequeno primeiro (ex.: 1 ano de exames)
Validar busca e auditoria
Só então embedar tudo

Se você quiser, o próximo passo bem calmo é:
eu te passo exatamente 3 comandos (um por vez) para instalar pgvector e criar a tabela,
mas só quando você disser que o interpretador já está pronto.

ATENÇÃO:

próximo passo “de verdade” quando retomarmos é:
fazer o interpret_chemistry_exam.sh já produzir um JSON/CSV que a UI consegue plotar diretamente.

OPERATIONAL DISCIPLINE RULE (PERMANENT)

Disciplina operacional (regra fixa)

Passar apenas 1 comando por vez e aguardar a resposta.
Antes de passar um comando, explicar resumidamente qual o objetivo.
Qualquer ajuste manual (UPDATE, correção de parser, etc.) deve ser registrado no STATUS antes de avançar.

End of 1_9_0
