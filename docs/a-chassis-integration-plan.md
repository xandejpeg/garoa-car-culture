# Plano de Integração: A-Chassis

**Projeto:** Garoa Car Culture  
**Versão:** 1.0  
**Data:** 2026-04-28  
**Status:** Planejamento — implementação em M003

---

## 1. Objetivo da M003

Criar um carro A-Chassis mínimo funcional no projeto Garoa, com:

- Carro se movendo com física real (suspensão, inércia, peso)
- Input por teclado (WASD) controlando o carro via adapter
- Entrada e saída do carro preservadas
- Câmera simples mantida
- Rojo funcionando corretamente

**Não fazer na M003:**
- Drift final ajustado
- Câmbio manual
- Garagem
- Tuning profundo
- Gamepad/G29
- Multiplayer

---

## 2. Estrutura de arquivos planejada

```
src/
  client/
    vehicle/
      VehicleControlAdapter.lua     ← interface genérica de comandos
      AChassisAdapter.lua           ← traduz comandos → A-Chassis API
      NativeVehicleSeatAdapter.lua  ← fallback para dev (não será principal)
    input/
      VehicleInputController.lua    ← refatorar: lê input, envia para adapter
    camera/
      CameraController.lua          ← manter sem mudanças
  server/
    services/
      VehicleSpawnService.server.lua ← adaptar para spawnar modelo A-Chassis
shared/
  config/
    VehicleConfig.lua               ← valores de tuning do carro (novo)
```

---

## 3. Como importar A-Chassis

### Opção A — Via Toolbox (mais simples para começar)
1. Abrir Roblox Studio
2. Toolbox → buscar "A-Chassis"
3. Inserir modelo no Workspace
4. Estudar estrutura de arquivos dentro do modelo
5. Exportar scripts para `src/` mantendo compatibilidade com Rojo

### Opção B — Via GitHub
1. Clonar `github.com/lisphm/A-Chassis`
2. Copiar scripts relevantes para `src/shared/vehicle/achassis/`
3. Adaptar paths para estrutura do Rojo
4. Verificar se há dependências externas

**Recomendação:** começar com Opção A para entender a estrutura, depois migrar para Opção B para manter no controle de versão.

---

## 4. Mapeamento do input

### Hoje (VehicleInputController → VehicleSeat)
```lua
-- direto no VehicleSeat
seat.Steer = steerAxis
seat.Throttle = throttleAxis - brakeAxis
```

### M003 (VehicleInputController → adapter → A-Chassis)
```lua
-- VehicleInputController normaliza comandos
local commands = {
    steer    = getSteerAxis(),     -- -1 a 1
    throttle = getThrottleAxis(),  -- 0 a 1
    brake    = getBrakeAxis(),     -- 0 a 1
    handbrake = false,
    shiftUp  = false,
    shiftDown = false,
}

-- VehicleControlAdapter envia para o adapter ativo
_adapter:applyCommands(commands)

-- AChassisAdapter traduz para A-Chassis
function AChassisAdapter:applyCommands(commands)
    -- chamar API interna do A-Chassis
    -- (será definido após pesquisa do A-Chassis)
end
```

---

## 4.5 Como o A-Chassis recebe input (descoberta da pesquisa)

O A-Chassis **não usa VehicleSeat.Throttle/Steer**. Ele usa:

- `_IThrot` (0-1), `_IBrake` (0-1), `_GSteerT` (-1 a 1) — variáveis internas do Drive script
- Input nativo via `UserInputService` (já mapeado para WASD + gamepad)
- **`VirtualInput.Event`** — BindableEvent dentro do Drive que aceita `InputObject` sintético

```
VirtualInput.Event:Connect(DealWithInput)
-- Podemos disparar VirtualInput:Fire(inputObject) para injetar input
```

O A-Chassis **já suporta gamepad nativamente** (`ContlrSteer`, `ContlrThrottle`, `ContlrBrake` via axes). Isso simplifica M004.

**Onde os scripts vivem:** dentro do modelo do carro no Workspace, não em StarterPlayerScripts. São ativados quando o jogador senta no DriveSeat.

**Estrutura interna do modelo:**
```
CarModel/
  A-Chassis Tune (ModuleScript — tune values + Interface/Values)
  Body/
    #Weight (Part)
    DriveSeat (VehicleSeat — apenas para sentar, não para física)
  Wheels/ (FL, FR, RL, RR com #AV AngularVelocity motor e #BV brake motor)
  Drive (LocalScript — lógica de input e física cliente)
  Initialize (Script — setup server-side)
  Plugins/ (sons, câmera, gauges, etc)
```

**Implicação para AChassisAdapter:** Podemos injetar controles via `VirtualInput:Fire()` com InputObjects simulados, ou simplesmente deixar o A-Chassis usar seu input nativo (WASD já mapeado) e usar o nosso VehicleInputController apenas para lógica de entrada/saída do carro.

---

## 5. Interface VehicleControlAdapter

```lua
-- src/client/vehicle/VehicleControlAdapter.lua

local VehicleControlAdapter = {}
VehicleControlAdapter.__index = VehicleControlAdapter

function VehicleControlAdapter.new(adapterImpl)
    return setmetatable({ _impl = adapterImpl }, VehicleControlAdapter)
end

function VehicleControlAdapter:applyCommands(commands)
    -- commands = { steer, throttle, brake, handbrake, shiftUp, shiftDown }
    self._impl:applyCommands(commands)
end

function VehicleControlAdapter:enable(vehicleModel)
    self._impl:enable(vehicleModel)
end

function VehicleControlAdapter:disable()
    self._impl:disable()
end

return VehicleControlAdapter
```

---

## 6. Onde colocar os scripts do A-Chassis

Os scripts do A-Chassis são principalmente **server-side** (físicos) e **shared** (configuração).

Estrutura sugerida:
```
src/
  server/
    vehicle/
      achassis/          ← scripts internos do A-Chassis (não editar)
  shared/
    vehicle/
      achassis/          ← módulos compartilhados do A-Chassis
      AChassisConfig.lua ← valores de tuning expostos para o Garoa
  client/
    vehicle/
      AChassisAdapter.lua ← nossa camada de adaptação (SIM editar)
```

---

## 7. Rojo — considerações

O `default.project.json` mapeia:
- `src/server/` → `ServerScriptService` (recursivo)
- `src/client/` → `StarterPlayerScripts` (recursivo)
- `src/shared/` → `ReplicatedStorage/Shared` (recursivo)

Scripts do A-Chassis que precisam estar no servidor devem ir em `src/server/vehicle/achassis/`.

Scripts que precisam ser acessados pelo cliente devem ir em `src/shared/vehicle/achassis/`.

**Risco:** A-Chassis pode ter uma estrutura hierárquica que depende de parenting específico no Workspace. Verificar isso durante a pesquisa.

---

## 8. Riscos identificados

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| A-Chassis usa hierarquia de Workspace hardcoded | Média | Alto | Verificar e adaptar paths |
| Scripts do A-Chassis difíceis de separar/modularizar | Média | Alto | Estudar antes de integrar |
| Input do A-Chassis usa eventos próprios, não VehicleSeat | Alta | Médio | Criar AChassisAdapter |
| Performance ruim com muitos carros | Baixa | Médio | Testar com 1 carro primeiro |
| Conflito com Rojo (arquivos .rbxmx vs .lua) | Baixa | Alto | Preferir Opção B (GitHub) |
| A-Chassis tem bugs conhecidos de "levitação" | Alta | Médio | Ver fix no DevForum (2024) |

### Sobre o bug de levitação (A-Chassis)
Em 2024, Roblox lançou atualização de densidade mínima de partes que causou levitação em modelos A-Chassis. Existe um script de fix para Studio. Documentado em DevForum. Aplicar antes de testar.

---

## 9. Critérios de sucesso da M003

- [ ] Carro A-Chassis spawna no mapa via Rojo
- [ ] Carro se move com WASD (teclado)
- [ ] Física real: inércia, peso, suspensão visível
- [ ] Entrada e saída funcionam
- [ ] Câmera segue o carro
- [ ] Sem erros no Output do Studio
- [ ] `VehicleInputController` usa adapter, não VehicleSeat diretamente
- [ ] Código do A-Chassis não invadiu camadas do Garoa

---

## 10. O que vem depois (M004+)

- M004: gamepad/x360ce com input adapter
- M005: ajuste de feeling (drift básico, câmera melhor)
- M006+: câmbio manual, handbrake, tuning de drift, G29/RoWheel

---

## 11. Referências

- `docs/vehicle-physics-decision.md` — decisão VehicleSeat vs A-Chassis
- `docs/open-source-research.md` — tabela de projetos pesquisados
- `github.com/lisphm/A-Chassis` — repositório oficial
- DevForum 2024 fix: "Lower Minimum Part Density Rollout" — fix para levitação
