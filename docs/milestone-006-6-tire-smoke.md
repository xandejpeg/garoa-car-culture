# M006.6 — Tire Smoke / Drift Particles

**Status:** ⏳ Em implementação — 29/04/2026  
**Pré-requisito:** M006-lite ✅ PASSOU

---

## Objetivo

Criar fumaça de pneu visível ao derrapar/usar handbrake na Paulista Prototype.

---

## Arquivos criados

| Arquivo | Papel |
|---|---|
| `src/client/effects/VehicleEffectsController.client.lua` | LocalScript orquestrador — autogerenciado via Humanoid.Seated |
| `src/client/effects/TireSmokeController.lua` | Módulo — cria e controla ParticleEmitters nas rodas traseiras |
| `src/client/vehicle/AChassisTelemetryAdapter.lua` | Módulo — lê velocidade, RPM, gear, handbrake, slip lateral |
| `src/shared/config/EffectsConfig.lua` | Config central — taxas, tamanhos, thresholds de fumaça |

---

## Arquitetura

```
Humanoid.Seated
  └── VehicleEffectsController (LocalScript)
        ├── AChassisTelemetryAdapter  → lê velocidade, handbrake, slip
        └── TireSmokeController       → 2x Attachment + ParticleEmitter
              └── RenderStepped loop → atualiza EmissionRate
```

---

## Lógica de ativação

```
SmokeRate > 0 quando:
  (handbrake == true AND speed >= MinSpeed)         → taxa HandbrakeRate (45)
  OU
  (lateralSpeed >= LateralSlipThreshold AND speed >= MinSpeed) → taxa SlipRate (30)

Clamp: MaxRate = 60
```

---

## Telemetria

| Dado | Fonte primária | Fallback |
|---|---|---|
| Velocidade | `carRoot.AssemblyLinearVelocity.Magnitude` | — |
| Handbrake | `Values.PBrake` (BoolValue) | false |
| Slip lateral | `vel:Dot(CFrame.RightVector)` | — |
| RPM | `Values.RPM` (NumberValue) | velocidade × 40 |

---

## Checklist de teste

### Setup
- [ ] Play sem erro vermelho
- [ ] `[VehicleEffects] LocalScript carregado` no Output
- [ ] Entrar no carro com E
- [ ] `[VehicleEffects] efeitos iniciados` no Output

### Fumaça
- [ ] Acelerar na reta — sem fumaça
- [ ] Apertar Space em movimento — fumaça aparece atrás do carro
- [ ] Fumaça sai da traseira (dois pontos)
- [ ] Soltar Space — fumaça para
- [ ] Fazer curva agressiva sem handbrake — fumaça por slip aparece
- [ ] Sair com F — fumaça para
- [ ] Entrar de novo — fumaça não duplica

### Feeling
- [ ] Fumaça fraca / boa / forte demais
- [ ] Aparece no lugar certo?
- [ ] Melhora a sensação de drift?
- [ ] Pesa FPS?

---

## Template de resultado

```
### Fumaça apareceu com Space?
Sim/Não

### Fumaça apareceu por deriva sem handbrake?
Sim/Não

### Saída/re-entrada não duplicou?
Sim/Não

### Erros no Output:
(cole aqui)

### Feeling:
- Intensidade: fraca / boa / forte
- Posição: lugar errado / certa
- Impacto no drift: zero / um pouco / muito
- FPS: ok / caiu
```

---

## Critério de sucesso

M006.6 passa se:
- fumaça aparece ao usar handbrake em movimento
- fumaça para ao soltar / sair do carro
- sem duplicação ao entrar/sair várias vezes
- sem erro vermelho
- usuário percebe melhora visual no drift

---

## Próximo passo após M006.6

**M008-lite — Score/Dinheiro básico de drift**
