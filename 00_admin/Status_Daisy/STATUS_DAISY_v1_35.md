# STATUS_DAISY_v1_35
Data: 2026-03-16

## Estado geral da sessão

Sessão dedicada à retomada do Projeto Daisy com base no contexto restaurado a partir de `SNAPSHOT_PROJETO_DAISY_v2_0_9`.

Houve também consolidação e endurecimento das regras operacionais do projeto, com criação e revisão do bloco constitucional de snapshots.

---

## Estado do sistema

### Infraestrutura
- VPS Hetzner ativo
- Ubuntu 24.04
- acesso SSH estável
- ambiente Go configurado

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

#### PostgreSQL
Servidor PostgreSQL ativo.

Database:
- `daisy_pg`

Schema:
- `daisy`

Tabelas documentais existentes:
- `documents`
- `chunks`
- `lab_metadata`
- `reference_ranges`

Observação:
- PostgreSQL permanece reservado para camada documental e futura implementação de RAG.

---

## Motor de ingestão

Arquivo oficial atual:
- `~/projeto_daisy/ingest.go`

Binário oficial:
- `~/projeto_daisy/daisy_ingest`

Arquitetura:
- modular via parâmetro `-module`

Módulos oficialmente existentes no arquivo atual:
- `temperature`
- `bp_legacy`

Observação importante:
- o texto do flag `module` no `ingest.go` já menciona `bp_session`, mas o módulo **não foi promovido** para a versão oficial, pois a tentativa de implementação falhou e foi descartada.
- portanto, o estado confiável do projeto continua sendo: **`temperature` + `bp_legacy` oficialmente operacionais**.

---

## Trabalho realizado nesta sessão

### 1. Recuperação de contexto
Foi restaurado o contexto de trabalho a partir do snapshot anterior `SNAPSHOT_PROJETO_DAISY_v2_0_9`.

Também foi confirmado que:
- `STATUS_DAISY_v1.35` não foi localizado
- ao final desta sessão o novo status passará a ser `STATUS_DAISY_v1_35`
- ficou decidido corrigir futuramente a nomenclatura legada:
  - `STATUS_DAISY_v1.33` → `STATUS_DAISY_v1_33`
  - `STATUS_DAISY_v1.34` → `STATUS_DAISY_v1_34`

### 2. Fortalecimento das regras constitucionais do projeto
Foi criado e depois revisado o arquivo:

- `~/projeto_daisy/00_admin/DAISY_SNAPSHOT_CONSTITUTION_BLOCK.md`

O bloco agora incorpora explicitamente a regra:

**REPLACE WHOLE FILE — NEVER PATCH IN PLACE**

e estabelece que:
- o usuário não edita código manualmente
- é proibida edição parcial de arquivos existentes
- são permitidas apenas operações como criar arquivo novo, validar, substituir arquivo inteiro, remover temporários e fazer backup

### 3. Tentativa de implementação do módulo `bp_session`
Foi iniciada uma tentativa de implementação do módulo `bp_session`.

Durante a sessão:
- houve inspeção do `ingest.go`
- foi criado um candidato `ingest_v_next.go`
- o candidato foi compilado
- foi gerado binário de teste `ingest_v_next`
- foi criado um TXT de teste no formato `BP_SESSION`

Resultado:
- a ingestão falhou com panic por parser incorreto
- detectou-se que o parser não respeitava o formato real decidido para o `BP_SESSION`
- em tentativa posterior, foi gerado outro arquivo candidato incompleto/indevidamente reduzido
- a promoção foi corretamente bloqueada antes de qualquer substituição do arquivo oficial

### 4. Limpeza de artefatos temporários
Foram removidos os artefatos temporários da tentativa malsucedida, preservando a integridade do projeto.

Removidos:
- `~/projeto_daisy/ingest_v_next.go`
- `~/projeto_daisy/ingest_v_next`
- `~/projeto_daisy/tools/patch_bp_session_case.go`

Estado final:
- `~/projeto_daisy/ingest.go` oficial permaneceu intacto

---

## Decisões formais consolidadas nesta sessão

### Regra operacional crítica
No Projeto Daisy:
- o usuário não edita código manualmente
- o assistente não deve propor edição manual
- o assistente não deve propor patch parcial
- o assistente deve trabalhar por geração de arquivo novo completo, validação e substituição integral apenas ao final

### Formato lógico de `BP_SESSION`
Ficou reafirmado que o formato de entrada para pressão arterial por sessão é baseado em bloco iniciado por `BP_SESSION`, seguido por parâmetros posicionais e depois 7 leituras.

### Linhas vazias
Decisão aceita formalmente:
- linhas vazias são permitidas
- o parser deve ignorá-las

### Campo `method`
Decisão reafirmada como obrigatória:
- o campo `method` **tem que existir**
- ele **não pode ser ignorado**
- há diferença clínica/técnica entre medições `oscillometric` e `doppler`
- portanto, o parser futuro deverá preservar esse campo

---

## Avaliação honesta da sessão

A implementação do `bp_session` **não foi concluída**.

Houve falha de processo na tentativa de implementação, mas a arquitetura disciplinada do projeto funcionou corretamente porque:
- o arquivo oficial não foi substituído
- os candidatos defeituosos ficaram separados
- os artefatos temporários foram removidos
- a integridade do Daisy foi preservada

---

## Estado final seguro

Arquivo oficial preservado:
- `~/projeto_daisy/ingest.go`

Módulos oficiais preservados:
- `temperature`
- `bp_legacy`

Sem promoção de `bp_session`.

---

## Próxima tarefa prioritária

A próxima sessão deve retomar o módulo `bp_session`, porém com método mais rígido:

1. formalizar o contrato de ingestão `BP_SESSION`
2. explicitar definitivamente o mapeamento dos campos para `blood_pressure`
3. gerar **um arquivo novo completo**
4. compilar
5. testar com TXT real
6. só então promover para `ingest.go`

Observação:
- o campo `method` é obrigatório e deve ser preservado
- linhas vazias devem ser ignoradas pelo parser
- nenhuma implementação futura deve ignorar a diferença entre `oscillometric` e `doppler`
END v1_35
