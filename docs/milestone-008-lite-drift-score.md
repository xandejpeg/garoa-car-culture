# M008-lite — Score/Dinheiro básico de drift

**Status:** ⏳ Em implementação — 29/04/2026  
**Pré-requisito:** M006-lite ✅, M006.6 ✅

---

## Objetivo

Primeiro loop de recompensa: fazer drift → ganhar score → dinheiro de sessão.

---

## Arquivos criados

| Arquivo | Papel |
|---|---|
| `src/shared/config/ScoreConfig.lua` | Parâmetros de scoring (velocidade, pontos, combo, dinheiro) |
| `src/client/economy/SessionEconomyController.lua` | Estado de sessão (score, money, combo) — sem DataStore |
| `src/client/scoring/DriftScoreController.client.lua` | LocalScript orquestrador + UI de score |

---

## Arquitetura

```
Humanoid.Seated
  └── DriftScoreController.client.lua (LocalScript — StarterPlayerScripts.scoring)
        ├── AChassisTelemetryAdapter  → lê velocidade, handbrake, slip
        ├── SessionEconomyController  → acumula score/money/combo
        └── UI inline                → ScreenGui bottom-left
```

---

## Fórmula

```
isDrift = (handbrake AND kmh >= MinSpeedKmh)
          OR (lateralSpeed >= LateralSlipThreshold AND kmh >= MinSpeedKmh)

pts/s = BaseDriftPointsPerSecond
      × HandbrakeBonus (se handbrake)
      × SlipBonusMultiplier (se slip)

combo cresce +0.35/s durante drift, decai -1.5/s sem drift
combo reseta a 1.0 se kmh < ComboResetSpeedKmh

money += pts × combo × MoneyPerPoint
```

---

## UI

`DriftScoreHUD` — ScreenGui, bottom-left, DisplayOrder 99

```
DRIFT
1,240
x2.4          R$62
```

- Score: amarelo, grande
- Combo: âmbar quando ativo, laranja-vivo acima de x2.0, cinza quando inativo
- Dinheiro: verde

**Não colide com VehicleHUD** (bottom-right).

---

## Limitações

- Client-side only — sem DataStore, sem persistência
- Anti-cheat não implementado (TODO: validação server-side no futuro)
- Slip detection usa velocidade lateral local (não física real de pneu)
- Dinheiro reseta ao sair do Play

---

## Checklist de teste

### Setup
- [ ] Play sem erro vermelho
- [ ] `[DriftScore] LocalScript carregado` no Output
- [ ] Entrar no carro: `[DriftScore] scoring iniciado`
- [ ] HUD de score aparece no canto inferior esquerdo

### Score
- [ ] Acelerar reto: score não sobe (ou sobe muito pouco)
- [ ] Space em movimento: score sobe, combo começa a crescer
- [ ] Manter drift: combo passa de x2.0 (cor vira laranja-vivo)
- [ ] Soltar e parar: combo decai de volta a x1.0
- [ ] Sair com F: combo reseta, HUD some
- [ ] Dinheiro aumenta conforme score

### Feeling
- [ ] Score sobe rápido demais / certo / devagar
- [ ] Combo faz sentido visualmente
- [ ] Dá vontade de repetir para subir o score?

---

## Template de resultado

```
### Score apareceu na tela?
Sim/Não

### Score subiu com handbrake?
Sim/Não

### Combo cresceu?
Sim/Não

### Combo resetou ao sair?
Sim/Não

### Erros no Output:
(cole aqui)

### Feeling:
- Score rápido demais / certo / devagar
- Combo faz sentido? Sim/Não
- Deu vontade de repetir? Sim/Não
```

---

## Próximo passo após M008-lite

**Decisão do GPT** — opções:
- M004 Gamepad/x360ce
- M008.1 Near Miss sem tráfego real (cones/obstáculos)
- M009 Tráfego NPC simples (base No Hesi)
- M007 Garagem mínima
