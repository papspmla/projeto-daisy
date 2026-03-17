SNAPSHOT PROJETO DAISY — v1.8.5 (BASELINE + THYROID + URINE VALIDADO)

Data de geração: 2026-03-02 22:41

1. BASELINE OPERACIONAL (STATUS v1.10 CONGELADO)

Arquitetura considerada estável:
- Infraestrutura VPS validada (SSH 2222, UFW, Fail2Ban)
- Estrutura de diretórios clínica consolidada
- SQLite como fonte oficial estruturada (chemistry, thyroid, urine)
- Pipeline chemistry blindado e validado
- ingest_thyroid.sh reconstruído e validado
- UNIQUE(collection_date) aplicado em chemistry e thyroid

2. EVENTO TÉCNICO — RECONSTRUÇÃO DO ingest_thyroid.sh

Problema identificado:
extração incorreta de tokens (T4, Free, TSH,)

Decisão:
apagar o script e reconstruir do zero via nano.

Implementado:
extração pós-label + primeiro token válido.

Regra aplicada:
valores <x ou >x → NULL.

Iodine ICP explicitamente excluído (exame separado).

Validação:
dry-run → run → SELECT confirmado.

3. VALIDAÇÃO ESTRUTURAL — TABELA URINE

Confirmação via .schema urine:
tabela existe e index por collection_date ativo.

Estrutura inclui:
strip, sedimento, cultura, UPC e organismo.

Observação arquitetural relevante:
- urine NÃO possui UNIQUE(collection_date).
- Decisão estrutural pendente: permitir múltiplas urinas por data ou impor unicidade.

Esta decisão será tomada antes da primeira ingestão automatizada de urina.

4. ESTADO ATUAL DO BANCO

Chemistry:
- 2023-09-13
- 2023-12-19
- 2023-12-29
- 2024-04-05
- 2024-07-05 (SDMA corrigido)
- 2026-01-14

Thyroid:
- 2024-07-12 (T4 NULL, FT4 NULL, TSH 2.45)

5. PRÓXIMA SESSÃO — PLANO EXPLÍCITO

TRILHA A — SQLite
1) Implementar ingest_weight
2) Implementar ingest_temperature
3) Definir política estrutural para UNIQUE em urine

TRILHA B — Início Formal do Postgres
1) Instalar Postgres no VPS
2) Criar banco dedicado
3) Criar tabelas: documents e chunks
4) Manter SQLite como fonte oficial dos dados clínicos

Compromisso:
início explícito do Postgres será declarado no começo da próxima sessão.
