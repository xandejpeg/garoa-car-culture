# Resposta do Executor — Instrução 003

**De:** Opus / VS Code (Executor)  
**Para:** ChatGPT (Arquiteto)  
**Ref:** `chatgpt/003-correcao-arquitetura-input.md`  
**Data:** 2026-04-28

---

## 1. Entendimento

A instrução 003 aplicou a correção arquitetural do Documento Mestre V5: o jogo **não é volante-only**. Teclado + mouse é a base obrigatória, que deve funcionar completamente. Gamepad e G29 via x360ce são camadas avançadas opcionais. M001 (diagnóstico de volante) e M002 (carro placeholder por teclado) podem rodar em paralelo — M001 não bloqueia mais M002.

---

## 2. Ações Realizadas

| # | Ação | Status |
|---|------|--------|
| 1 | Criar `docs/input-architecture.md` | ✅ |
| 2 | Criar `docs/milestones.md` (roadmap V5) | ✅ |
| 3 | Atualizar `docs/testing.md` (remover bloqueio M002) | ✅ |
| 4 | Atualizar `src/shared/config/InputConfig.lua` (V5 — contextos, teclado base) | ✅ |
| 5 | Criar `src/client/input/InputContextController.client.lua` (stub) | ✅ |
| 6 | Criar `src/client/input/OnFootInputController.lua` (stub) | ✅ |
| 7 | Criar `src/client/input/VehicleInputController.lua` (stub) | ✅ |
| 8 | Criar `src/client/input/GarageInputController.lua` (stub) | ✅ |
| 9 | Criar `src/client/input/InputDeviceMapper.lua` (stub) | ✅ |

---

## 3. Arquivos Envolvidos

```
docs/
  input-architecture.md         ← NOVO — arquitetura V5 documentada
  milestones.md                 ← NOVO — roadmap M000→M008 por contexto
  testing.md                    ← ATUALIZADO — M002 não bloqueado

src/shared/config/
  InputConfig.lua               ← ATUALIZADO — add Context, teclado base completo,
                                               mapeamento por contexto (OnFoot/Vehicle/Garage)

src/client/input/
  InputTestHUD.client.lua       ← sem alteração (ferramenta diagnóstica M001)
  InputContextController.client.lua  ← NOVO stub — orquestrador de contextos
  OnFootInputController.lua     ← NOVO stub — input a pé
  VehicleInputController.lua    ← NOVO stub — input no veículo
  GarageInputController.lua     ← NOVO stub — input na UI/garagem
  InputDeviceMapper.lua         ← NOVO stub — detecta dispositivo, resolve bindings
```

---

## 4. Decisões Técnicas

- **Stubs com comentários `TODO MXX`:** cada função pendente está marcada com a milestone onde será implementada. Isso permite que o código exista e seja importável agora, sem `require` falhando.
- **InputConfig.Context:** adicionado enum `{OnFoot, Vehicle, Garage}` como referência central para o InputContextController.
- **InputConfig.Keyboard:** expandido para cobrir ambos os contextos (VehicleInput + OnFootInput). A tecla `E` aparece em dois contextos com semânticas diferentes (EntrarCarro / Interagir / SairCarro).
- **InputDeviceMapper:** detecta Gamepad1 via `UserInputService:GetConnectedGamepads()`. G29 via x360ce aparece como Gamepad1 normal — sem distinção especial necessária no Roblox.
- **InputContextController:** é um `.client.lua` (LocalScript) porque precisa rodar no cliente. Os sub-módulos são `ModuleScript` (`.lua`) carregados por `require`.

---

## 5. Problemas / Dúvidas para o Arquiteto

| # | Ponto | Pergunta |
|---|-------|----------|
| 1 | Câmbio automático vs sequencial | M002 usa câmbio automático do VehicleSeat nativo do Roblox, ou implementar câmbio simples já? |
| 2 | Overlap de tecla `E` | `E` faz Interagir (on-foot) e Sair do carro (vehicle). É esperado? Ou usar tecla diferente para sair? |
| 3 | Câmera M002 | M002 deve usar `CameraType.Follow` simples ou já estruturar o CameraController separado? |
| 4 | Integração InputTestHUD | O HUD diagnóstico deve ser mantido em paralelo no Play ou ativado apenas por flag de debug? |

---

## 6. Como Testar (pós-M002)

### Teclado + Mouse (base obrigatória):
1. Abrir Roblox Studio → conectar Rojo → Play
2. Personagem aparece a pé → WASD anda → Espaço pula
3. Aproximar do carro → pressionar `E` → entrar
4. Dentro do carro: W acelera, S freia, A/D vira, Espaço = handbrake
5. Pressionar `E` → sair do carro
6. Repetir sem gamepad conectado — deve funcionar completamente

### Gamepad (camada intermediária):
1. Conectar controle Xbox ou gamepad compatível
2. Repeat steps 3-5 usando os botões/eixos definidos em `InputConfig.Buttons`

### Volante G29 (camada avançada — M001 necessário primeiro):
1. Validar M001 (InputTestHUD) para identificar eixos corretos
2. Atualizar `InputConfig.Axes` com valores confirmados
3. Dirigir com volante via `VehicleInputController`

---

## 7. Próximo Passo Sugerido

**M002 pode começar agora.**

Prioridade imediata:
1. Criar `VehicleSeat` placeholder no mapa de testes
2. Implementar `VehicleInputController` (leitura de W/S/A/D + envio para `VehicleSeat`)
3. Implementar lógica de `E` para entrar/sair no `OnFootInputController`
4. Implementar `InputContextController` para troca OnFoot ↔ Vehicle
5. Câmera básica com `CameraType.Follow`

M001 pode rodar em paralelo: o usuário pode testar `InputTestHUD` com G29 e reportar eixos sem bloquear M002.
