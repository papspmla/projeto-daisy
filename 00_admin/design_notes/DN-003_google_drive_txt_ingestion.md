# DN-003 — Google Drive TXT Ingestion Workflow

Data: 15/03/2026

Contexto
Durante testes operacionais do pipeline de ingestão TXT
(iPhone Notes → TXT → Google Drive → VPS),
ficou claro que a sequência manual de comandos
para baixar, normalizar e mover arquivos
é longa e propensa a erro.

Decisão
Criar um pequeno script operacional para ingestão manual
de registros de pressão arterial armazenados no Google Drive.

Script
~/projeto_daisy/tools/fetch_bp_txt.sh

Uso

~/projeto_daisy/tools/fetch_bp_txt.sh "LINK_DO_GOOGLE_DRIVE"

Função do script
1. Extrai o ID do arquivo do link do Google Drive
2. Faz download do TXT
3. Converte CRLF → LF (dos2unix)
4. Move para data/03_pressao
5. Renomeia com timestamp

Objetivo
Reduzir um processo de múltiplos comandos
para um único comando operacional.

Observação
Esse mecanismo é temporário e será substituído
no futuro pelo componente automatizado
"daisy-sync".
