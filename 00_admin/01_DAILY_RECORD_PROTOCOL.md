# PROJETO DAISY — DAILY RECORD PROTOCOL (v1.0)
Data: 26/02/2026

Objetivo:
Garantir que nenhum dado clínico relevante da Daisy exista apenas em conversas.
Todo dado relevante deve possuir registro físico no VPS.

------------------------------------------------------------
1) PRINCÍPIO GERAL
------------------------------------------------------------

Dado clínico relevante = deve existir no VPS.

A análise pode ocorrer antes ou depois,
mas o armazenamento oficial é obrigatório.

------------------------------------------------------------
2) CLASSIFICAÇÃO DE DADOS
------------------------------------------------------------

A. DADOS NUMÉRICOS (estruturados)
- Pressão arterial
- Temperatura
- Peso
- Frequência cardíaca

Procedimento:
1. Registrar em arquivo apropriado dentro de /data/
2. Atualizar status se houver marco relevante
3. Depois discutir análise

------------------------------------------------------------
B. DADOS VISUAIS
- Fotos de fezes
- Fotos de vulva
- Fotos clínicas gerais

Procedimento:
1. Foto pode ser analisada imediatamente
2. Depois deve ser enviada ao VPS (99_inbox)
3. Renomear conforme padrão
4. Mover para pasta correta

------------------------------------------------------------
C. DADOS EM ÁUDIO
- Auscultações

Procedimento:
1. Pode ser analisado primeiro
2. Arquivo original deve ser armazenado
3. Nomeação padronizada obrigatória

------------------------------------------------------------
3) REGRA DE OURO
------------------------------------------------------------

Nenhum dado clínico relevante pode existir
exclusivamente na memória da IA.

O VPS é o repositório soberano.

------------------------------------------------------------
4) EXCEÇÃO
------------------------------------------------------------

Observações triviais sem impacto clínico
não exigem registro formal.

------------------------------------------------------------
