Projeto Daisy — Snapshot v1.8.9

Date: 05 March 2026

Session summary:
Completion of chemistry backfill ingestion and integrity verification.

1. System State

All historical chemistry PDFs were successfully ingested into the system.

SQLite (chemistry), PostgreSQL (documents) and PostgreSQL (chunks)
are fully synchronized.

2. Integrity Verification

SQLite chemistry rows: 21
PostgreSQL documents (pdf): 21
PostgreSQL chunks: 168 (21 × 8)

Result: full consistency confirmed.

3. Examinations Covered

2023-09-13
2023-12-19
2023-12-29
2024-04-05
2024-07-05
2024-10-17
2024-12-09
2025-03-18
2025-04-23
2025-05-21
2025-05-27
2025-06-03
2025-06-11
2025-06-18
2025-06-26
2025-08-27
2025-10-01
2025-10-31
2025-12-03
2026-01-14
2026-02-12

4. Parser Behaviour

The ingestion pipeline successfully handled two report layouts:

• Early reports: blood chemistry only.
• Later reports: combined blood + urine panels.

The blacklist correctly prevented urine parameters from contaminating
the chemistry table.

5. Known Operational Noise

A minor terminal copy/paste artefact occurred during a PostgreSQL
insert command (‘INSERT 0 0’ followed by ‘command not found’).

The final integrity audit confirmed no data corruption or duplication.

6. Pending Architectural Items

Future schema extensions to preserve laboratory analytical context:

• lab_metadata table (lab name, equipment, method, etc.)
• reference_ranges table (range per analyte, lab, and time period)

7. Next Session Starting Point

Implement an industrial ingestion script capable of processing
a new PDF in a single command.

The script will internally perform:

- pdftotext extraction
- date detection
- chemistry ingestion
- PostgreSQL document registration
- chunk generation

8. Operational Discipline Rule (Permanent)

Disciplina operacional (regra fixa)

Passar apenas 1 comando por vez e aguardar a resposta.

Antes de passar um comando, explicar resumidamente qual o objetivo.

Qualquer ajuste manual (UPDATE, correção de parser, etc.)
deve ser registrado no STATUS antes de avançar.

End of 1_8_9
