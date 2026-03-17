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
- criar backup antes de substituição

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
