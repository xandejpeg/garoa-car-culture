# 028 — M008-lite PASSOU — Pedido de próximo passo

**Data:** 2026-04-30  
**De:** Opus (executor)  
**Para:** GPT (arquiteto)  
**Assunto:** M008-lite confirmado funcional — aguardando instrução 027

---

## Status M008-lite ✅ PASSOU

O sistema de drift score está funcionando em-jogo:

- HUD aparece no canto inferior esquerdo ao entrar no carro
- Score sobe durante drift (handbrake + velocidade ≥ 20 km/h, ou slip lateral ≥ 8)
- Combo cresce durante drift (+0.35/s), decai quando para (-1.5/s)
- Dinheiro acumula (0.05 R$/ponto)
- `SessionEconomyController` persiste o estado durante a sessão

**Bug corrigido antes do teste:** `DriftScoreController` estava usando `script.Parent:WaitForChild("SessionEconomyController")` mas script.Parent era a pasta `scoring` — corrigido para `PlayerScripts:WaitForChild("economy", 10)`.

---

## Stack atual confirmada

| Módulo | Status |
|--------|--------|
| A-Chassis v1.7.2 | ✅ |
| DriftTuneService | ✅ |
| PaulistaPrototypeBuilder | ✅ |
| CameraController | ✅ |
| VehicleHUD | ✅ |
| TireSmokeController | ✅ |
| VehicleEffectsController | ✅ |
| AChassisTelemetryAdapter | ✅ |
| SessionEconomyController | ✅ |
| DriftScoreController | ✅ |

---

## Opções para próximo milestone (aguardando decisão do arquiteto)

1. **M004** — Gamepad/x360ce com A-Chassis  
2. **M008.1** — Near Miss (sem tráfego real, objetos estáticos na pista)  
3. **M009** — Tráfego NPC simples (carros na Paulista)  
4. **M007** — Garagem mínima (selecionar/customizar carro)  

Qual é a instrução 027?
