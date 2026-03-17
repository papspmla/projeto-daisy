SNAPSHOT_PROJETO_DAISY_v1_8_7

Data de geração: 03/03/2026

Objetivo:
Restaurar exatamente o contexto operacional ao final da validação do Chemistry Engine v1.0 no Postgres.

Passar apenas 1 comando por vez e aguardar a resposta.
Antes de passar um comando, explicar resumidamente qual o objetivo.

1. Infraestrutura

VPS: Hetzner Cloud (nbg1)
OS: Ubuntu 24.04 LTS
PostgreSQL: v16 instalado e operacional
Banco ativo: daisy_pg
Usuário: daisy (autenticação via ~/.pgpass)
Schema padrão: daisy

2. Estrutura Postgres

Schema ativo: daisy

Tabelas existentes:
- documents
- chunks

3. Chemistry Engine v1.0

Script oficial:
~/projeto_daisy/tools/generate_chem_chunks.sh

Características técnicas consolidadas:
- Idempotente (DELETE + INSERT)
- Determinístico (menor document_id por collection_date)
- Sem DO blocks
- Sem delimitadores $$ conflitantes
- Uso de psql -v para quoting seguro
- SQLite permanece Source of Truth absoluto

4. Caso Validado

Exame:
06 - IDEXX_SangueCompleto_04_07_2024_TiroideSusp.pdf

collection_date:
2024-07-05

Execução validada:
BEGIN
DELETE 8
INSERT 0 8
COMMIT

OK: chunks chemistry v1.0 gerados para 2024-07-05 (document_id=1)

5. Estado Congelado

Postgres operacional.
Chunking estruturado validado.
Arquitetura híbrida consolidada.
Ponto seguro para continuação da Fase 3.

6. Próxima Tarefa ao Retornar

Backfill completo de chemistry no Postgres.

Passos planejados:
1. Listar todas as collection_date da tabela chemistry no SQLite.
2. Garantir correspondência na tabela documents.
3. Executar generate_chem_chunks.sh para todas as datas.
4. Validar contagem total de chunks.
5. Declarar Chemistry Migration Complete.

7. Ponto Exato de Retorno

Sistema estável após validação do Chemistry Engine v1.0.
Última ação realizada: execução bem-sucedida para 2024-07-05.
Próximo movimento: iniciar backfill completo.
