SNAPSHOT_PROJETO_DAISY_v2_0_9
Data: 2026-03-16

Estado geral do sistema

Infraestrutura
- VPS Hetzner ativo
- Ubuntu 24.04
- acesso SSH estável
- ambiente Go configurado

Banco de dados

SQLite
database/daisy.db

Tabelas clínicas existentes:
- blood_pressure
- temperature
- stool
- stool_images
- vulva
- vulva_images
- weight
- diet
- medication
- thyroid
- urine
- urine_culture
- cardiac_auscultation
- chemistry
- hematology
- patients

PostgreSQL

Servidor PostgreSQL ativo.

Database:
daisy_pg

Schema existente:
daisy

Tabelas documentais existentes:
- documents
- chunks
- lab_metadata
- reference_ranges

Observação
PostgreSQL reservado para camada documental e futura implementação de RAG.

Motor de ingestão

Arquivo fonte:
~/projeto_daisy/ingest.go

Binário:
~/projeto_daisy/daisy_ingest

Arquitetura modular via parâmetro -module

Módulos implementados

temperature
Ingestão de registros de temperatura corporal via TXT.

bp_legacy
Importação de histórico consolidado de pressão arterial.

Dados ingeridos nesta sessão

Pressão arterial
Arquivo: BPDAISY.txt

Registros ingeridos:
15

Período:
05/10/2025 → 14/03/2026

Tabela destino:
blood_pressure

source:
bp_legacy

Validação executada

SELECT collection_date, systolic_mmHg, diastolic_mmHg, map_mmHg, source
FROM blood_pressure
ORDER BY collection_date;

Resultado: 15 registros confirmados no banco.

Template definido para medições futuras

Formato bp_session:

date
time
method
limb
context

SYS DIA
SYS DIA
SYS DIA
SYS DIA
SYS DIA
SYS DIA
SYS DIA

Regras clínicas definidas

- primeira leitura descartada
- média calculada pelo Daisy
- MAP calculado automaticamente
- resultado gravado na tabela blood_pressure

Próxima tarefa técnica prioritária

Implementar módulo:

bp_session

Função:
ingerir sessões completas de medição de pressão arterial.

Processamento esperado:

1. leitura das 7 medições
2. descarte da primeira
3. cálculo da média das 6 restantes
4. cálculo automático do MAP
5. gravação na tabela blood_pressure

Nota de arquitetura

O ingest engine em Go passa a ser o motor único de ingestão do Daisy,
substituindo scripts bash e pipelines fragmentados.
