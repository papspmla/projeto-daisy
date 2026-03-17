SNAPSHOT PROJETO DAISY — v1.8.2 (ROTINA OTIMIZADA / PLANO C)

Data:

pwd padrão:

DB: ~/projeto_daisy/database/daisy.db


REGRAS OPERACIONAIS:

- 1 comando por vez; eu executo e retorno.
- Quando eu precisar retorno: “Copie aqui o resultado”.
- Sem adivinhação.
- Sem criar arquivos novos sem eu pedir explicitamente.
- Validar data primeiro, isolado, antes de qualquer extração clínica.
- Valores censurados <x ou >x → armazenar NULL.


ESTADO DO BANCO:

- chemistry: UNIQUE(collection_date) ativo.
- thyroid: (será criado) UNIQUE(collection_date).
- urinalysis: (será criado) UNIQUE(collection_date).


CONFIGS:

- ~/projeto_daisy/config/chemistry_whitelist.txt
- ~/projeto_daisy/config/chemistry_blacklist_urine.txt
- ~/projeto_daisy/config/thyroid_whitelist.txt (pendente)
- ~/projeto_daisy/config/urine_whitelist.txt (pendente)


FERRAMENTAS:

- ~/projeto_daisy/tools/ingest_chem.sh
- ~/projeto_daisy/tools/ingest_thyroid.sh
- ~/projeto_daisy/tools/ingest_urine.sh


COMANDO CANÔNICO (CLEAN — CHEM):

grep -F -f ~/projeto_daisy/config/chemistry_whitelist.txt RAW \
| grep -E '^[[:space:]]+[A-Za-z]' \
| grep -v -F -f ~/projeto_daisy/config/chemistry_blacklist_urine.txt \
| grep -E '[0-9]' \
| grep -v 'fasting' \
| grep -v 'Both SDMA'


CHECKLIST POR PDF (curto):

1) Validar data no raw (grep -c “Date of receipt” = 1) e converter para YYYY-MM-DD.

2) Confirmar inexistência no DB:
   SELECT collection_date FROM chemistry WHERE collection_date='YYYY-MM-DD';

3) Rodar dry-run:
   ingest_chem.sh --dry-run --date ... --raw ... --source ...
   ingest_thyroid.sh --dry-run ...
   ingest_urine.sh --dry-run ...

4) Rodar run (quando OK):
   ingest_chem.sh --run ...
   (idem thyroid/urine)

5) Verificar:
   SELECT * FROM chemistry WHERE collection_date='YYYY-MM-DD';
   (idem thyroid/urine)


PONTO ATUAL:

- PDFs completos: 01 (2023-09-13), 02 (2023-12-19), 03 (2023-12-29)
- Próximo PDF: 04 ...


End of 1_8_2
