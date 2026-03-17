SNAPSHOT_PROJETO_DAISY_v2_0_8
Data: 15/03/2026

------------------------------------------------------------
SITUAÇÃO DO PROJETO
------------------------------------------------------------

Infraestrutura estabilizada.

Banco SQLite funcional.

Estrutura de tabelas clínicas completa.

Fluxo de ingestão testado:

Google Drive → VPS → data/99_inbox

Arquivos clínicos históricos importados.

Master Index recuperado.

------------------------------------------------------------
DECISÃO ARQUITETURAL FINAL
------------------------------------------------------------

O Projeto Daisy adotará permanentemente:

MOTOR ÚNICO DE INGESTÃO EM GO.

Nenhuma solução alternativa será mantida.

Todo dado clínico será ingerido por este motor.

------------------------------------------------------------
PRÓXIMA TAREFA (RETOMADA DO PROJETO)
------------------------------------------------------------

Implementar a primeira versão funcional do:

DAISY INGEST ENGINE

Arquivo:

ingest.go

Primeiro módulo:

TEMPERATURE INGESTION

Funções necessárias:

1) ler arquivo TXT
2) ignorar cabeçalhos
3) remover marcador "*"
4) converter data dd/mm/yyyy → yyyy-mm-dd
5) inserir na tabela temperature
6) evitar duplicação (índice único já existente)

Após validação:

expandir o mesmo motor para:

blood_pressure
weight
diet
stool
urine
auscultation

------------------------------------------------------------
OBJETIVO ESTRATÉGICO
------------------------------------------------------------

Popular o banco Daisy com
todo o histórico clínico da paciente.

Sem downgrade de escopo.

Projeto segue arquitetura original.

------------------------------------------------------------
FIM DO SNAPSHOT
------------------------------------------------------------
