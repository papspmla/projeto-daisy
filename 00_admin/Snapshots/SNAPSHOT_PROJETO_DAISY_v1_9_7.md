# =====================================================================
# SNAPSHOT_PROJETO_DAISY_v1_9_7.md — gerar arquivo (bash mono)
# =====================================================================

mkdir -p ~/projeto_daisy/snapshots

cat > ~/projeto_daisy/snapshots/SNAPSHOT_PROJETO_DAISY_v1_9_7.md <<'EOF'
SNAPSHOT_PROJETO_DAISY_v1_9_7
Data: 2026-03-11

============================================================
PROJECT STATE
============================================================

The Daisy clinical engine is operational and now includes a fully ingested
longitudinal body weight dataset integrated into the clinical pipeline.

Core clinical pipeline (Go binaries in ~/projeto_daisy/bin):

detect_clinical_phases
renal_function_model
renal_interpreter
hepatic_interpreter
metabolic_interpreter
weight_interpreter
trend_analyzer
clinical_alerts
clinical_consistency_engine
clinical_summary
daisy_clinical_report

The report runs end-to-end with:

~/projeto_daisy/bin/daisy_clinical_report 1


============================================================
MAJOR CHANGES THIS SNAPSHOT
============================================================

1) WEIGHT DATA INGESTION COMPLETED (LONGITUDINAL)

- Daisy weight records are now fully ingested and validated in SQLite.

Current state:
- patient_id=1 total weight records: 206
- first record: 2020-03-20 = 7.95 kg
- last record: 2026-03-06 = 40.65 kg

Validation performed:
- no duplicates under UNIQUE(patient_id, collection_date, feeding_state)
- no patient_id NULL
- no empty feeding_state
- no invalid dates (no YYYY-MM-00)
- chronological order verified (no date regressions)

Clinical note stored:
- 2025-05-30: notes="AKI episode"


2) WEIGHT ENGINE IMPLEMENTED + INTEGRATED

- Implemented/updated:
  ~/projeto_daisy/go/weight_interpreter.go
- Binary:
  ~/projeto_daisy/bin/weight_interpreter

Weight JSON output now includes:
- long_term_trend
- recent_trend
- delta_4weeks
- rapid_loss / rapid_gain
- metabolic_stable

Integration:
- daisy_clinical_report now prints "WEIGHT ANALYSIS"
- clinical_summary now consumes weight_interpreter output and prints:
  - weight_summary
  - weight-related overall flags


3) CLINICAL FLAGS UPDATED (WEIGHT FLAGS)

- Updated:
  ~/projeto_daisy/go/clinical_flags_engine.go

Now includes structured weight flags:
- weight_rapid_loss
- weight_rapid_gain
- weight_recent_decrease
- weight_recent_increase


4) BUILD SYSTEM FIXED (GO MODULE)

- Recreated:
  ~/projeto_daisy/tools/build_daisy.sh

Key correction:
- build script now compiles inside ~/projeto_daisy/go so go.mod is always found.
- mattn/go-sqlite3 compilation errors eliminated.
- full build succeeds.


5) MULTI-PATIENT COMPATIBILITY (TRANSITION)

- trend_analyzer updated to:
  - filter chemistry by patient_id
  - preserve the legacy JSON schema expected by other engines
  - accept patient_id argument
  - keep compatibility with older calls (no-arg mode defaults to patient_id=1)

This prevents structural breakage while the system transitions to full patient_id propagation.


6) RENAL INTERPRETER FIXED (PATIENT_ID PROPAGATION)

- renal_interpreter rewritten to accept patient_id and pass it to:
  - clinical_flags_engine
  - trend_analyzer
  - renal_function_model

Result:
- renal interpreter output restored to "compensated renal function" with full evidence.


============================================================
PROJETO DAISY — REGRAS FIXAS DE INTERAÇÃO E GOVERNANÇA – IMUTAVEIS
============================================================

ATENÇÃO !!

8. REGRAS COMPORTAMENTAIS FIXAS IMUTÁVEIS PARA O CHATGPT:
TODAS as regras abaixo devem OBRIGATORIAMENTE ser copiadas para o novo snapshot ao final de cada sessão.
Um único comando por vez, precedido por uma muito resumida explicação da finalidade.
Aguarde pela minha resposta.
E só então prossiga para o próximo comando. Não teça qualquer comentário até receber minha resposta.
E as regras seguintes são a constituição da interação usuário-chatgpt durante este projeto, e também devem ser literalmente copiadas para o próximo snapshot no final da sessão:

============================================================
PROJETO DAISY — REGRAS FIXAS DE INTERAÇÃO E GOVERNANÇA – IMUTAVEIS
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

============================================================
NEXT TASK (FIRST TASK NEXT SESSION)
============================================================

Próxima tarefa (multipaciente de verdade): corrigir os módulos que ainda chamam trend_analyzer/detect_clinical_phases sem passar patient_id (hoje funciona por causa do fallback patient_id=1, mas isso quebra quando houver outro paciente). Primeiro da lista (mais crítico): clinical_alerts.go.

Objetivo: ver o código atual para eu refazer no padrão remover → recriar → colar → compilar.

