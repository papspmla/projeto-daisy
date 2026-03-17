# BLOCO CONSTITUCIONAL OBRIGATÓRIO — PROJETO DAISY
## Protocolo Operacional de Sessão e Geração de Snapshots

Este bloco define regras operacionais obrigatórias para qualquer sessão de trabalho envolvendo o Projeto Daisy.

Estas regras são mandatórias e devem ser consideradas contrato de operação da sessão.

----------------------------------------------------------------

REGRA FUNDAMENTAL DE PROPAGAÇÃO DO BLOCO

Sempre que o assistente for solicitado a gerar um novo snapshot do Projeto Daisy, ele DEVE copiar este bloco integralmente no início do novo snapshot, sem qualquer modificação, omissão, resumo ou reordenação.

O novo snapshot deve começar exatamente por este bloco.

Nenhuma seção pode aparecer antes dele.

Esta regra aplica-se a todos os snapshots futuros, sem exceção.

----------------------------------------------------------------

AUTORIDADE DO SNAPSHOT

O snapshot atual define:

- o estado técnico do sistema
- as decisões de arquitetura
- as regras operacionais da sessão
- a próxima tarefa técnica

Durante a sessão, o snapshot é considerado a autoridade máxima de contexto.

O assistente não deve ignorar, reinterpretar ou relativizar regras contidas no snapshot.

----------------------------------------------------------------

PROTOCOLO DE INÍCIO DE SESSÃO

Antes de propor qualquer ação técnica, o assistente deve:

1. Ler integralmente o snapshot apresentado.
2. Identificar as regras operacionais nele contidas.
3. Confirmar a tarefa técnica prioritária definida no snapshot.
4. Prosseguir exclusivamente dentro dessas regras.

O assistente não deve iniciar implementação ou modificação de código antes de compreender o estado descrito no snapshot.

----------------------------------------------------------------

REGRA OPERACIONAL CRÍTICA — INTERAÇÃO COM O USUÁRIO

No Projeto Daisy aplica-se a seguinte regra:

O usuário não edita código manualmente.

Consequentemente:

- o assistente não deve pedir ao usuário para abrir editor
- o assistente não deve pedir edição manual de arquivos
- o assistente não deve instruir o usuário a modificar código diretamente

Toda alteração deve ocorrer através de procedimentos controlados e reproduzíveis.

----------------------------------------------------------------

REGRA ESTRITA DE MODIFICAÇÃO DE ARQUIVOS

No Projeto Daisy é proibido editar parcialmente arquivos existentes.

Isso inclui qualquer forma de modificação incremental ou patch.

Esta proibição aplica-se tanto a:

- edição manual
- edição programática
- scripts de substituição de texto
- ferramentas automáticas de patch

Mesmo quando realizada por código, a substituição parcial de conteúdo continua sendo considerada **edição**.

----------------------------------------------------------------

REGRA CORRETA DE ALTERAÇÃO DE ARQUIVOS

Quando for necessário modificar um arquivo existente, o procedimento obrigatório é:

1. Inspecionar o estado atual.
2. Gerar um **arquivo novo completo** com o conteúdo desejado.
3. Validar o novo arquivo.
4. Substituir o arquivo antigo **inteiramente**.

A substituição deve ocorrer apenas através de operações como:

- criação de arquivo novo
- substituição completa de arquivo
- renomeação/movimentação de arquivo
- remoção de arquivo antigo
- backup prévio antes da substituição

Este princípio pode ser resumido como:

REPLACE WHOLE FILE — NEVER PATCH IN PLACE

----------------------------------------------------------------

OPERAÇÕES PERMITIDAS

No Projeto Daisy são permitidas apenas as seguintes operações sobre arquivos:

- criar arquivo novo
- remover arquivo temporário
- substituir um arquivo inteiro por outro arquivo inteiro
- renomear ou mover arquivos
- criar backup antes de substituição (semore)

----------------------------------------------------------------

OPERAÇÕES PROIBIDAS

São proibidas as seguintes práticas:

- substituição de trechos dentro de arquivos existentes
- busca-e-troca interna
- patch parcial
- edição incremental
- scripts que modifiquem apenas partes de arquivos
- qualquer mecanismo que altere parcialmente um arquivo já existente

----------------------------------------------------------------

REGRA DE EXECUÇÃO DE COMANDOS

O trabalho técnico deve seguir o modelo:

- um comando por vez
- cada comando deve ter objetivo claro
- cada comando deve ser verificável

O assistente não deve emitir sequências longas de comandos sem verificação intermediária.

----------------------------------------------------------------

PROIBIÇÕES ABSOLUTAS

Durante sessões do Projeto Daisy é proibido ao assistente:

- pedir edição manual de código
- sugerir refatorações fora da tarefa prioritária
- ignorar o snapshot atual
- alterar arquitetura já definida sem solicitação explícita
- iniciar implementação sem inspeção do estado atual
- omitir regras normativas nos snapshots seguintes
- modificar parcialmente arquivos existentes

----------------------------------------------------------------

REGRA DE INTEGRIDADE DOS SNAPSHOTS

Cada snapshot do Projeto Daisy deve ser autossuficiente.

Isso significa que o snapshot deve conter integralmente:

1. este Bloco Constitucional Obrigatório
2. a Constitution do Projeto Daisy
3. o Engineering Charter
4. as regras operacionais do sistema
5. o estado técnico atual
6. a tarefa prioritária da próxima sessão

Nenhum snapshot deve depender de contexto externo para ser compreendido.

----------------------------------------------------------------

CLÁUSULA DE INVALIDAÇÃO

Se o assistente violar qualquer regra deste bloco:

- a resposta deve ser considerada fora do protocolo
- a sessão deve retornar ao estado anterior
- nenhuma alteração técnica deve ser considerada válida

----------------------------------------------------------------

PRINCÍPIO DE DISCIPLINA OPERACIONAL

O Projeto Daisy segue princípios clássicos de engenharia de sistemas:

- rastreabilidade
- determinismo
- reprodutibilidade
- preservação de contexto

O snapshot existe para impedir perda de contexto entre sessões.

Este bloco passa a ser considerado parte permanente da governança técnica do Projeto Daisy.

Todos os snapshots futuros devem começar por ele.

# SNAPSHOT_PROJETO_DAISY_v2_1_1
Data: 2026-03-17

## Observação de integridade deste snapshot

Este snapshot contém integralmente o bloco constitucional obrigatório.

Entretanto, por honestidade técnica, continua valendo a mesma observação do snapshot anterior: para ficar 100% conforme a regra de autossuficiência definida pelo próprio projeto, ainda devem ser colados abaixo, a partir de seus arquivos canônicos, os textos integrais de:

- Constitution do Projeto Daisy
- Engineering Charter

Eles não foram recarregados nesta sessão e, portanto, não foram reconstruídos de memória.

## Estado geral do sistema

### Infraestrutura
- VPS Hetzner ativo
- Ubuntu 24.04
- acesso SSH estável
- ambiente Go configurado

### Paths canônicos validados
- `DAISY_ROOT=/home/paulo/projeto_daisy`
- `DAISY_ADMIN=/home/paulo/projeto_daisy/00_admin`
- `DAISY_SNAPSHOTS=/home/paulo/projeto_daisy/00_admin/Snapshots`
- `DAISY_STATUS=/home/paulo/projeto_daisy/00_admin/Status_Daisy`
- `DAISY_DB=/home/paulo/projeto_daisy/database/daisy.db`

### Entry point operacional
Arquivo presente:
- `~/projeto_daisy/README_AI.md`

Função preservada:
- instruir leitura do snapshot atual antes de qualquer ação
- impor uso obrigatório de `.daisy_paths`
- reduzir dependência de contexto informal de sessão

### Banco de dados

#### SQLite
Arquivo:
- `~/projeto_daisy/database/daisy.db`

Tabelas clínicas existentes:
- `blood_pressure`
- `temperature`
- `stool`
- `stool_images`
- `vulva`
- `vulva_images`
- `weight`
- `diet`
- `medication`
- `thyroid`
- `urine`
- `urine_culture`
- `cardiac_auscultation`
- `chemistry`
- `hematology`
- `patients`

#### Estado validado da tabela `blood_pressure`
A tabela `blood_pressure` foi reavaliada nesta sessão e agora contém explicitamente a coluna:

- `method`

Schema validado por:
- `PRAGMA table_info(blood_pressure)`

Colunas relevantes:
- `collection_date`
- `collection_time`
- `systolic_mmHg`
- `diastolic_mmHg`
- `map_mmHg`
- `heart_rate_bpm`
- `body_position`
- `measurement_site`
- `condition`
- `source`
- `notes`
- `patient_id`
- `method`

#### Registro de migrações
Tabela:
- `schema_migrations`

Estado validado:
- `V001 | 2026-03-12 21:17:27`
- `V002 | 2026-03-17 17:35:39`

#### PostgreSQL
Servidor PostgreSQL ativo.

Database:
- `daisy_pg`

Schema existente:
- `daisy`

Tabelas documentais existentes:
- `documents`
- `chunks`
- `lab_metadata`
- `reference_ranges`

Observação:
- PostgreSQL permanece reservado para camada documental e futura implementação de RAG.

## Estrutura documental e design notes

Design notes existentes:
- `DN-001_multi_patient_architecture.md`
- `DN-002_future_species_compatibility.md`
- `DN-003_google_drive_txt_ingestion.md`
- `DN-004_blood_pressure_method_and_bp_session.md`

Nova nota canônica criada nesta sessão:
- `~/projeto_daisy/00_admin/design_notes/DN-004_blood_pressure_method_and_bp_session.md`

Função de `DN-004`:
- registrar que `method` é campo estrutural
- registrar que `method` não pode ficar apenas em `notes`
- registrar que `blood_pressure` permanece tabela única para `oscillometric` e `doppler`
- registrar que o futuro `bp_session` deve depender explicitamente de `method`

## Estrutura de migrações

Diretório:
- `~/projeto_daisy/migrations/`

Arquivos presentes:
- `V001__baseline.sql`
- `V002__add_method_to_blood_pressure.sql`
- `create_stool_images_table_v1.sql`
- `create_vulva_images_table_v1.sql`
- `create_vulva_table_v1.sql`

Nova migração criada e aplicada nesta sessão:
- `V002__add_method_to_blood_pressure.sql`

Conteúdo funcional:
- `ALTER TABLE blood_pressure ADD COLUMN method TEXT;`

## Motor de ingestão

Arquivo oficial:
- `~/projeto_daisy/ingest.go`

Binário:
- `~/projeto_daisy/daisy_ingest`

Arquitetura modular via parâmetro `-module`.

Módulos oficialmente preservados:
- `temperature`
- `bp_legacy`

Observação importante:
- `bp_session` continua não implementado no arquivo oficial
- nenhuma promoção de novo candidato ocorreu nesta sessão
- a sessão resolveu antes o problema de modelagem do schema

## Trabalho realizado nesta sessão

### 1. Retomada disciplinada do contexto real
Foram inspecionados:
- `README_AI.md`
- `ingest.go`
- schema real da tabela `blood_pressure`
- estado de `schema_migrations`
- diretório `migrations`
- design notes existentes
- arquivos TXT reais de pressão arterial
- export do schema real em `database/daisy_schema_2026-03-13.sql`

Resultado:
- foi confirmado que o estado operacional do projeto continuava íntegro
- foi confirmado que `bp_session` ainda não existe no `ingest.go` oficial
- foi confirmado que a implementação correta do novo módulo exigia primeiro correção de modelagem

### 2. Recuperação do formato real de pressão arterial
Foram inspecionados:
- `data/03_pressao/bp_20260315_201548.txt`
- `data/03_pressao/bp_daisy_test.txt`
- `tmp_bp_session_test.txt`

Ficou confirmado que:
- o sistema convive com um formato legado já existente
- existe um formato novo candidato baseado em bloco `BP_SESSION`
- linhas vazias continuam permitidas e devem ser ignoradas
- a ingestão futura continua orientada a sessão consolidada

### 3. Consolidação da decisão de modelagem sobre `method`
Durante a sessão foi reconhecido que a hipótese anterior de guardar `method` apenas em `notes` era inadequada.

Ficou formalmente consolidado que:

- `blood_pressure` deve ganhar coluna explícita `method`
- `method` não pode ficar em `notes`
- a mesma tabela deve servir para `oscillometric` e `doppler`
- com regras diferentes de população conforme o método

Também foi consolidado que essa decisão deve constar em:
- uma design note própria
- o novo status
- o novo snapshot

### 4. Criação da design note `DN-004`
Foi criada:
- `~/projeto_daisy/00_admin/design_notes/DN-004_blood_pressure_method_and_bp_session.md`

`DN-004` passa a ser a referência canônica da decisão de modelagem para o domínio de pressão arterial.

### 5. Criação e aplicação da migração `V002`
Foi criada:
- `~/projeto_daisy/migrations/V002__add_method_to_blood_pressure.sql`

A migração foi aplicada com sucesso ao SQLite.

Validação executada:
- `PRAGMA table_info(blood_pressure);`

Resultado:
- a coluna `method` passou a existir no schema real

### 6. Registro formal da nova migração
Foi inserido em `schema_migrations`:
- `V002`

Com isso, a trilha de evolução do schema ficou formalmente registrada.

### 7. Revogação do desenho antigo de implementação
Foi explicitamente reconhecido que o candidato antigo de `ingest_v_next.go`, baseado em `method` guardado apenas em `notes`, tornou-se obsoleto e não deve ser usado.

A próxima implementação de `bp_session` deverá nascer já compatível com:
- coluna explícita `method`
- regras distintas para `oscillometric`
- regras distintas para `doppler`

## Decisões formais reafirmadas e novas nesta sessão

### Formato lógico do BP_SESSION
Permanece o entendimento de que o módulo futuro `bp_session` trabalhará com bloco iniciado por `BP_SESSION`, seguido por metadados e leituras da sessão.

### Linhas vazias
Decisão mantida:
- linhas vazias são permitidas
- o parser deve ignorá-las

### Campo `method`
Decisão agora fortalecida e operacionalizada:
- `method` tem que existir
- `method` não pode ser ignorado
- `method` não pode ficar apenas em `notes`
- `method` agora existe como coluna real em `blood_pressure`

### Tabela única para pressão arterial
Decisão consolidada:
- `blood_pressure` permanece tabela única
- essa mesma tabela deve servir para `oscillometric` e `doppler`

### Regras distintas por método
#### `oscillometric`
- `systolic_mmHg` obrigatório
- `diastolic_mmHg` obrigatório
- `map_mmHg` obrigatório

#### `doppler`
- `systolic_mmHg` obrigatório
- `diastolic_mmHg` pode ser `NULL`
- `map_mmHg` pode ser `NULL`

### Consequência para o `bp_session`
O futuro parser:
- deve ler `method`
- deve validar `method`
- deve persistir `method`
- deve aplicar regras diferentes conforme o método
- não pode voltar ao desenho antigo baseado em `method` escondido em `notes`

## Avaliação final da sessão

A sessão não concluiu o módulo `bp_session`.

Mas foi uma sessão correta e necessária porque:
- evitou nova implementação sobre premissa errada
- identificou que `method` era campo estrutural, não mero detalhe livre
- registrou a decisão em documento canônico
- criou e aplicou migração real
- alinhou schema, documentação e próximos passos

## Estado final seguro

Arquivo oficial preservado:
- `~/projeto_daisy/ingest.go`

Módulos oficiais preservados:
- `temperature`
- `bp_legacy`

Sem promoção de `bp_session`.

Novo estado seguro do schema:
- `blood_pressure` agora contém coluna explícita `method`

Nova design note oficial:
- `DN-004_blood_pressure_method_and_bp_session.md`

Nova migração criada e aplicada:
- `V002__add_method_to_blood_pressure.sql`

Registro de migração atualizado:
- `schema_migrations` contém `V001` e `V002`

## Próxima tarefa técnica prioritária

Retomar a implementação do módulo `bp_session`, agora com método rigoroso e já compatível com o schema atualizado.

Sequência obrigatória:
1. inspecionar o estado atual do `ingest.go`
2. formalizar o contrato final de ingestão de `BP_SESSION`
3. definir explicitamente o comportamento para `oscillometric`
4. definir explicitamente o comportamento para `doppler`
5. gerar arquivo novo completo candidato
6. compilar
7. testar com TXT real
8. promover apenas se validado

Observações obrigatórias para a próxima sessão:
- `method` é campo estrutural e obrigatório
- `method` não pode ficar em `notes`
- linhas vazias devem ser ignoradas
- a mesma tabela deve servir para `oscillometric` e `doppler`
- a diferença entre os métodos deve ser preservada pelo parser
- o usuário não edita código manualmente
- é proibido patch parcial
- devem ser usados os paths canônicos via `.daisy_paths`
- o ponto de entrada operacional do projeto continua sendo `README_AI.md`
