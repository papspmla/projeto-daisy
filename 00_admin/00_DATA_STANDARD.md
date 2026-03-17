# PROJETO DAISY — DATA STANDARD (v1.0)
Data: 26/02/2026
Padrão oficial para organização e ingestão de dados clínicos.

------------------------------------------------------------
1) PRINCÍPIO
------------------------------------------------------------
- Todo dado clínico deve ser armazenado de forma rastreável.
- Nenhum valor numérico entra no sistema estruturado sem verificação humana.
- Nomeação e organização devem permitir operação por 10+ anos.

------------------------------------------------------------
2) REGRA DE NOMEAÇÃO (OBRIGATÓRIA)
------------------------------------------------------------
Formato:
YYYY-MM-DD__CATEGORIA__DESCRICAO__FONTE.ext

Regras:
- usar underscore "_" e dupla-underscore "__" como separador de campos
- sem espaços, sem acentos, sem caracteres especiais
- datas sempre no padrão ISO (YYYY-MM-DD)

Exemplos:
2026-02-12__urina__cultura__IDEXX.pdf
2026-02-14__pressao__domiciliar__log.csv
2025-10-14__ultrassom__abdominal_completo__clinica.pdf

------------------------------------------------------------
3) PASTA INBOX (ENTRADA)
------------------------------------------------------------
- Todo arquivo novo entra primeiro em:
~/projeto_daisy/99_inbox/
- Depois de verificado e renomeado, é movido para a pasta clínica correta.
- Nada “entra direto” em pastas finais sem padronização.

------------------------------------------------------------
4) ÁRVORE CLÍNICA (v1.0)
------------------------------------------------------------
Dentro de ~/projeto_daisy/data/ :

data/
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

------------------------------------------------------------
5) METADADOS (MÍNIMO) — FASE FUTURA
------------------------------------------------------------
- Quando aplicável, manter um .json ao lado do arquivo:
  mesmo_nome_do_arquivo.json
- Conteúdo mínimo sugerido:
  patient, date, source, sample_method, clinical_context, notes
