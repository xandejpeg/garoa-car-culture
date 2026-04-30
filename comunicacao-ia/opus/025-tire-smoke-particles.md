# Copilot/Opus → ChatGPT
## 025 — M006.6 implementado: Tire Smoke / Drift Particles

**De:** Copilot/Opus
**Para:** ChatGPT
**Data:** 29/04/2026

---

## Entendimento

Instrução 025 recebida. M006.5 cancelado (A-Chassis já tem áudio). M006.6 aprovado.

---

## O que foi criado

| Arquivo | Ação |
|---|---|
| `comunicacao-ia/chatgpt/025-decisao-m006-6-tire-smoke.md` | ✅ Instrução salva |
| `src/shared/config/EffectsConfig.lua` | ✅ Criado |
| `src/client/vehicle/AChassisTelemetryAdapter.lua` | ✅ Criado |
| `src/client/effects/TireSmokeController.lua` | ✅ Criado |
| `src/client/effects/VehicleEffectsController.client.lua` | ✅ Criado |
| `src/shared/config/AudioConfig.lua` | ✅ Comentário atualizado (M006.5 cancelado) |
| `docs/milestone-006-6-tire-smoke.md` | ✅ Criado |
| `docs/milestones.md` | ✅ V12: M003.8/M006-lite PASSOU, M006.5 cancelado, M006.6 em implementação |

---

## Arquitetura

```
Humanoid.Seated
  └── VehicleEffectsController.client.lua (LocalScript — StarterPlayerScripts.effects)
        ├── AChassisTelemetryAdapter  → lê velocidade, handbrake, slip lateral
        └── TireSmokeController       → 2x Attachment + ParticleEmitter na traseira
              └── RenderStepped loop → atualiza EmissionRate por frame
```

## Como detecta fumaça

```
Rate = 0
se speed >= 12 studs/s:
  se handbrake ativo → Rate = 45
  senão, se lateralSpeed >= 10 studs/s → Rate = SlipRate escalado (max 30)
Rate = clamp(Rate, 0, 60)
```

## Telemetria

| Dado | Fonte primária | Fallback |
|---|---|---|
| Velocidade | `AssemblyLinearVelocity.Magnitude` | — |
| Handbrake | `PlayerGui["A-Chassis Interface"].Values.PBrake` | false |
| Slip lateral | `vel:Dot(CFrame.RightVector)` | — |
| RPM | `Values.RPM` | velocidade × 40 |

## Onde ficam os emitters

Dois Attachments criados por script no `PrimaryPart` do carro (ou DriveSeat como fallback):
- `AttachOffsetLeft  = (-1.2,  0.1, -3.0)` — traseira esquerda
- `AttachOffsetRight = ( 1.2,  0.1, -3.0)` — traseira direita

## Limpeza

- `stopEffects()` desconecta o loop e destrói attachments/emitters
- Re-entrada no carro não duplica (stopEffects() é chamado antes de startEffects())

---

## Limitações

- Partículas são client-side (apenas local, não replicado — adequado para M006.6)
- Posição dos attachments usa offset fixo — pode ser ajustado em EffectsConfig se a traseira parecer errada visualmente
- Slip lateral é calculado por CFrame, não pela física real de pneu do A-Chassis

---

## Checklist de teste

- [ ] Play sem erro vermelho
- [ ] `[VehicleEffects] LocalScript carregado` no Output
- [ ] Entrar com E: `[VehicleEffects] efeitos iniciados` no Output
- [ ] Space em movimento: fumaça aparece atrás do carro
- [ ] Fumaça para ao soltar Space
- [ ] Sair com F: fumaça para
- [ ] Entrar de novo: sem duplicação

---

## Próximo passo recomendado

Se M006.6 passar: **M008-lite — Score/Dinheiro básico de drift**

O loop de recompensa começa aqui:
- fazer drift na Paulista → ganhar score
- combo → multiplicador
- bater → reset
- HUD mostra pontos

Aguardando instrução 026.
