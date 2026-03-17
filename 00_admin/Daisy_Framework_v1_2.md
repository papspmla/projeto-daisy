PROJETO DAISY
FRAMEWORK ARQUITETURAL UNIFICADO v1.2
Data: 28/02/2026

============================================================
I. PRINCÍPIO FUNDAMENTAL
============================================================

Nenhum dado clínico relevante pode existir exclusivamente
na memória da IA.

O VPS é o repositório soberano.

IA é camada auxiliar.
Arquivos originais são autoridade primária.

============================================================
II. CAMADAS DO SISTEMA
============================================================

1) SISTEMA DE ARQUIVOS (FONTE PRIMÁRIA ABSOLUTA)
   - PDFs originais
   - Imagens
   - Áudios
   - CSV brutos
   - Estrutura organizada conforme Data-Standard

2) SQLITE (FONTE NUMÉRICA ESTRUTURADA)
   - Dados quantitativos
   - Séries temporais
   - Base para análise matemática
   - Derivado dos arquivos originais

3) POSTGRES (CAMADA FASE 3 – INDEXAÇÃO / IA)
   - documents
   - chunks
   - embeddings (futuro)
   - answers auditáveis
   - Derivado dos arquivos originais e/ou SQLite

Nenhuma camada substitui a anterior.
Cada camada deriva da anterior.

============================================================
III. REGRA OFICIAL DE NOMEAÇÃO
============================================================

Formato obrigatório:

YYYY-MM-DD__CATEGORIA__DESCRICAO__FONTE.ext

Regras:
- usar "_" e "__" como separadores
- sem espaços
- sem acentos
- datas em ISO (YYYY-MM-DD)

Exemplos:
2026-02-12__urina__cultura__IDEXX.pdf
2026-02-14__pressao__domiciliar__log.csv
2025-10-14__ultrassom__abdominal_completo__clinica.pdf

============================================================
IV. PASTA INBOX (DEFINIÇÃO FORMAL ÚNICA)
============================================================

Caminho oficial:

~/projeto_daisy/data/99_inbox/

Todo arquivo novo entra primeiro nesta pasta.
Nenhum arquivo entra diretamente em pastas finais.

Fluxo obrigatório:
1) Receber arquivo
2) Renomear conforme padrão
3) Mover para pasta clínica correta

============================================================
V. ÁRVORE CLÍNICA OFICIAL
============================================================

~/projeto_daisy/data/

  01_labs/
  02_ultrassom/
  03_pressao/
  04_temperatura/
  05_urina/
  06_feze/
  07_dieta/
  08_peso/
  09_auscultas/
  10_protocolos/
  99_inbox/

============================================================
VI. PIPELINE OPERACIONAL PADRÃO
============================================================

1) Arquivo entra em 99_inbox
2) Verificação humana
3) Renomeação padronizada
4) Movido para pasta definitiva
5) Extração (Tabula ou equivalente)
6) Importação para SQLite
7) Geração de representação textual estruturada
8) Gravação em Postgres (documents + chunks)
9) Indexação
10) (Opcional) Uso por IA com evidência

============================================================
VII. SOURCE OF TRUTH
============================================================

Fonte primária absoluta:
→ Arquivo original no filesystem.

Fonte estruturada numérica:
→ SQLite.

Fonte de indexação e IA:
→ Postgres.

Em caso de conflito:
arquivo original prevalece.

============================================================
VIII. REGRA DE OURO
============================================================

Nenhum dado clínico relevante pode existir
exclusivamente na memória da IA.

Todo dado relevante deve possuir registro físico no VPS.

============================================================
IX. POLÍTICA DE REPROCESSAMENTO
============================================================

Se um arquivo for reprocessado:

- SHA256 deve ser recalculado.
- Se hash mudou → nova versão lógica.
- Se hash igual → update permitido.
- Histórico deve ser preservado quando aplicável.

============================================================
X. BACKUP (DIRETRIZ MÍNIMA)
============================================================

Obrigatório:

- Backup periódico do volume Postgres.
- Backup do arquivo SQLite.
- Backup incremental dos PDFs.
- Backup da pasta ~/projeto_daisy/data/

============================================================
XI. PRINCÍPIO DE LONGO PRAZO
============================================================

Sistema projetado para 10+ anos.
Independente de fornecedor externo.
Reprodutível.
Auditável.
Determinístico.

IA nunca substitui o repositório.

------------------------------------------------------------
ARCHITECTURAL NOTE — POSTGRESQL DOCUMENT LAYER
Date: 16/03/2026
------------------------------------------------------------

During infrastructure inspection of the Daisy VPS, an existing
PostgreSQL database was identified.

Database:

    daisy_pg

Schema:

    daisy

Existing tables:

    documents
    chunks
    lab_metadata
    reference_ranges

This database does NOT belong to the operational clinical data
layer of the Daisy system.

The operational database of the system remains:

    SQLite
    ~/projeto_daisy/database/daisy.db

This PostgreSQL structure corresponds to an earlier architectural
preparation for a document-oriented storage layer intended for:

    document ingestion
    text chunking
    semantic indexing
    RAG (Retrieval Augmented Generation)

Current project decision:

    PostgreSQL will NOT be used in the current ingestion phase.

All structured clinical data ingestion will continue to be
implemented exclusively through the Daisy Ingest Engine (Go)
writing to SQLite.

PostgreSQL remains reserved for a future phase of the project,
when document ingestion and semantic retrieval capabilities
will be implemented.

Architectural separation is therefore defined as:

    Structured clinical data → SQLite

    Clinical documents / text corpus → PostgreSQL

This note is registered to prevent future ambiguity regarding
the role of the PostgreSQL database already present on the VPS.

------------------------------------------------------------
END OF ARCHITECTURAL NOTE
------------------------------------------------------------



============================================================
FIM DO DOCUMENTO
============================================================
