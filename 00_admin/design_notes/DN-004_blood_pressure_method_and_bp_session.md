# DN-004 — Blood Pressure Method and BP_SESSION

Data: 17/03/2026

Contexto

Durante a retomada do módulo `bp_session`, ficou claro que
o campo `method` não é simples metadado descritivo.

No Projeto Daisy, `method` pode assumir, no mínimo, duas
modalidades clinicamente e tecnicamente distintas:

- `oscillometric`
- `doppler`

Essas modalidades não possuem o mesmo comportamento de ingestão.

------------------------------------------------------------

Problema identificado

A hipótese inicial de registrar `method` apenas em `notes`
foi considerada insuficiente.

Motivo:

1. `method` altera a validação do TXT
2. `method` altera as regras de preenchimento da tabela
3. `method` altera a interpretação futura dos dados

Portanto, `method` não pode permanecer oculto em campo livre.

------------------------------------------------------------

Decisão arquitetural

A tabela `blood_pressure` permanecerá única para os dois métodos,
mas deverá receber uma coluna explícita:

`method TEXT`

Essa coluna passa a fazer parte do modelo clínico oficial
de pressão arterial do Projeto Daisy.

------------------------------------------------------------

Regra de população por método

1. `oscillometric`
   - `systolic_mmHg` obrigatório
   - `diastolic_mmHg` obrigatório
   - `map_mmHg` obrigatório

2. `doppler`
   - `systolic_mmHg` obrigatório
   - `diastolic_mmHg` permitido como `NULL`
   - `map_mmHg` permitido como `NULL`

------------------------------------------------------------

Implicação para BP_SESSION

O módulo `bp_session` deve ser implementado com
comportamento dependente de `method`.

Logo:

- `method` deve ser lido do TXT
- `method` deve ser validado
- `method` deve ser persistido em coluna própria
- o parser deve aplicar regras diferentes para
  `oscillometric` e `doppler`

------------------------------------------------------------

Princípio de modelagem

`notes` continua sendo campo de contexto livre.

Campos que alteram semântica estrutural de ingestão
não devem ser armazenados apenas em `notes`.

------------------------------------------------------------

Próximos passos decorrentes

1. criar migração para adicionar `method` à tabela `blood_pressure`
2. atualizar o schema canônico refletindo essa mudança
3. implementar `bp_session` no motor de ingestão
4. testar ingestão de sessão `oscillometric`
5. posteriormente testar ingestão de sessão `doppler`

------------------------------------------------------------

Conclusão

No Projeto Daisy, `method` é campo estrutural e obrigatório
do domínio de pressão arterial.

Ele deve existir explicitamente no schema e participar
ativamente da ingestão.
