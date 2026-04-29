# Milestone 002 — Carro Placeholder por Teclado

**Status:** Implementado — aguardando teste no Roblox Studio  
**Prerequisito:** M001 (Rojo conectando) ✅

---

## Objetivo

Primeiro loop jogável:

```
Player spawna a pé
→ anda com WASD
→ chega perto do carro
→ aparece prompt [E] Entrar
→ pressiona E → entra no carro
→ dirige com WASD
→ pressiona E → sai do carro
```

---

## Arquivos implementados

| Arquivo | O que faz |
|---|---|
| `src/server/services/VehicleSpawnService.server.lua` | Spawna o carro placeholder no mapa |
| `src/client/input/OnFootInputController.lua` | Detecta E perto do carro |
| `src/client/input/VehicleInputController.lua` | Lê W/S/A/D e aplica no VehicleSeat |
| `src/client/input/InputContextController.client.lua` | Troca contexto OnFoot ↔ Vehicle |
| `src/client/camera/CameraController.lua` | Câmera follow básica ao entrar no carro |
| `src/shared/config/DebugConfig.lua` | Flag `ShowInputHUD` para ativar HUD de diagnóstico |

---

## Como testar

### Passo 1 — Iniciar Rojo
```
No terminal do VS Code, na pasta do projeto:
rojo serve
```

### Passo 2 — Conectar Roblox Studio
1. Abrir Roblox Studio
2. Abrir place vazio
3. Plugins → Rojo → Connect

Confirmar que aparece no Explorer:
```
ServerScriptService/
  services/
    VehicleSpawnService

StarterPlayer/StarterPlayerScripts/
  input/
    InputContextController  ← LocalScript
    InputTestHUD            ← LocalScript
    OnFootInputController   ← ModuleScript
    VehicleInputController  ← ModuleScript
    ...

ReplicatedStorage/Shared/config/
  InputConfig
  DebugConfig
```

### Passo 3 — Testar

1. Clicar em **Play** no Roblox Studio
2. O personagem spawna a pé
3. Andar até o carro vermelho (spawna em 0, 3, 20)
4. Quando próximo, aparece o prompt **[E] Entrar** acima do banco
5. Pressionar **E** → personagem senta no carro
6. Câmera muda para visão de trás do carro
7. **W** acelera, **S** freia/ré, **A/D** vira
8. Pressionar **E** → sai do carro

---

## Critérios de sucesso

- [ ] Carro aparece no mapa ao iniciar
- [ ] Personagem anda normalmente com WASD
- [ ] Prompt [E] Entrar aparece quando próximo
- [ ] E entra no carro
- [ ] WASD controla o carro
- [ ] Câmera segue o carro
- [ ] E sai do carro
- [ ] Personagem volta a andar normalmente

---

## Problemas conhecidos / limitações

- Carro é um bloco vermelho simples (sem modelo real)
- Câmera usa lerp simples (pode tremer em curvas bruscas)
- VehicleSeat usa `Throttle` para freio (S = throttle negativo = ré/freio)
- Sem dano, sem física avançada, sem drift

---

## Como ativar o HUD de diagnóstico (M001)

Editar `src/shared/config/DebugConfig.lua`:

```lua
DebugConfig.ShowInputHUD = true  -- muda para true
```

Isso reativa o painel de eixos/botões do x360ce.

---

## Próximo passo (M003)

Após validar o loop acima com teclado:

1. Mapear gamepad/x360ce ao `VehicleInputController`
2. Calibrar eixos do G29 com `InputTestHUD` (DebugConfig.ShowInputHUD = true)
3. Substituir controles de teclado por eixos analógicos no carro
