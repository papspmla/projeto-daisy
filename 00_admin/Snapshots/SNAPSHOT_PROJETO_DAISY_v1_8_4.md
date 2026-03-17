SNAPSHOT PROJETO DAISY — v1.8.4 (CHEMISTRY ESTÁVEL + SDMA FIX + PRÓXIMO: THYROID)

Data de geração: 2026-03-02
pwd padrão: ~/projeto_daisy
DB: ~/projeto_daisy/database/daisy.db

REGRAS OPERACIONAIS
- 1 comando por vez; o usuário executa e retorna o output.
- Sem adivinhação.
- Sem criar arquivos novos sem autorização explícita.
- Validar data isoladamente antes de qualquer extração clínica.
- Valores censurados (<x ou >x) → armazenar NULL.
- Sempre validar duplicidade antes de INSERT.

ESTADO DO BANCO
- chemistry: UNIQUE(collection_date) ativo.
- thyroid: tabela criada, UNIQUE(collection_date). (0 registros confirmado)
- urine: tabela criada, UNIQUE(collection_date).

Registros atuais em chemistry:
- 2023-09-13
- 2023-12-19
- 2023-12-29
- 2024-04-05
- 2024-07-05
- 2026-01-14

CONFIGURAÇÕES
- ~/projeto_daisy/config/chemistry_whitelist.txt
- ~/projeto_daisy/config/chemistry_blacklist_urine.txt
- ~/projeto_daisy/config/thyroid_whitelist.txt (pendente de refinamento)
- ~/projeto_daisy/config/urine_whitelist.txt (pendente de refinamento)

FERRAMENTAS
- ~/projeto_daisy/tools/ingest_chem.sh
- ~/projeto_daisy/tools/ingest_thyroid.sh (estrutura inicial)
- ~/projeto_daisy/tools/ingest_urine.sh (estrutura inicial)

STATUS ingest_chem.sh (ATUALIZADO)
- Pipeline CLEAN validado.
- Mapeamento explícito IDEXX → colunas do schema.
- Proteção contra duplicidade antes do INSERT.
- Escape de aspas implementado: SOURCE_SQL=${SOURCE//'/''}
- Dry-run funcional.
- Run funcional.
- Compatibilidade SDMA corrigida para label IDEXX.

FIX APLICADO (SDMA)

Problema identificado:
- Label “IDEXX SDMA™ EIA” não era reconhecido pelo parser.

Correção aplicada:
- Parser ajustado para aceitar:
  SDMA (EIA)
  SDMA
  IDEXX SDMA™ EIA
  IDEXX SDMA EIA

Teste de parser confirmado:
- SDMA extraído corretamente como 9.

Correção no DB:
- chemistry 2024-07-05 → sdma_ug_dL = 9.0

COMANDO CANÔNICO (CLEAN — CHEM)
grep -F -f ~/projeto_daisy/config/chemistry_whitelist.txt RAW \
| grep -E '^[[:space:]]+[A-Za-z]' \
| grep -v -F -f ~/projeto_daisy/config/chemistry_blacklist_urine.txt \
| grep -E '[0-9]' \
| grep -v 'fasting' \
| grep -v 'Both SDMA'

CHECKLIST POR PDF (CHEMISTRY)
1) Validar data no raw.
2) Confirmar inexistência no DB.
3) Gerar raw_layout com pdftotext -layout.
4) Executar ingest_chem.sh --dry-run.
5) Executar ingest_chem.sh --run.
6) Verificar integridade com SELECT.

PONTO ATUAL
Chemistry processado até 06 – 2024-07-05 (SDMA corrigido).
Thyroid ainda sem registros.

PRÓXIMA ORDEM DEFINIDA
1) Processar PDF 07 (tireóide isolado).
2) Refinar definitivamente ingest_thyroid.sh antes de qualquer ingestão.
