SNAPSHOT PROJETO DAISY — v2.0.2
Data: 2026-03-13
Servidor: Hetzner VPS
DB: SQLite
DB path: ~/projeto_daisy/database/daisy.db

==================================================
REGRAS PERMANENTES DO PROJETO
==================================================

ATENÇÃO: Quando gera um novo snapshot essas regras devem sempre
ser copiadas para o próximo snapshot. São regras permanentes.

==========================
REGRAS DE TRABALHO DO PROJETO
==========================

Scripts não são editados manualmente.

Fluxo obrigatório:

remover
recriar
colar
salvar

--------------------------------------------------

1) DIREÇÃO DO PROJETO

A direção estratégica, prioridades, sequência de trabalho e visão
global do Projeto Daisy pertencem exclusivamente ao Paulo.

O assistente não deve propor mudança de rumo,
redefinir escopo ou induzir redirecionamento do projeto.

--------------------------------------------------

2) SUGESTÕES PERMITIDAS

O assistente está autorizado a sugerir apenas:

- novas funcionalidades
- melhorias operacionais
- melhorias analíticas

Essas sugestões devem ser apresentadas apenas como opções.

--------------------------------------------------

3) ARQUITETURA DO SISTEMA

Sugestões arquitetônicas devem ser limitadas a 1 linha.

Exceção apenas quando houver risco real de:

- comprometer integridade de dados
- quebrar o modelo
- gerar retrabalho estrutural relevante
- criar bloqueio técnico grave

--------------------------------------------------

4) STATUS OFICIAL DO SISTEMA

O snapshot mais recente enviado pelo Paulo é o estado oficial
do Projeto Daisy.

FIM DAS REGRAS

==================================================
ESTADO DO SISTEMA
==================================================

O banco de dados foi consolidado em modo multipaciente.

FKs consistentes foram aplicadas.

Tabela redundante endocrine removida.

Domínios clínicos de imagem criados:

stool
stool_images

vulva
vulva_images

Schema completo registrado em:

~/projeto_daisy/00_admin/daisy_schema_2026-03-13.sql

==================================================
ARQUITETURA DO BANCO
==================================================

patients
  │
  ├── chemistry
  ├── hematology
  ├── thyroid
  ├── urine
  │     └── urine_culture
  │           └── culture_isolate
  │                 └── antibiogram
  │
  ├── blood_pressure
  ├── temperature
  ├── weight
  ├── diet
  ├── medication
  ├── cardiac_auscultation
  ├── estrous_cycle
  │
  ├── stool
  │     └── stool_images
  │
  └── vulva
        └── vulva_images

==================================================
ARMAZENAMENTO DE IMAGENS
==================================================

Diretório de mídia criado no VPS:

~/projeto_daisy/media

Estrutura:

~/projeto_daisy/media
├── stool
│   └── 2026
└── vulva
    └── 2026

As imagens são armazenadas fora do banco de dados
e referenciadas nas tabelas:

stool_images
vulva_images

==================================================
PRIMEIRA TAREFA DA PRÓXIMA SESSÃO
==================================================

Implementar o pipeline inicial de ingestão de imagens.

Pipeline:

iPhone → VPS → metadata → banco → OpenAI → análise → stool

Fluxo:

1) armazenar fotos no VPS
2) extrair metadata da imagem
3) criar registro em stool
4) criar registro em stool_images
5) enviar imagem para OpenAI Vision API
6) registrar análise no banco

Este será o primeiro fluxo funcional completo do Daisy.
