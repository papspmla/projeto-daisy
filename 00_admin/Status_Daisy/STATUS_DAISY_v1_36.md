# STATUS_DAISY_v1_36
Data: 2026-03-17

## Estado geral da sessão

Sessão de retomada do Projeto Daisy a partir de:

- `STATUS_DAISY_v1_35`
- `SNAPSHOT_PROJETO_DAISY_v2_1_0`

O foco da sessão foi continuar a preparação rigorosa do módulo `bp_session`, agora com correção de modelagem no domínio de pressão arterial.

A sessão não avançou ainda para implementação nova em Go do `bp_session`, mas resolveu corretamente uma questão estrutural crítica de schema antes de qualquer nova tentativa de ingestão.

---

## Estado do sistema

### Infraestrutura
- VPS Hetzner ativo
- Ubuntu 24.04
- acesso SSH estável
- ambiente Go configurado

### Paths canônicos
Variáveis carregadas e validadas:
- `DAISY_ROOT=/home/paulo/projeto_daisy`
- `DAISY_ADMIN=/home/paulo/projeto_daisy/00_admin`
- `DAISY_SNAPSHOTS=/home/paulo/projeto_daisy/00_admin/Snapshots`
- `DAISY_STATUS=/home/paulo/projeto_daisy/00_admin/Status_Daisy`
- `DAISY_DB=/home/paulo/projeto_daisy/database/daisy.db`

### Entry point operacional
Arquivo presente e validado:
- `~/projeto_daisy/README_AI.md`

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

### Estado atual da tabela `blood_pressure`
Schema validado ao vivo por `PRAGMA table_info(blood_pressure)`.

A tabela agora contém:
- `id`
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

### Registro de migrações
Tabela `schema_migrations` validada.

Versões registradas:
- `V001`
- `V002`

`V002` registrado em:
- `2026-03-17 17:35:39`

### PostgreSQL
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

Módulos oficialmente operacionais no arquivo atual:
- `temperature`
- `bp_legacy`

Estado do `bp_session`:
- ainda não implementado/promovido no arquivo oficial
- nenhuma nova tentativa de promoção foi feita nesta sessão
- a implementação foi corretamente adiada até resolução do problema de modelagem de `method`

---

## Trabalho realizado nesta sessão

### 1. Retomada disciplinada a partir do snapshot anterior
Foi retomado o trabalho com leitura e validação de:
- `README_AI.md`
- `ingest.go`
- schema real de `blood_pressure`
- arquivos TXT reais de pressão arterial
- design notes existentes
- diretório `migrations`
- schema SQL real exportado do banco

Resultado:
- o estado descrito no snapshot anterior foi confirmado como essencialmente correto
- foi verificado que `bp_session` ainda não existe no `ingest.go` oficial
- foi confirmado que o parser futuro não pode ser desenhado corretamente sem revisão do schema de pressão arterial

### 2. Recuperação do contrato real de entrada de pressão arterial
Foram inspecionados:
- `data/03_pressao/bp_20260315_201548.txt`
- `data/03_pressao/bp_daisy_test.txt`
- `tmp_bp_session_test.txt`

Foi confirmado que:
- existe formato legado de pressão já em uso
- existe um formato novo candidato baseado em bloco `BP_SESSION`
- linhas vazias precisam continuar sendo ignoradas
- o novo módulo deve continuar trabalhando por sessão consolidada

### 3. Reavaliação correta do campo `method`
Durante a sessão foi reconhecido que a hipótese anterior de guardar `method` em `notes` era insuficiente.

Foi formalmente consolidado que:
- `blood_pressure` deve ganhar coluna explícita `method`
- `method` não pode ficar em `notes`
- a mesma tabela deve servir para `oscillometric` e `doppler`
- com regras diferentes de população conforme o método

Também ficou consolidado que essa decisão deve entrar em:
- uma design note própria
- o novo status
- o novo snapshot

### 4. Criação da design note canônica
Foi criada a design note:

- `~/projeto_daisy/00_admin/design_notes/DN-004_blood_pressure_method_and_bp_session.md`

Conteúdo central registrado:
- `method` é campo estrutural
- `method` deve existir explicitamente no schema
- `blood_pressure` permanece tabela única para `oscillometric` e `doppler`
- `oscillometric` exige sistólica, diastólica e MAP
- `doppler` exige sistólica e admite `NULL` em diastólica e MAP
- `bp_session` deverá aplicar regras distintas conforme o método

### 5. Criação e aplicação da migração V002
Foi criada a migração:

- `~/projeto_daisy/migrations/V002__add_method_to_blood_pressure.sql`

Conteúdo:
- `ALTER TABLE blood_pressure ADD COLUMN method TEXT;`

A migração foi aplicada com sucesso ao banco SQLite.

Validação:
- `PRAGMA table_info(blood_pressure);`
- confirmou presença da nova coluna `method`

### 6. Registro da migração aplicada
Foi inserido em `schema_migrations`:

- `V002 | 2026-03-17 17:35:39`

Resultado:
- schema e trilha formal de migração ficaram coerentes

### 7. Revogação prática do candidato antigo de `ingest_v_next.go`
Foi explicitamente reconhecido que o comando anteriormente proposto para gerar um candidato de `ingest_v_next.go` ficou obsoleto, porque estava baseado na hipótese incorreta de guardar `method` apenas em `notes`.

Decisão:
- esse candidato não deve ser executado
- a próxima implementação de `bp_session` deverá nascer já compatível com a coluna explícita `method`

---

## Decisões formais consolidadas nesta sessão

### Modelagem de pressão arterial
No Projeto Daisy:
- `blood_pressure` deve possuir coluna explícita `method`
- `method` não pode ficar apenas em `notes`
- `blood_pressure` permanece tabela única para os dois métodos
- o método altera a semântica de ingestão e a interpretação futura

### Regras por método
#### Oscillometric
- `systolic_mmHg` obrigatório
- `diastolic_mmHg` obrigatório
- `map_mmHg` obrigatório

#### Doppler
- `systolic_mmHg` obrigatório
- `diastolic_mmHg` permitido como `NULL`
- `map_mmHg` permitido como `NULL`

### Consequência para o módulo `bp_session`
O futuro parser de `bp_session`:
- deve ler `method`
- deve validar `method`
- deve persistir `method` em coluna própria
- deve aplicar regras distintas para `oscillometric` e `doppler`
- deve continuar ignorando linhas vazias
- deve continuar gravando uma sessão consolidada em um único registro

### Regra documental de propagação
A decisão acima passa a integrar obrigatoriamente:
- `DN-004`
- `STATUS_DAISY_v1_36`
- `SNAPSHOT_PROJETO_DAISY_v2_1_1`

---

## Avaliação honesta da sessão

A sessão não concluiu o módulo `bp_session`.

Mas a sessão foi tecnicamente correta e necessária porque:
- evitou codificação prematura sobre schema inadequado
- corrigiu a modelagem do domínio de pressão arterial
- registrou a decisão em design note própria
- criou e aplicou migração real
- manteve a disciplina de engenharia do projeto

Em termos tradicionais de engenharia, foi uma sessão de saneamento estrutural e não de feature completion.

---

## Estado final seguro

Arquivo oficial preservado:
- `~/projeto_daisy/ingest.go`

Módulos oficiais preservados:
- `temperature`
- `bp_legacy`

Novo estado seguro do banco:
- tabela `blood_pressure` agora contém coluna `method`

Novo documento canônico criado:
- `DN-004_blood_pressure_method_and_bp_session.md`

Nova migração criada e aplicada:
- `V002__add_method_to_blood_pressure.sql`

Registro de migração atualizado:
- `schema_migrations` contém `V001` e `V002`

Sem promoção de novo `bp_session` nesta sessão.

---

## Próxima tarefa prioritária

A próxima sessão deve retomar o módulo `bp_session`, agora já compatível com o schema correto.

Sequência obrigatória:
1. inspecionar o estado atual do `ingest.go`
2. definir formalmente o contrato de ingestão de `BP_SESSION`
3. explicitar o comportamento para `oscillometric`
4. explicitar o comportamento para `doppler`
5. gerar um arquivo novo completo candidato
6. compilar
7. testar com TXT real de sessão
8. só então promover para `ingest.go`

Observações obrigatórias para a próxima sessão:
- `method` é coluna estrutural e obrigatória
- `method` não pode ficar em `notes`
- linhas vazias devem ser ignoradas
- `oscillometric` e `doppler` usam a mesma tabela, mas com regras distintas
- nenhuma implementação futura deve voltar ao desenho antigo baseado em `method` oculto
END v1_36
