cat << 'EOF' > ~/projeto_daisy/00_admin/design_notes/DN-001_multi_patient_architecture.md
# =========================================================
# PROJETO DAISY — DESIGN NOTE
# DN-001
# Multi-Patient Architecture
# =========================================================

Date: 2026-03-09

------------------------------------------------------------
1. CONTEXTO
------------------------------------------------------------

O Projeto Daisy foi inicialmente concebido como um sistema
clínico para um único paciente (Daisy).

Com a evolução do sistema e a intenção de utilizar o projeto
para validação clínica externa, torna-se desejável permitir
suporte a múltiplos pacientes caninos.

Exemplo futuro:

    Daisy
    Paciente 2
    Paciente 3

Objetivos da arquitetura multi-paciente:

- permitir testes com outros casos clínicos
- validar os motores de interpretação automática
- possibilitar uso acadêmico ou compartilhamento futuro
- preservar isolamento clínico absoluto entre pacientes

------------------------------------------------------------
2. PRINCÍPIO ARQUITETURAL
------------------------------------------------------------

Transformar o sistema de:

    1 paciente

para:

    N pacientes possíveis

Mantendo Daisy como paciente principal.

------------------------------------------------------------
3. ENTIDADE CENTRAL
------------------------------------------------------------

Será introduzida a tabela:

    patients

Estrutura recomendada:

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    species TEXT,
    breed TEXT,
    sex TEXT,
    date_of_birth DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
4. REGRA FUNDAMENTAL
------------------------------------------------------------

Todas as tabelas clínicas passam a possuir:

    patient_id INTEGER NOT NULL

referenciando:

    patients(patient_id)

Exemplo:

CREATE TABLE chemistry (
    id INTEGER PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    collection_date DATE NOT NULL,
    analyte TEXT,
    value REAL,
    unit TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

Quando necessário, unicidade clínica será definida por:

    UNIQUE(patient_id, collection_date)

------------------------------------------------------------
5. REGRA DE ISOLAMENTO CLÍNICO
------------------------------------------------------------

Toda consulta clínica deve operar dentro do escopo
de um paciente específico.

Exemplo:

SELECT *
FROM chemistry
WHERE patient_id = ?

Isso evita qualquer mistura de dados entre pacientes.

------------------------------------------------------------
6. COMPORTAMENTO DEFAULT
------------------------------------------------------------

Durante a fase inicial do projeto:

    Daisy = patient_id = 1

Se nenhum paciente for explicitamente informado
em scripts ou motores clínicos, o sistema assume
automaticamente:

    patient_id = 1

Esta regra oferece:

- conforto operacional
- compatibilidade com scripts atuais

Mas o comportamento permanece explicitamente
documentado para possível alteração futura.

------------------------------------------------------------
7. IMPACTO NO SISTEMA
------------------------------------------------------------

Componentes que permanecem conceitualmente iguais:

- SQLite como fonte clínica estruturada
- PostgreSQL como camada documental / semântica
- motores clínicos em Go
- pipeline de ingestão
- dashboards clínicos

A mudança estrutural consiste em:

- introduzir patient_id nas tabelas clínicas
- escopar consultas por paciente
- associar documents e chunks ao paciente correto

------------------------------------------------------------
8. ORGANIZAÇÃO FUTURA DE ARQUIVOS
------------------------------------------------------------

Arquivos clínicos poderão ser organizados por paciente.

Estrutura preferida:

patients/

    0001_daisy/
        labs/
        urinalysis/
        imaging/
        documents/

    0002_patient2/
        labs/
        imaging/

Esta separação:

- reduz risco de mistura de arquivos
- facilita backups
- simplifica RAG futuro

------------------------------------------------------------
9. ORDEM DE IMPLEMENTAÇÃO
------------------------------------------------------------

Sequência recomendada:

1) concluir ingestão clínica atual da Daisy
2) criar tabela patients
3) inserir Daisy como patient_id = 1
4) adicionar patient_id às tabelas clínicas
5) atualizar registros existentes
6) adaptar motores clínicos
7) adaptar scripts de ingestão
8) iniciar testes com paciente 2

------------------------------------------------------------
10. PRINCÍPIO DE COMPATIBILIDADE
------------------------------------------------------------

A arquitetura multi-paciente deve ser implementada
sem quebrar o funcionamento atual do sistema.

Daisy permanece o paciente padrão.

------------------------------------------------------------
END OF DESIGN NOTE DN-001
------------------------------------------------------------
EOF
