SNAPSHOT PROJETO DAISY — v1.9.9
Data: 2026-03-12


ESTRUTURA DO REPOSITÓRIO

Diretório principal:

~/projeto_daisy

Subdiretórios principais:

database/
data/
tools/
go/
00_admin/


BANCO DE DADOS

Arquivo ativo:

database/daisy.db

Tabelas principais presentes:

patients
chemistry
hematology
thyroid
urine
urine_culture
antibiogram
weight
diet
temperature
blood_pressure
medication
cardiac_auscultation
estrous_cycle
stool
endocrine


URINÁLISE

Script criado nesta sessão:

tools/ingest_urine.sh

Função:

extração automática de urinálises IDEXX.

Pipeline:

PDF
→ pdftotext
→ parser bash
→ UPSERT SQLite.


Tabela alvo:

urine


CULTURAS URINÁRIAS

Tabela:

urine_culture

já populada anteriormente com 8 registros.

Cada cultura mantém referência ao PDF original.


ANTIBIOGRAMAS

Tabela:

antibiogram

estrutura criada.

Ainda sem ingestão automática.

PDF identificado com antibiograma completo:

34 - IDEXX_UrinaCultura_14_01_26.pdf

Organismo:

Streptococcus canis


PDF 37

37 - IDEXX_UrinaCultura_12_02_2026.pdf

Resultado:

Mixed Flora

Interpretado como contaminação.

Não contém antibiograma.


REGRAS DE TRABALHO DO PROJETO

Scripts não são editados manualmente.

Fluxo obrigatório:

remover
recriar
colar
salvar


OBSERVAÇÃO ARQUITETURAL

A repetição de parsers para relatórios IDEXX
mostrou-se pouco eficiente.

Os relatórios apresentam estrutura suficientemente
padronizada para permitir um parser universal.

Possível evolução futura:

ingest_idexx.sh

capaz de detectar automaticamente:

tipo de exame
urinálise
cultura
antibiograma

e alimentar as tabelas adequadas.

Essa mudança não altera a arquitetura clínica
do sistema Daisy, apenas simplifica o processo
de ingestão.


ESTADO FINAL DO SISTEMA

Sistema permanece funcional.

Ingestão de urinálise agora operacional.

Cultura urinária previamente ingerida.

Parser de antibiograma ainda não implementado.

Nenhuma alteração estrutural do sistema foi feita
nesta sessão.

Este snapshot representa exatamente o estado do
Projeto Daisy ao final desta sessão.
