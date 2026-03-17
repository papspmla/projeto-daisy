# ROADMAP — PROJETO DAISY

Autor: Paulo  
Projeto: Daisy Clinical Intelligence System  
Servidor: Hetzner VPS (Ubuntu 24.04)

Este documento lista ideias, melhorias arquiteturais e futuras
expansões do Projeto Daisy.

O roadmap não representa funcionalidades já implementadas.
Ele registra direções futuras para evolução do sistema.

---

# 1. Ingestão Automática de Mídia Clínica (Google Drive → VPS)

## Ideia

Implementar um processo automático no VPS que monitore
periodicamente as pastas do Google Drive usadas como
entrada de dados do projeto.

Atualmente o fluxo é manual:

iPhone  
→ Google Drive  
→ download manual no VPS  
→ processamento  
→ ingestão no banco

A proposta é automatizar parte desse processo.

---

## Fluxo desejado

iPhone  
→ Google Drive  
→ varredura automática no VPS  
→ download de novos arquivos  
→ organização no filesystem do projeto  
→ extração de metadados  
→ preparação para ingestão no banco

---

## Tipos de mídia afetados

- imagens de fezes (stool)
- imagens de vulva
- áudios de auscultação cardíaca
- espectrogramas de auscultação

---

## Benefícios

- elimina etapas manuais repetitivas
- reduz risco de erro humano
- padroniza ingestão
- acelera fluxo de dados clínicos

---

## Princípio de segurança

O download e pré-processamento podem ser automáticos.

A gravação final no banco deve permanecer auditável
para evitar erros silenciosos.

---

# 2. Integração com OpenAI API

Objetivo futuro:

Enviar automaticamente imagens e áudios para análise
por modelos da OpenAI.

Resultados esperados:

- classificação de fezes (Bristol)
- detecção de muco ou sangue
- avaliação visual geral
- análise acústica cardíaca

Os resultados populam automaticamente os campos clínicos
no banco Daisy.

---

# 3. Camada de Computer Vision (fase avançada)

Futuro possível:

análise local de imagens com modelos próprios.

Objetivos possíveis:

- segmentação de fezes
- análise de cor
- detecção de textura
- comparação longitudinal

---

# 4. Dashboard clínico

Possível fase futura:

criar interface visual para análise longitudinal dos dados.

Exemplos:

- timeline intestinal
- evolução de peso
- pressão arterial
- temperatura
- eventos urinários

---

# Observação final

O roadmap registra ideias e direções futuras.

A evolução do Projeto Daisy é guiada
pela experiência prática obtida com os dados reais da Daisy.
