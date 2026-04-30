# Milestone M003.7 — Chase Camera / Feeling Visual

**Status:** ⏳ Código implementado — aguardando Play Test  
**Data de criação:** 29/04/2026  
**Baseado em:** decisão ChatGPT 019

---

## Objetivo

Substituir a câmera básica do CameraController por uma chase camera com suavização, variação de distância/FOV por velocidade e sensação de carro real.

**Não é câmera final** — é a primeira câmera que faz o jogo parecer um jogo de carro.

---

## Pré-requisito

- ✅ M003.6 Paulista Prototype testada e aprovada

---

## O que será criado/alterado

| Arquivo | Ação | Descrição |
|---|---|---|
| `src/shared/config/CameraConfig.lua` | ✅ Criado | Configuração de distância, FOV, smoothing |
| `src/client/camera/CameraController.lua` | ✅ Reescrito | Modo `chase` com CameraConfig |
| `src/client/input/InputContextController.client.lua` | ✅ Atualizado | Passa `carRoot` para a câmera ao entrar |

---

## Fora de escopo (NÃO fazer nesta milestone)

- Câmera cockpit
- Câmera livre / drone
- Replay camera
- Câmera cinematográfica
- Motion blur
- Múltiplos modos de câmera com UI
- Câmera por obstáculo complexa

---

## Especificação técnica

### Modo "chase" no CameraController

O `CameraController.setMode("chase")` deve:

1. Setar `camera.CameraType = Enum.CameraType.Scriptable`
2. A cada `RenderStepped`:
   - Encontrar o carro ativo (passado por parâmetro ou por referência global)
   - Calcular velocidade atual (`rootPart.AssemblyLinearVelocity.Magnitude`)
   - Calcular `distance = clamp(BaseDistance + speed * SpeedDistanceMultiplier, BaseDistance, MaxDistance)`
   - Calcular `fov = clamp(BaseFOV + speed * FOVSpeedMultiplier, BaseFOV, MaxFOV)`
   - Calcular posição desejada: `carCFrame * CFrame.new(0, BaseHeight, distance)` (atrás)
   - Lerp da posição atual → desejada com `Smoothness`
   - `CFrame.lookAt(smoothedPos, carCFrame.Position + carCFrame.LookVector * LookAheadDistance)`
   - Aplicar FOV em `camera.FieldOfView`
3. Ao sair do carro (`setMode("default")`):
   - `camera.CameraType = Enum.CameraType.Custom`
   - Desconectar RenderStepped
   - Restaurar `camera.FieldOfView = 70`

### API pública esperada

```lua
CameraController.setMode("default")         -- câmera on-foot padrão
CameraController.setMode("chase", carRoot)  -- chase camera com referência ao carro
CameraController.getMode()                  -- retorna modo atual
```

### Onde é chamado

- `InputContextController.client.lua` ao entrar no carro → `setMode("chase", carRootPart)`
- `InputContextController.client.lua` ao sair do carro → `setMode("default")`

---

## CameraConfig.lua (já criado)

```lua
BaseDistance = 22
MaxDistance  = 32
BaseHeight   = 8
SpeedDistanceMultiplier = 0.04
BaseFOV      = 70
MaxFOV       = 90
FOVSpeedMultiplier      = 0.12
Smoothness   = 0.10
LookAheadDistance       = 4
Enabled      = true
```

---

## Checklist de teste

| Item | Resultado |
|---|---|
| Câmera ficou atrás do carro ao entrar | ⬜ |
| Câmera segue sem tremer bruscamente | ⬜ |
| FOV aumenta visivelmente em alta velocidade | ⬜ |
| Distância aumenta em alta velocidade | ⬜ |
| Câmera volta ao padrão ao sair (F) | ⬜ |
| FOV volta a 70 ao sair | ⬜ |
| Câmera on-foot não foi afetada | ⬜ |
| Sem erros vermelhos | ⬜ |
| Feeling: "parece mais jogo de carro" | ⬜ |

---

## Riscos

| Risco | Mitigação |
|---|---|
| CameraController ainda referencia `CarPlaceholder` hardcoded | Atualizar para receber carRoot como parâmetro |
| RenderStepped pode causar jitter se smoothing = 0 | Manter Smoothness ≥ 0.05 |
| Camera clipping no chão em baixa velocidade | BaseHeight ≥ 6 evita maior parte dos casos |
| FOV alto pode causar tontura | MaxFOV ≤ 90 é seguro para maioria |
| InputContextController não passa carRoot para câmera | Precisa de ajuste na chamada setMode |

---

## Template de resultado (preencher após Play Test)

```
Data: ___/___/2026
Feeling geral (1-5): __
Câmera estava suave: sim / não
FOV dinâmico perceptível: sim / não
Parece mais jogo: sim / não
Problemas encontrados: ___
Ajustes feitos no CameraConfig: ___
```

---

## Resultado

**Status:** ⏳ Pendente
