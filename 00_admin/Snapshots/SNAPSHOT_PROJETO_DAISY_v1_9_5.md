SNAPSHOT_PROJETO_DAISY_v1_9_5

Data: 2026-03-09

Objetivo: restaurar o estado operacional do Projeto Daisy após a sessão de migração estrutural multi-paciente e expansão do modelo clínico.

1. Estado Arquitetural do Sistema

Base de dados principal: SQLite (daisy.db)
Base analítica complementar: PostgreSQL (daisy_pg)
Diretório raiz: ~/projeto_daisy
Ferramentas: ~/projeto_daisy/tools
Logs: ~/projeto_daisy/logs
Admin: ~/projeto_daisy/00_admin

2. Entidade Central

Tabela patients introduzida como raiz lógica do sistema.

Campos principais:
patient_id (PK)
name
species
breed
sex
date_of_birth
notes
created_at

Paciente principal:
patient_id = 1
name = Daisy
species = Canis lupus familiaris

3. Tabelas Clínicas Existentes

Laboratório:
- chemistry
- thyroid
- urine
- hematology
- endocrine

Monitorização fisiológica:
- blood_pressure
- temperature
- weight

Eventos biológicos:
- stool
- estrous_cycle

Intervenções clínicas:
- medication
- diet

Exame clínico:
- cardiac_auscultation

4. Novas Tabelas Criadas nesta Sessão

stool
medication
diet
cardiac_auscultation

5. Regras Estruturais Atuais

1 sistema
N pacientes possíveis
Paciente principal: Daisy (patient_id = 1)

Todas as tabelas clínicas possuem:
patient_id

6. Compatibilidade Multi-Espécie (Preparação Futura) – REGRA FIXA ATÉ A EXECUÇÃO.

O sistema permanece canino-first.
A arquitetura foi preparada para suportar espécies adicionais no futuro.

Princípios:
- species armazenada em patients
- motores clínicos devem resolver patient_id antes de interpretar dados
- referência clínica futura poderá depender de species

7. Próxima Tarefa Recomendada

Implementar metabolic_interpreter.go

Objetivo:
gerar interpretação clínica automática consolidada a partir de:

- tendências laboratoriais
- fases clínicas detectadas
- ranges laboratoriais
- eventos clínicos registrados

8. REGRAS COMPORTAMENTAIS FIXAS IMUTÁVEIS PARA O CHATGPT:

Estas regras devem OBRIGATORIAMENTE ser copiadas para o novo snapshot ao final de cada sessão.

Um único comando por vez, precedido por uma muito resumida explicação da finalidade.
Aguarde pela minha resposta.
E só então prossiga para o próximo comando. Não teça qualquer comentário até receber minha resposta.

E as regras seguintes são a constituição da interação usuário-chatgpt durante este projeto, e também devem ser literalmente copiadas para o próximo snapshot no final da sessão:

============================================================

PROJETO DAISY — REGRAS FIXAS DE INTERAÇÃO E GOVERNANÇA

============================================================

1) DIREÇÃO DO PROJETO

A direção estratégica, prioridades, sequência de trabalho e visão
global do Projeto Daisy pertencem exclusivamente ao tutor.

O assistente não deve propor mudança de rumo, redefinir escopo
ou induzir redirecionamento do projeto.

2) SUGESTÕES PERMITIDAS

O assistente está autorizado a sugerir apenas:

- novas funcionalidades;
- melhorias operacionais;
- melhorias analíticas.

Essas sugestões devem ser apresentadas apenas como opções,
sem caráter impositivo e sem interferir na linha principal
de desenvolvimento definida pelo tutor.

3) ARQUITETURA DO SISTEMA

O assistente não deve fazer sugestões arquitetônicas.

Exceção única:

o assistente poderá alertar e sugerir ajuste arquitetônico
somente em caso de risco real de dano estrutural,
isto é, quando houver possibilidade concreta de:

- comprometer integridade de dados;
- quebrar o modelo;
- gerar retrabalho estrutural relevante;
- criar bloqueio técnico grave para continuidade do sistema.

4) STATUS OFICIAL DO SISTEMA

Todo snapshot mais recente enviado pelo tutor deve ser tratado
como o estado oficial do Projeto Daisy.

O assistente deve partir desse snapshot como fonte de verdade
para análise, continuidade, revisão documental e apoio técnico.
