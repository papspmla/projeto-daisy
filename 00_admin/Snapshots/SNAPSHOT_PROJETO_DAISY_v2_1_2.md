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

# SNAPSHOT_PROJETO_DAISY_v2_1_2
Data: 2026-03-17

## Observação de integridade deste snapshot

Este snapshot contém integralmente o bloco constitucional obrigatório.

Entretanto, por honestidade técnica, continua valendo a mesma observação dos snapshots anteriores: para ficar 100% conforme a regra de autossuficiência definida pelo próprio projeto, ainda devem ser colados abaixo, a partir de seus arquivos canônicos, os textos integrais de:

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
A tabela `blood_pressure` permanece contendo explicitamente a coluna:

- `method`

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

Observação:
- `DN-004` permanece referência canônica para:
  - `method` como campo estrutural
  - tabela única `blood_pressure`
  - suporte simultâneo a `oscillometric` e `doppler`
  - dependência explícita de `method` no futuro e agora no módulo oficial `bp_session`

## Estrutura de migrações

Diretório:
- `~/projeto_daisy/migrations/`

Arquivos presentes:
- `V001__baseline.sql`
- `V002__add_method_to_blood_pressure.sql`
- `create_stool_images_table_v1.sql`
- `create_vulva_images_table_v1.sql`
- `create_vulva_table_v1.sql`

Observação:
- nesta sessão não houve nova migração de schema
- a mudança foi de comportamento do motor de ingestão

## Motor de ingestão

Arquivo oficial:
- `~/projeto_daisy/ingest.go`

Binário oficial:
- `~/projeto_daisy/daisy_ingest`

Arquitetura modular via parâmetro `-module`.

Módulos oficialmente ativos:
- `temperature`
- `bp_legacy`
- `bp_session`

## Trabalho realizado nesta sessão

### 1. Retomada a partir do estado pós-promoção de `bp_session`
Foi reinspecionado o `ingest.go` oficial.

Resultado:
- `bp_session` já estava oficialmente presente
- a pendência remanescente foi corretamente identificada como ausência de política clínica explícita de arredondamento

### 2. Identificação da divergência entre média matemática e persistência clínica
Foi observado que a sessão consolidada de pressão arterial estava sendo persistida com médias matemáticas cruas, por exemplo:

- sistólica `123.142857142857`
- diastólica `81.2857142857143`
- MAP `91.8571428571429`

Isso foi avaliado como:
- computacionalmente correto
- clinicamente incompleto

### 3. Geração de novo arquivo completo candidato
Sem editar o arquivo oficial, foi criado novo arquivo completo:

- `~/projeto_daisy/ingest_bp_session_rounding_candidate.go`

O candidato preservou todo o comportamento anterior e acrescentou:
- import de `math`
- função de arredondamento
- política clínica explícita aplicada às médias de `BP_SESSION`

### 4. Regra implementada
Foi formalmente implementado no candidato:

- média em `float64`
- arredondamento com `math.Round()`
- persistência do valor arredondado

Aplicação:
- `systolic`
- `diastolic`, quando existir
- `MAP`, quando existir

### 5. Compilação isolada do candidato
Foi compilado com sucesso o binário de teste:

- `~/projeto_daisy/daisy_ingest_bp_session_rounding`

### 6. Correção metodológica do teste
Foi corretamente reconhecido que consultar o row já existente de `2026-03-14 12:40` não validava a nova política, porque o sistema opera com `INSERT OR IGNORE`.

Decisão correta:
- criar novo arquivo de teste completo, sem editar o anterior

Arquivo criado:
- `~/projeto_daisy/tmp_bp_session_test_rounding.txt`

Horário de teste:
- `12:41`

### 7. Validação objetiva da nova persistência
O binário candidato foi executado no novo arquivo de teste.

Resultado:
- `bp_session records inserted: 1`

A consulta ao banco para `2026-03-14 12:41` confirmou:

- `systolic_mmHg = 123.0`
- `diastolic_mmHg = 81.0`
- `map_mmHg = 92.0`

Conclusão:
- o arredondamento foi aplicado corretamente no ponto de persistência

### 8. Promoção oficial por substituição integral
Foi obedecida a regra do projeto:

- backup prévio
- substituição integral
- nenhuma edição parcial

Backup criado:
- `~/projeto_daisy/ingest.go.bak_2026-03-17_bp_session_rounding_promotion`

Substituição realizada:
- `ingest.go` passou a refletir oficialmente a política clínica de arredondamento

### 9. Recompilação do binário oficial
O binário oficial foi recompilado com sucesso:

- `~/projeto_daisy/daisy_ingest`

### 10. Estado final consolidado
O motor oficial de ingestão agora suporta formalmente:

- `temperature`
- `bp_legacy`
- `bp_session`

E, no caso de `bp_session`, com:
- leitura de bloco `BP_SESSION`
- ignorar linhas vazias
- `method` explícito e persistido
- regras distintas por método
- registro consolidado por sessão
- arredondamento clínico das médias antes da persistência

## Decisões formais reafirmadas e novas nesta sessão

### `method`
Mantida a decisão:
- `method` é campo estrutural
- `method` não pode ficar em `notes`

### `bp_session`
Mantida a decisão:
- um bloco `BP_SESSION` gera um único registro consolidado na tabela `blood_pressure`

### Linhas vazias
Mantida a decisão:
- linhas vazias são permitidas
- o parser deve ignorá-las

### Regra clínica nova e agora oficial
Passa a valer oficialmente no Projeto Daisy:

- as médias de pressão arterial agregadas em `bp_session` devem ser persistidas arredondadas ao inteiro mais próximo

### Escopo da regra
A política aplica-se a:
- `systolic_mmHg`
- `diastolic_mmHg`, quando existir
- `map_mmHg`, quando existir

### Natureza da regra
A decisão é:
- clínica
- de domínio
- de persistência

Não é mera regra de exibição.

## Avaliação final da sessão

A sessão foi correta, necessária e concluída.

Ela resolveu uma pendência sutil, mas importante:
- o módulo `bp_session` já existia
- mas ainda não estava clinicamente finalizado

Após esta sessão, o `bp_session` oficial ficou:
- estruturalmente correto
- funcionalmente correto
- clinicamente correto quanto à forma de persistência das médias

## Estado final seguro

Arquivo oficial:
- `~/projeto_daisy/ingest.go`

Binário oficial:
- `~/projeto_daisy/daisy_ingest`

Backups de promoção existentes:
- `~/projeto_daisy/ingest.go.bak_2026-03-17_bp_session_promotion`
- `~/projeto_daisy/ingest.go.bak_2026-03-17_bp_session_rounding_promotion`

Arquivos auxiliares gerados durante a sessão:
- `~/projeto_daisy/ingest_bp_session_rounding_candidate.go`
- `~/projeto_daisy/tmp_bp_session_test_rounding.txt`

Comportamento oficial de `bp_session`:
- lê `BP_SESSION`
- valida data, hora e `method`
- aceita `oscillometric` e `doppler`
- ignora linhas vazias
- calcula médias
- arredonda clinicamente
- persiste um único registro consolidado

## Próxima tarefa técnica prioritária

A próxima sessão deve sair do núcleo imediato de implementação do `bp_session` e avançar para consolidação documental e padronização do módulo promovido.

Sequência prioritária:
1. registrar formalmente a política de arredondamento em design note própria ou complemento canônico
2. documentar o contrato final do formato `BP_SESSION`
3. revisar se `bp_legacy` deve manter comportamento atual ou receber política explícita futura
4. decidir se haverá conjunto oficial de arquivos TXT de teste para regressão por módulo
5. retomar a trilha principal do motor único de ingestão em Go

Observações obrigatórias para a próxima sessão:
- `method` continua estrutural e obrigatório
- o usuário não edita código manualmente
- não são permitidos patches parciais
- `bp_session` agora já está oficialmente promovido e clinicamente arredondado
- toda modificação futura deve continuar por replace integral com backup
