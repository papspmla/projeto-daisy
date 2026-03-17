SNAPSHOT — PROJETO DAISY v1.8.8

Data: 04/03/2026


1. Objetivo do snapshot

Congelar o estado operacional do Projeto Daisy após:

(i) ativação de backups automáticos e agendamento por cron  
(ii) backfill de documents + chunks de chemistry no Postgres  
(iii) ingestão adicional de chemistry no SQLite para datas 2024-10-17 e 2024-12-09, com chunking correspondente.


2. Disciplina operacional (regra fixa)

Passar apenas 1 comando por vez e aguardar a resposta.

Antes de passar um comando, explicar resumidamente qual o objetivo.

Qualquer ajuste manual (UPDATE, correção de parser, etc.)
deve ser registrado no STATUS antes de avançar.


3. Backups — início do processo e política

Marco: 04/03/2026 passa a ser a data oficial de início do regime de backups do Projeto Daisy.

Backups gerados manualmente nesta sessão (validados):

SQLite:
~/projeto_daisy/backups/daisy_sqlite_2026-03-04.db

Postgres:
~/projeto_daisy/backups/daisy_postgres_2026-03-04.sql  
(via TCP: -h 127.0.0.1; peer auth evitado)

Filesystem:
~/projeto_daisy/backups/daisy_filesystem_2026-03-04.tar.gz  
(excluindo backups)


Automação criada (script único):

~/projeto_daisy/tools/backup_daisy.sh


Características do script:

set -euo pipefail; umask 077

Logs em:
~/projeto_daisy/logs/backup/
(um arquivo por execução)

Lock simples para evitar execuções concorrentes:
/tmp/daisy_backup.lock

SHA256 gerado para cada artefato de backup

SQLite: diário  
Postgres + filesystem: semanal (domingo)

Retenção:
SQLite 30 dias  
Postgres/filesystem 12 semanas


Agendamento via cron
(executa mesmo sem usuário logado):

17 3 * * * /home/paulo/projeto_daisy/tools/backup_daisy.sh >/dev/null 2>&1


4. Postgres — backfill de documents e chunks (chemistry)

Estado consolidado após a sessão:

Tabela daisy.documents preenchida para todos os PDFs
com chemistry já ingeridos no SQLite.

Chunks de chemistry v1.0 gerados com sucesso
para todas as datas ingeridas.


Validação objetiva do backfill inicial:

SELECT COUNT(*) FROM daisy.chunks;
-- retornou 48 (6 exames x 8 chunks)


5. Ingestão adicional no SQLite (chemistry) + chunking correspondente

Novas datas ingeridas no SQLite nesta sessão:

2024-10-17 — 08 - IDEXX_SangueCompleto_T4_T4Livre_17_10_2024.pdf  
2024-12-09 — 09 - IDEXX_SangueCompleto_T4_T4Livre_09_12_2024.pdf


Procedimento usado (padrão):

pdftotext -layout para gerar raw_layout

ingest_chem.sh --dry-run
(validar SQL gerado)

ingest_chem.sh --run
(inserção real)

Inserção do PDF em daisy.documents
(quando faltante)

generate_chem_chunks.sh
para gerar 8 chunks


Infra criada para raw_layout:

mkdir -p ~/projeto_daisy/import/raw


Após as duas novas ingestões, o sistema passou a ter:

SQLite/chemistry:
8 collection_dates
(inclui 2024-10-17 e 2024-12-09)

Postgres/documents (pdf):
8 registros correspondentes

Postgres/chunks:
+16 chunks adicionados nesta sessão
para essas duas datas


6. Pendências registradas (para evolução futura)

6.1 Normalizar significado ao longo do tempo (tema reservado)

Quando a linha histórica fica longa,
o problema deixa de ser apenas técnico
e passa a ser arquivístico + clínico:

comparabilidade longitudinal
(unidades, métodos, ranges, reemissões, etc.)

Este tema foi explicitamente reservado
para ser abordado oportunamente,
após completar o backfill.


7. Ponto exato de retomada (próximo passo)

Backfill em andamento.

Próximo exame cronológico a processar:

PDF 10 —  
10 - IDEXX_SangueCompleto_T4_T4Livre_17_03_2025.pdf


PASSO 1 — Gerar raw_layout do PDF 10


Comando previsto
(não executado neste snapshot):

pdftotext -layout \
"/home/paulo/projeto_daisy/import/pdfs/chemistry/10 - IDEXX_SangueCompleto_T4_T4Livre_17_03_2025.pdf" \
"/home/paulo/projeto_daisy/import/raw/10_2025-03-17_raw_layout.txt"


End of 1_8_8
