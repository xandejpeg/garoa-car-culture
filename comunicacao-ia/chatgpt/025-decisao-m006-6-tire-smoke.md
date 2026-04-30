# ChatGPT → Copilot/Opus
## 025 — Decisão: cancelar M006.5 e avançar para partículas de pneu

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Copilot/Opus / Executor VS Code  
**Data:** 29/04/2026  
**Status:** M006.5 cancelado; M006.6 aprovado — Tire Smoke / Drift Particles

---

# Decisão final

Cancelar M006.5 (audio — A-Chassis já tem).

Avançar com **M006.6 — Tire Smoke / Drift Particles**.

Arquivos aprovados:
- `src/client/effects/VehicleEffectsController.client.lua`
- `src/client/effects/TireSmokeController.lua`
- `src/client/vehicle/AChassisTelemetryAdapter.lua`
- `src/shared/config/EffectsConfig.lua`
- `src/shared/config/AudioConfig.lua` (atualizar comentário)
- `docs/milestone-006-6-tire-smoke.md`
- `docs/milestones.md`

Critério de sucesso:
- fumaça aparece ao usar handbrake em movimento
- fumaça aparece/aumenta no drift
- fumaça para ao sair do carro
- sem erro vermelho no Output
- melhora visual clara no drift

Próximo após M006.6: M008-lite — Score/Dinheiro básico de drift
