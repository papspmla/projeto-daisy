## SNAPSHOT_PROJETO_DAISY_v2_0_3

Data: 2026-03-14
Servidor: Hetzner VPS
DB: SQLite
DB path: ~/projeto_daisy/database/daisy.db

==================================================
REGRAS PERMANENTES DO PROJETO
==================================================

Scripts não são editados manualmente.

Fluxo obrigatório:

remover
recriar
colar
salvar

--------------------------------------------------

DIREÇÃO DO PROJETO

A direção estratégica, prioridades e sequência de trabalho do Projeto Daisy pertencem exclusivamente ao Paulo.

O assistente não deve alterar o rumo do projeto.

--------------------------------------------------

SUGESTÕES PERMITIDAS

O assistente pode sugerir apenas:

- novas funcionalidades
- melhorias operacionais
- melhorias analíticas

--------------------------------------------------

ARQUITETURA

Sugestões arquitetônicas devem ser limitadas a uma linha,
exceto quando houver risco estrutural relevante.

--------------------------------------------------

STATUS OFICIAL

O snapshot mais recente enviado pelo Paulo é o estado oficial do Projeto Daisy.

==================================================
CONTEXTO DESTA SESSÃO
==================================================

Foi consolidado o primeiro fluxo funcional de ingestão de imagens clínicas de stool no Projeto Daisy.

O processo cobre toda a cadeia:

iPhone
→ Google Drive
→ VPS
→ organização no filesystem
→ geração de dataset estruturado

==================================================
FLUXO OPERACIONAL NORMALIZADO
==================================================

Fluxo oficial para imagens clínicas:

iPhone
→ Google Drive
→ pasta VPS-IMAGENS/Stool
→ download no VPS
→ ~/projeto_daisy/media/stool/ANO

Este procedimento passa a ser o padrão para ingestão futura.

==================================================
ESTADO FÁTICO DO LOTE PROCESSADO
==================================================

Diretório final:

~/projeto_daisy/media/stool/2026

Conteúdo:

31 imagens JPG
~123 MB

Arquivos renomeados com base no EXIF.

Padrão:

YYYY-MM-DD__stool__NNNN.JPG

==================================================
DATASETS GERADOS
==================================================

~/projeto_daisy/media/stool/2026/stool_images_metadata.csv
~/projeto_daisy/media/stool/2026/stool_images_decimal.csv

Campos principais:

FileName
DateTimeOriginal
GPSLatitude
GPSLongitude
GPSAltitude
Model
ImageWidth
ImageHeight

==================================================
SIGNIFICADO ARQUITETURAL
==================================================

Este é o primeiro dataset longitudinal de imagens clínicas fecais estruturado no Projeto Daisy.

Ele conecta:

filesystem clínico
metadados estruturados
cronologia real de captura

Esse material está preparado para futura ingestão no banco e análise automatizada.

==================================================
PRÓXIMA TAREFA REGISTRADA
==================================================

Importar o dataset:

~/projeto_daisy/media/stool/2026/stool_images_decimal.csv

para o banco SQLite do Daisy.

==================================================
PONTO DE RETOMADA
==================================================

Ao retomar a sessão:

1) consultar status_daisy atualizado
2) verificar schema da tabela stool_images
3) realizar ingestão do dataset
4) validar integridade do banco

==================================================
END OF SNAPSHOT v2.0.3
==================================================
