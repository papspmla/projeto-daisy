SNAPSHOT PROJETO DAISY — 1_8_3 (CHEMISTRY ESTÁVEL)

Data de geração: 2026-03-01 21:45:49

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

chemistry: UNIQUE(collection_date) ativo.
thyroid: tabela criada, UNIQUE(collection_date).
urine: tabela criada, UNIQUE(collection_date).


CONFIGURAÇÕES

~/projeto_daisy/config/chemistry_whitelist.txt
~/projeto_daisy/config/chemistry_blacklist_urine.txt
~/projeto_daisy/config/thyroid_whitelist.txt (pendente de refinamento)
~/projeto_daisy/config/urine_whitelist.txt (pendente de refinamento)


FERRAMENTAS

~/projeto_daisy/tools/ingest_chem.sh
~/projeto_daisy/tools/ingest_thyroid.sh (estrutura inicial)
~/projeto_daisy/tools/ingest_urine.sh (estrutura inicial)


STATUS ingest_chem.sh

- Pipeline CLEAN validado.
- Mapeamento explícito IDEXX → colunas do schema.
- Proteção contra duplicidade antes do INSERT.
- Escape de aspas implementado:
  SOURCE_SQL=${SOURCE//\'/\'\'}
- Dry-run funcional.
- Run funcional.
- Testado até collection_date 2024-04-05.


COMANDO CANÔNICO (CLEAN — CHEM)

grep -F -f ~/projeto_daisy/config/chemistry_whitelist.txt RAW \
| grep -E '^[[:space:]]+[A-Za-z]' \
| grep -v -F -f ~/projeto_daisy/config/chemistry_blacklist_urine.txt \
| grep -E '[0-9]' \
| grep -v 'fasting' \
| grep -v 'Both SDMA'


CHECKLIST POR PDF (ROTINA DEFINITIVA)

1) Validar data no raw (grep 'Date of receipt') e converter para YYYY-MM-DD.
2) Confirmar inexistência no DB (SELECT COUNT(*)...).
3) Gerar raw_layout com pdftotext -layout.
4) Executar ingest_chem.sh --dry-run.
5) Executar ingest_chem.sh --run.
6) Verificar integridade com SELECT específico.


PONTO ATUAL

PDFs completos (chemistry):

01 – 2023-09-13
02 – 2023-12-19
03 – 2023-12-29
04 – 2024-04-05


Próximo PDF a processar:

06 – 2024-07-04 (contém bioquímica + tireoide).


Estado geral:

Processo de ingestão chemistry industrializado e estável.


End of 1_8_3
