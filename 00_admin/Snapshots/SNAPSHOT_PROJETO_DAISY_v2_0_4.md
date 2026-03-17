## SNAPSHOT_PROJETO_DAISY_v2_0_4

Data: 2026-03-14
Servidor: Hetzner VPS
DB: SQLite
DB path: ~/projeto_daisy/database/daisy.db

==================================================
EVENTO PRINCIPAL
==================================================

Primeira ingestão estruturada de eventos clínicos de fezes
no banco de dados do Projeto Daisy.

==================================================
PIPELINE EXECUTADO
==================================================

Fonte de dados:

~/projeto_daisy/media/stool/2026/stool_images_decimal.csv

Script executado:

~/projeto_daisy/tools/ingest_stool_images.py

Algoritmo de agrupamento:

agrupamento temporal com janela máxima de 10 minutos.

Imagens dentro dessa janela pertencem ao mesmo evento stool.

==================================================
RESULTADO DA INGESTÃO
==================================================

Eventos clínicos criados:

25

--------------------------------------------------

Imagens registradas:

31

--------------------------------------------------

Estrutura final:

stool (evento clínico)

↳ stool_images (imagens associadas)

==================================================
ESTADO DO BANCO
==================================================

SELECT COUNT(*) FROM stool;

resultado:

25

--------------------------------------------------

SELECT COUNT(*) FROM stool_images;

resultado:

31

==================================================
ESTRUTURA CLÍNICA
==================================================

Campos interpretativos permanecem NULL nesta fase.

Campos:

bristol_score
consistency
color
mucus_present
blood_present

Esses dados serão preenchidos futuramente
por análise automatizada via API da OpenAI.

==================================================
SIGNIFICADO ARQUITETURAL
==================================================

O Projeto Daisy passa a possuir registro clínico estruturado
de eventos de evacuação.

Cada evento possui:

timestamp clínico
paciente
imagens associadas

Isso estabelece a base para:

monitoramento longitudinal intestinal
análise visual automatizada
detecção precoce de alterações clínicas.

==================================================
PONTO DE RETOMADA
==================================================

Próxima etapa provável:

integração do pipeline de análise com a API da OpenAI
para extração automática de características clínicas
das imagens de stool.

==================================================
END OF SNAPSHOT v2.0.4
==================================================
