# =========================================================
# DESIGN NOTE DN-002
# Compatibilidade futura multi-espécie
# =========================================================

Contexto

O Projeto Daisy é atualmente um sistema clínico
canino-first, desenvolvido para monitorização
clínica longitudinal da paciente Daisy.

No entanto, a arquitetura deve permanecer
compatível com futura expansão para outras
espécies, incluindo felinos.

Esta nota estabelece regras mínimas para
preservar essa compatibilidade sem ampliar
o escopo atual do projeto.

------------------------------------------------------------

Princípios

1. O sistema permanece canino-first.

2. A expansão para outras espécies não faz
parte do escopo atual.

3. A arquitetura deve, entretanto,
evitar dependências rígidas de espécie.

------------------------------------------------------------

Regras arquitetônicas

1. A espécie do paciente é armazenada em:

patients.species

2. Motores clínicos devem operar sempre
a partir de:

patient_id

e resolver a espécie do paciente
antes de executar interpretações.

3. Intervalos de referência laboratoriais
devem sempre suportar:

- analyte
- species
- laboratory
- unidade

4. Nenhum componente do sistema deve assumir
implicitamente que todos os pacientes são cães.

------------------------------------------------------------

Escopo atual

Interpretação clínica permanece:

CANINO FIRST

Motores clínicos atuais podem aplicar
lógica canina.

No futuro, bifurcação por espécie poderá
ser introduzida.

------------------------------------------------------------

Conclusão

O Projeto Daisy mantém:

arquitetura compatível com múltiplas espécies

sem expandir o escopo clínico atual.
