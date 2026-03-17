SNAPSHOT_PROJETO_DAISY_v1_9_3

Data de geração: 2026-03-07 16:01 UTC

Estado atual do Projeto Daisy

Base clínica principal: SQLite (daisy.db)
Base analítica complementar: PostgreSQL (daisy_pg)
Diretório principal: ~/projeto_daisy
Ferramentas: ~/projeto_daisy/tools
Logs: ~/projeto_daisy/logs

Capacidades implementadas:
- Interpretação automática de exames bioquímicos
- Comparação com intervalos de referência laboratoriais
- Detecção automática de evento AKI
- Reconstrução de fases clínicas (Baseline / AKI / Recovery / Stabilization)
- Análise de tendências por biomarcador
- Análise de tendências dentro da fase clínica
- Geração de interpretação clínica automática
- Dashboard clínico completo (daisy_clinical_dashboard.sh)
- Quick view operacional (daisy_quick.sh)

Observações importantes da sessão

1. O dashboard clínico completo encontra-se funcional, porém pesado (~60 s).
2. O gargalo identificado está nos motores analíticos que reprocessam o histórico repetidamente.
3. Tentativas de otimização no Bash não produziram ganho significativo.
4. Foi criado um modo 'quick view', porém ainda dependente de motores pesados.
5. Conclusão arquitetural: Bash atingiu limite saudável para análise clínica longitudinal.

Decisão arquitetural da sessão

Decidido iniciar migração progressiva dos motores críticos do Projeto Daisy para linguagem Go.

Motivação:
- Redução drástica do tempo de execução
- Consolidação do motor clínico
- Eliminação de múltiplas consultas redundantes
- Base mais robusta para evolução futura do sistema

Primeiro alvo de conversão

Script selecionado para primeira conversão:
detect_clinical_phases.sh

Motivo:
- Lógica simples
- Poucas dependências
- Saída estruturada já definida

Próxima tarefa correta na próxima sessão

1. Instalar Go no servidor (VPS)
2. Instalar o compilador Go
3. Criar diretório para código Go do projeto

Sugestão de diretório:
~/projeto_daisy/go

Depois disso:
- iniciar conversão de detect_clinical_phases.sh para Go

4.Após isso:

na próxima sessão podemos também criar um script único de encerramento de sessão (close_session.sh), que executaria automaticamente:

snapshot do status_daisy

backup manual do SQLite

em um único comando.

Regras operacionais preservadas

- Passar apenas 1 comando por vez
- Aguardar sempre o resultado antes do próximo passo
- Explicar brevemente o objetivo antes de cada comando

--------------------------------------------------------------------------------------------

REGRA OPERACIONAL PERMANENTE — ENCERRAMENTO DE SESSÃO

Ao final de cada sessão técnica do Projeto Daisy deve ser criado
um snapshot manual do arquivo:

~/projeto_daisy/00_admin/status_daisy.md

O snapshot deve ser salvo em:

~/projeto_daisy/status_history/

utilizando timestamp no nome do arquivo.

Comando oficial:

cp ~/projeto_daisy/00_admin/status_daisy.md \
~/projeto_daisy/status_history/status_daisy_$(date +%Y-%m-%d_%H%M).md

Este procedimento preserva o estado arquitetural do projeto
independentemente dos backups automáticos do sistema.

REGRA OPERACIONAL PERMANENTE — BACKUP MANUAL DO SQLITE

Ao final de cada sessão técnica do Projeto Daisy

deve ser executado um backup manual do banco clínico SQLite.

Arquivo:

~/projeto_daisy/database/daisy.db

Destino:

~/projeto_daisy/backups/

Comando oficial:

cp ~/projeto_daisy/database/daisy.db \
~/projeto_daisy/backups/daisy_sqlite_manual_$(date +%Y-%m-%d_%H%M).db
