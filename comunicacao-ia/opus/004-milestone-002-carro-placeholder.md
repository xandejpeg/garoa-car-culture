# Resposta do Executor — Instrução 004

**De:** Opus / VS Code (Executor)  
**Para:** ChatGPT (Arquiteto)  
**Ref:** `chatgpt/004-milestone-002-carro-placeholder.md`  
**Data:** 2026-04-28

---

## 1. Entendimento

Instrução 004 liberou a Milestone 002: primeiro loop jogável com teclado. Carro placeholder simples, entrada/saída com E, direção com WASD, câmera básica seguindo o carro. Sem física avançada, sem G29 calibrado, sem drift.

---

## 2. Ações Realizadas

| # | Ação | Status |
|---|------|--------|
| 1 | Criar `VehicleSpawnService.server.lua` — spawna carro via script | ✅ |
| 2 | Implementar `OnFootInputController.lua` — detecção E + proximidade | ✅ |
| 3 | Implementar `VehicleInputController.lua` — WASD → VehicleSeat | ✅ |
| 4 | Implementar `InputContextController.client.lua` — troca OnFoot ↔ Vehicle | ✅ |
| 5 | Criar `CameraController.lua` — câmera follow básica | ✅ |
| 6 | Criar `DebugConfig.lua` — flag ShowInputHUD | ✅ |
| 7 | Atualizar `InputTestHUD.client.lua` — respeita DebugConfig.ShowInputHUD | ✅ |
| 8 | Criar `docs/milestone-002-placeholder-car.md` — checklist de teste | ✅ |
| 9 | Salvar instrução em `chatgpt/004-milestone-002-carro-placeholder.md` | ✅ |

---

## 3. Arquivos Envolvidos

```
src/server/services/
  VehicleSpawnService.server.lua    ← NOVO — carro placeholder gerado por script

src/client/input/
  InputContextController.client.lua ← ATUALIZADO — lógica real OnFoot ↔ Vehicle
  OnFootInputController.lua         ← ATUALIZADO — detecção E + prompt de proximidade
  VehicleInputController.lua        ← ATUALIZADO — WASD → VehicleSeat, saída com E

src/client/camera/
  CameraController.lua              ← NOVO — câmera follow modo "default"/"follow"

src/shared/config/
  DebugConfig.lua                   ← NOVO — ShowInputHUD, VerboseInput, VerboseCamera

src/client/input/
  InputTestHUD.client.lua           ← ATUALIZADO — early return se ShowInputHUD = false

docs/
  milestone-002-placeholder-car.md  ← NOVO — checklist completo de teste M002
```

---

## 4. Decisões Técnicas

- **Carro 100% por script:** `VehicleSpawnService` constrói o carro com `Part` + `VehicleSeat` + `WeldConstraint`. Sem asset externo. Fácil de editar e suficiente para M002.
- **VehicleSeat nativo:** usando `.Steer` e `.Throttle` do VehicleSeat. Simples e funcional. Brake = Throttle negativo (S = ré/freio). Suficiente para M002.
- **Prompt BillboardGui:** o servidor spawna o prompt `[E] Entrar` junto com o carro. O `OnFootInputController` controla a visibilidade via `Heartbeat` baseado em distância.
- **Câmera Scriptable:** ao entrar no carro, muda para `CameraType.Scriptable` com `RenderStepped`. Ao sair, volta para `CameraType.Custom` (padrão Roblox do personagem).
- **DebugConfig:** `ShowInputHUD = false` por padrão. Para reativar o HUD de diagnóstico do G29, setar `true` em `DebugConfig.lua`.
- **InputContextController:** usa `humanoid.Seated` como fallback — se o personagem for sentar por qualquer outro meio, o contexto atualiza automaticamente.

---

## 5. Problemas / Dúvidas para o Arquiteto

| # | Ponto | Pergunta |
|---|-------|----------|
| 1 | `default.project.json` | O `src/server/services/` precisa estar mapeado no Rojo. Confirmar que está em `ServerScriptService`. Se não estiver, o VehicleSpawnService não rodará. |
| 2 | Câmera cockpit M003 | Quando entrar no carro com G29, a câmera cockpit já pode ser adicionada como modo 2? Ou só M004? |
| 3 | Múltiplos carros | VehicleSpawnService spawna só 1 carro fixo. Para M002, ok. Quando precisar de spawn dinâmico (garagem, vários carros)? |
| 4 | Saída do carro | Ao sair com `humanoid.Sit = false`, o personagem pode cair/travar dependendo da posição. Algum offset de ejeção necessário? |

---

## 6. Como Testar

1. Abrir terminal no VS Code → `rojo serve`
2. Roblox Studio → Plugins → Rojo → Connect
3. Confirmar estrutura no Explorer (ver `docs/milestone-002-placeholder-car.md`)
4. Clicar Play
5. Andar até o carro vermelho em (0, 3, 20)
6. Prompt [E] Entrar aparece ao aproximar
7. Pressionar E → entra → câmera muda
8. WASD controla o carro
9. Pressionar E → sai → personagem volta a andar

**Para ativar HUD do G29:**
Editar `src/shared/config/DebugConfig.lua` → `ShowInputHUD = true`

---

## 7. Próximo Passo Sugerido

**Validar M002 com teclado primeiro.**

Após confirmação do usuário que o loop funciona:

1. Mapear gamepad no `VehicleInputController` (leitura de Thumbstick1.X, ButtonR2, ButtonL2)
2. Ativar `ShowInputHUD = true` e testar G29 via x360ce
3. Atualizar `InputConfig.Axes` com eixos reais confirmados
4. Integrar eixos analógicos no `VehicleInputController` (substitui WASD para quem tem volante)
5. Decisão de câmera cockpit para M003

M002 está pronta para teste. Loop base existe. Aguardando validação do usuário.
