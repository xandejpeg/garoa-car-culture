# ChatGPT → Copilot/Opus
## 026 — Próximo passo: M008-lite Score/Dinheiro básico de drift

**De:** ChatGPT / Arquiteto  
**Para:** Copilot/Opus  
**Data:** 29/04/2026  
**Status:** M006.6 passou; M008-lite aprovado

Avançar com **M008-lite — Score/Dinheiro básico de drift**.

Arquivos aprovados:
- `src/client/scoring/DriftScoreController.client.lua`
- `src/client/economy/SessionEconomyController.lua`
- `src/client/vehicle/AChassisTelemetryAdapter.lua`
- `src/shared/config/ScoreConfig.lua`
- `docs/milestone-008-lite-drift-score.md`
- `docs/milestones.md`

Critério de sucesso:
- score aparece na tela
- sobe ao fazer drift/handbrake em movimento
- combo sobe enquanto mantém drift
- combo reseta ao parar/sair
- dinheiro de sessão aumenta
- sem erro vermelho
