# Daisy Ingest Engine — Architecture

Status: Draft
Date: 2026-03-15

------------------------------------------------------------
OBJECTIVE
------------------------------------------------------------

Implement a unified ingestion engine responsible for
processing external clinical data entering the Daisy system.

The engine replaces multiple ad-hoc ingestion scripts and
centralizes all parsing and validation logic.

------------------------------------------------------------
ENGINEERING CHARTER COMPLIANCE
------------------------------------------------------------

Language: Go
Shell scripts: wrappers only
Database: SQLite (current system of record)

------------------------------------------------------------
INPUT SOURCES
------------------------------------------------------------

Primary external input:

Google Drive ingestion structure

VPS-DAISY/
   Imagens/
   Audio/
   Registros/

Files are retrieved to:

data/99_inbox

------------------------------------------------------------
SUPPORTED INPUT TYPES
------------------------------------------------------------

TXT clinical records
Clinical images
Clinical audio
PDF clinical reports

------------------------------------------------------------
TXT CLINICAL RECORDS
------------------------------------------------------------

TXT records originate from iPhone Notes.

Mandatory rule:

Paciente: <name>

The parser must support multipatient operation.

------------------------------------------------------------
TEMPERATURE RECORDS
------------------------------------------------------------

Example:

Paciente: Daisy

16/03/2026 13:15 38.0 relaxada na cama

Structure:

DATE TIME VALUE CONTEXT

------------------------------------------------------------
BLOOD PRESSURE SESSIONS
------------------------------------------------------------

Example:

Paciente: Daisy

14/03/2026 12:40 AE oscilometrico recem acordada relaxada

132 92 103
128 89 99
124 88 97
121 86 95
119 85 93
118 84 92
117 83 91

------------------------------------------------------------
METHOD-DEPENDENT PARSING
------------------------------------------------------------

Field:

method

Possible values:

oscilometrico
doppler

Parsing rules:

Oscillometric
Each measurement line contains:
SYSTOLIC DIASTOLIC MAP

Doppler
Each measurement line contains:
SYSTOLIC

------------------------------------------------------------
DATA DESTINATION
------------------------------------------------------------

After validation the parsed data is written to the SQLite
clinical database.

------------------------------------------------------------
FUTURE AUTOMATION
------------------------------------------------------------

Manual ingestion will be replaced by:

daisy-sync
+
daisy-ingest

------------------------------------------------------------
# DAISY INGEST ENGINE

Regra de Chumbo (imutável)

O Projeto Daisy utilizará um único motor de ingestão
implementado em Go.

Este motor será responsável por processar todos os tipos
de dados clínicos:

- TXT clínicos
- PDFs de exames
- imagens clínicas
- áudios de auscultação
- qualquer outro registro clínico relevante

Objetivo operacional imediato

Popular o banco de dados do Daisy com os dados reais da Daisy
o mais rapidamente possível.

Durante o processo de ingestão:

- utilizar as tabelas já existentes sempre que possível
- criar novas tabelas quando necessário
- corrigir ou ampliar o schema quando os dados reais exigirem

Arquitetura de ingestão

O sistema utilizará um pipeline baseado em inbox.

Todo arquivo entra primeiro em:

data/99_inbox

O motor daisy-ingest lê exclusivamente esta pasta.

Após processamento:

- os dados são gravados no banco SQLite
- o arquivo é movido para a pasta definitiva apropriada

Exemplo de fluxo:

Google Drive / uploads
      ↓
data/99_inbox
      ↓
daisy-ingest (Go)
      ↓
SQLite database
      ↓
pastas definitivas (03_pressao, 04_temperatura, etc)

Esta decisão é estrutural e não deve ser alterada
sem revisão explícita da arquitetura do sistema.
