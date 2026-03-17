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

# SNAPSHOT_PROJETO_DAISY_v2_1_0
Data: 2026-03-16

## Observação de integridade deste snapshot

Este snapshot já contém integralmente o bloco constitucional obrigatório.

Entretanto, para ficar 100% conforme a regra de autossuficiência definida pelo próprio projeto, ainda devem ser colados abaixo, a partir de seus arquivos canônicos, os textos integrais de:

- Constitution do Projeto Daisy
- Engineering Charter

Eles não foram recarregados nesta reta final da sessão e, por honestidade técnica, não foram reconstruídos de memória.

## Estado geral do sistema

### Infraestrutura
- VPS Hetzner ativo
- Ubuntu 24.04
- acesso SSH estável
- ambiente Go configurado

### Banco de dados

#### SQLite
Arquivo:
- `database/daisy.db`

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
- PostgreSQL reservado para camada documental e futura implementação de RAG.

## Estrutura operacional de paths do projeto

Nesta sessão foi introduzida uma camada canônica de paths para eliminar erros de localização de arquivos.

Arquivo criado:
- `~/projeto_daisy/.daisy_paths`

Conteúdo funcional:
- `DAISY_ROOT`
- `DAISY_ADMIN`
- `DAISY_SNAPSHOTS`
- `DAISY_STATUS`
- `DAISY_DB`

Carregamento:
- `source ~/projeto_daisy/.daisy_paths`

Persistência:
- a linha acima foi adicionada ao `~/.bashrc`

Validação realizada:
- `echo $DAISY_SNAPSHOTS` retornou corretamente `~/projeto_daisy/00_admin/Snapshots`
- `echo $DAISY_STATUS` retornou corretamente `~/projeto_daisy/00_admin/Status_Daisy`
- `bash -lc 'echo $DAISY_SNAPSHOTS'` confirmou carregamento automático em novo shell

Regra operacional nova:
- comandos futuros devem preferir variáveis canônicas em vez de paths hard-coded

Exemplos:
- snapshots: `$DAISY_SNAPSHOTS`
- status: `$DAISY_STATUS`
- banco: `$DAISY_DB`

## Ponto de entrada operacional para futuras instâncias

Foi decidido que o projeto deve passar a ter um ponto de entrada operacional explícito na raiz:

- `~/projeto_daisy/README_AI.md`

Função desse arquivo:
- servir como entrypoint para qualquer instância futura
- instruir leitura do snapshot atual antes de qualquer ação
- instruir uso obrigatório de `.daisy_paths`
- reduzir dependência de explicações repetidas em sessão

Regra operacional nova:
- qualquer trabalho futuro no Projeto Daisy deve partir de:
  1. leitura do `README_AI.md`
  2. leitura do snapshot mais recente
  3. uso das variáveis de ambiente canônicas

Observação:
- mesmo sem esse arquivo ainda necessariamente estar consolidado em todas as sessões, ele passa a integrar o desenho estrutural oficial do projeto a partir deste snapshot.

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
- houve tentativa de implantação do módulo `bp_session`
- essa tentativa falhou
- o módulo **não foi promovido** para o arquivo oficial
- o `ingest.go` permaneceu íntegro

## Trabalho realizado nesta sessão

### 1. Restabelecimento de contexto
A sessão foi retomada com base em `SNAPSHOT_PROJETO_DAISY_v2_0_9`.

Também foi confirmado que o `STATUS_DAISY_v1.35` não foi localizado.

Decisão:
- gerar nesta sessão `STATUS_DAISY_v1_35`
- corrigir futuramente a nomenclatura legada:
  - `STATUS_DAISY_v1.33` → `STATUS_DAISY_v1_33`
  - `STATUS_DAISY_v1.34` → `STATUS_DAISY_v1_34`

### 2. Endurecimento das regras operacionais
Foi consolidado o bloco constitucional de snapshots em:

- `~/projeto_daisy/00_admin/DAISY_SNAPSHOT_CONSTITUTION_BLOCK.md`

A nova versão agora proíbe explicitamente:
- edição parcial de arquivo existente
- patch manual ou programático
- busca-e-troca interna

E impõe o princípio:

**REPLACE WHOLE FILE — NEVER PATCH IN PLACE**

### 3. Tentativa de implementação de `bp_session`
Foi iniciada implementação do módulo `bp_session`.

Houve:
- inspeção do `ingest.go`
- criação de arquivo candidato `ingest_v_next.go`
- compilação
- geração de binário de teste
- teste com arquivo TXT em formato `BP_SESSION`

Resultado:
- falha de parser com panic
- descoberta de que a implementação não respeitava o formato real decidido para o TXT
- geração posterior de outro arquivo candidato incompleto, também rejeitado
- promoção corretamente bloqueada

### 4. Limpeza de artefatos temporários
Foram removidos os artefatos temporários da tentativa falha.

Removidos:
- `~/projeto_daisy/ingest_v_next.go`
- `~/projeto_daisy/ingest_v_next`
- `~/projeto_daisy/tools/patch_bp_session_case.go`

Estado final:
- `~/projeto_daisy/ingest.go` oficial preservado
- projeto íntegro

### 5. Correção estrutural de paths
Foi detectado durante a sessão que instruções anteriores haviam usado paths inconsistentes para snapshots e status.

A partir desta sessão, o projeto passa a considerar canônicos:

- snapshots em `~/projeto_daisy/00_admin/Snapshots/`
- status em `~/projeto_daisy/00_admin/Status_Daisy/`

E, operacionalmente, devem ser preferidos:

- `$DAISY_SNAPSHOTS`
- `$DAISY_STATUS`

Isso elimina confusão entre:
- `Snapshots` vs `snapshots`
- `Status_Daisy` vs `00_admin`

## Decisões formais reafirmadas nesta sessão

### Formato lógico do BP_SESSION
O módulo futuro `bp_session` deverá trabalhar com bloco iniciado por `BP_SESSION`, seguido por parâmetros posicionais e depois 7 medições.

### Linhas vazias
Decisão aceita:
- linhas vazias são permitidas
- o parser deve ignorá-las

### Campo method
Decisão reafirmada como obrigatória:
- `method` tem que existir
- `method` não pode ser ignorado
- há diferença clínica/técnica entre medição `oscillometric` e `doppler`
- implementações futuras devem preservar este campo

### Variáveis de ambiente canônicas
Decisão nova:
- paths críticos do projeto não devem mais ser tratados como memória informal de sessão
- devem ser centralizados em `.daisy_paths`
- futuras instruções devem preferir variáveis de ambiente a paths hard-coded

### Entry point operacional
Decisão nova:
- o projeto deve usar `README_AI.md` como ponto de entrada operacional para futuras instâncias
- snapshots continuam definindo estado
- `README_AI.md` define como operar o sistema
- `.daisy_paths` define os caminhos canônicos

## Avaliação final da sessão

A tentativa de implementação do `bp_session` **não foi concluída**.

A sessão foi útil para:
- restaurar o contexto
- endurecer o regime constitucional do projeto
- detectar falha de processo antes de dano estrutural
- preservar integralmente a base oficial do Daisy
- eliminar estruturalmente erros de path
- introduzir uma camada operacional canônica para futuras sessões

## Próxima tarefa técnica prioritária

Retomar a implementação do módulo `bp_session`, desta vez com método rigoroso:

1. formalizar o contrato de ingestão `BP_SESSION`
2. definir explicitamente o mapeamento dos campos para `blood_pressure`
3. gerar arquivo novo completo
4. compilar
5. testar com TXT real
6. promover apenas se validado

Observações obrigatórias para a próxima sessão:
- `method` é obrigatório e deve ser preservado
- linhas vazias devem ser ignoradas
- nenhuma implementação futura deve ignorar a diferença entre `oscillometric` e `doppler`
- o usuário não edita código manualmente
- é proibido patch parcial
- devem ser usados os paths canônicos via `.daisy_paths`
- o ponto de entrada operacional do projeto é `README_AI.md`
