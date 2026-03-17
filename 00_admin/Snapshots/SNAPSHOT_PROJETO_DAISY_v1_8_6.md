SNAPSHOT_PROJETO_DAISY_v1_8_6

Data: 03/03/2026
Estado: Pós-consolidação Thyroid + Correção Source + Banco Auditadamente Íntegro

1. Estado Geral do Sistema

Este snapshot representa o estado consolidado do Projeto Daisy após:
- Ingestão do T4 (Geriatric Profile) do PDF 06 na tabela thyroid
- Consolidação formal da regra fisiológica (Todo T4 → thyroid)
- Correção cirúrgica do campo source (collection_date=2026-01-14)
- Auditoria formal de integridade do banco SQLite

2. Banco SQLite — Verificação Formal

PRAGMA integrity_check → ok
PRAGMA foreign_key_check → limpo

Contagens confirmadas:
chemistry → 6 registros
thyroid → 2 registros

3. Chemistry — Registros Consolidados

2023-09-13 → 01 - IDEXX_SangueCompleto_13_09_2023.pdf
2023-12-19 → 02 - IDEXX_SangueCompleto_19_12_2023.pdf
2023-12-29 → 03 - IDEXX_SangueCompleto_29_12_2023.pdf
2024-04-05 → 04 - IDEXX_SangueCompleto_05_04_2024.pdf
2024-07-05 → 06 - IDEXX_SangueCompleto_04_07_2024_TiroideSusp.pdf
2026-01-14 → 35 - IDEXX_Sangue_Urina_Tireóide_Completo_14_01_2026.pdf

4. Thyroid — Registros Consolidados

2024-07-05 → T4 total = 10.3 (PDF 06)
2024-07-12 → TSH = 2.45 (PDF 07)

5. Regra Arquitetural Congelada

Todo parâmetro de tireoide (inclusive T4 proveniente de Geriatric Profile)
é armazenado exclusivamente na tabela thyroid.

A tabela chemistry permanece restrita a parâmetros bioquímicos.

6. Próxima Sessão — Diretriz Formal

Na próxima sessão iniciaremos explicitamente também a camada Postgres.

Criação das tabelas documents e chunks como base da Fase 3 (RAG).

Arquitetura paralela mantida sem migração prematura do SQLite.
