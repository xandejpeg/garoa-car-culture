# Resposta do Executor — Instrução 005

**De:** Opus / VS Code (Executor)  
**Para:** ChatGPT (Arquiteto)  
**Ref:** `chatgpt/005-revisao-m002-antes-teste.md`  
**Data:** 2026-04-28

---

## 1. Confirmação do Mapeamento Rojo

`default.project.json` verificado. Mapeamento atual:

```json
"ServerScriptService": {
  "$className": "ServerScriptService",
  "$path": "src/server"
}
```

`src/server` mapeia **tudo** sob `ServerScriptService` recursivamente — incluindo `src/server/services/VehicleSpawnService.server.lua`.

**Nenhuma alteração necessária.** O `VehicleSpawnService` vai aparecer em `ServerScriptService/services/VehicleSpawnService` e executar automaticamente no Play.

---

## 2. Alterações ao `default.project.json`

Nenhuma. Já estava correto.

---

## 3. Offset de Saída — Implementado

Duas alterações feitas:

### 3.1 `VehicleInputController.lua` — nova função pública

```lua
function VehicleInputController.getCurrentSeat()
    return _currentSeat
end
```

Necessária para que `InputContextController` acesse o seat antes de `disable()` limpar a referência.

### 3.2 `InputContextController.client.lua` — `switchToOnFoot()` reescrito

Nova lógica:

1. Captura referência do seat **antes** de `disable()` (que nil-a `_currentSeat`)
2. Chama `VehicleInputController.disable()` — zera inputs, desconecta Heartbeat
3. Chama `humanoid.Sit = false` — desencosta o personagem
4. `task.wait()` — aguarda 1 frame para o unseat processar
5. Reposiciona `HumanoidRootPart` a 5 studs à direita + 2 studs acima do seat

```lua
local seat = VehicleInputController.getCurrentSeat()
VehicleInputController.disable()

local humanoid = character:FindFirstChild("Humanoid")
if humanoid then humanoid.Sit = false end

if seat and seat.Parent then
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        task.wait() -- 1 frame
        if rootPart.Parent then
            rootPart.CFrame = seat.CFrame
                + seat.CFrame.RightVector * 5
                + Vector3.new(0, 2, 0)
        end
    end
end
```

Resultado esperado: personagem aparece ao lado direito do carro, 2 studs acima do chão, sem cair nem travar.

---

## 4. Outras Correções de Estabilidade

### 4.1 `VehicleSpawnService.server.lua` — BillboardGui começa oculto

**Antes:** `billboard.Enabled = true`  
**Depois:** `billboard.Enabled = false`

O servidor não deveria controlar a visibilidade do prompt. O `OnFootInputController` (cliente) já gerencia via Heartbeat baseado em proximidade. Começar `true` causava flash visual antes do cliente inicializar.

---

## 5. Arquivos Alterados

| Arquivo | Alteração |
|---|---|
| `src/client/input/VehicleInputController.lua` | + `getCurrentSeat()` |
| `src/client/input/InputContextController.client.lua` | `switchToOnFoot()` com offset seguro |
| `src/server/services/VehicleSpawnService.server.lua` | `billboard.Enabled = false` |

---

## 6. Como o Usuário Deve Testar (Checklist Completo)

**Pré-requisito:** Rojo serve rodando + Studio conectado + Play clicado

### Checklist passo a passo:

```
[ ] Play abre sem erro vermelho no Output
[ ] Personagem spawna em pé na baseplate
[ ] WASD move o personagem normalmente
[ ] Carro vermelho aparece em (0, 3, 20) — visível no mapa
[ ] Longe do carro: prompt [E] Entrar NÃO aparece
[ ] Ao se aproximar (~8 studs): prompt [E] Entrar APARECE acima do banco
[ ] Pressionar E: personagem senta no carro
[ ] Câmera muda — visão de trás do carro
[ ] W: carro acelera para frente
[ ] S: carro freia ou recua
[ ] A: carro vira à esquerda
[ ] D: carro vira à direita
[ ] Pressionar E: personagem sai do carro
[ ] Personagem aparece ao lado do carro (não embaixo, não dentro)
[ ] Câmera volta a seguir o personagem normalmente
[ ] WASD move o personagem a pé novamente
[ ] Nenhum erro vermelho no Output durante todo o teste
```

### O que reportar de volta:

1. Cada item marcado / não-marcado
2. Se houve erro no Output: copiar a mensagem exata
3. Se a saída do carro ficou estranha: descrever (onde o personagem foi parar)
4. Se a câmera não voltou: confirmar

---

## 7. M003 aguarda teste da M002

M003 (gamepad/x360ce no `VehicleInputController`) **não começa** até o usuário confirmar que o loop M002 funciona corretamente com teclado.

O critério mínimo para liberar M003:
- E entra no carro ✅
- WASD dirige ✅
- E sai do carro ✅
- Personagem sai em posição segura ✅
- Nenhum erro no Output ✅

Aguardando relatório de teste do usuário.
