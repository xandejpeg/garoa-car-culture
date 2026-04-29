# Instrução 010 — M003 A-Chassis: Adapter implementado, próximo passo é importar o modelo

**Data:** 2025  
**Para:** Todos os modelos (Claude, ChatGPT, Opus)  
**Status:** M003 em andamento — código criado, falta importar modelo no Studio

---

## O que foi feito nesta sessão

### Pesquisa final do A-Chassis (Drive.luau + Initialize.luau)

Lemos o código-fonte completo dos dois scripts principais e descobrimos a estrutura real:

**Estrutura do A-Chassis Interface em PlayerGui:**
```
PlayerGui/
  A-Chassis Interface/          ← clonado pelo servidor quando jogador senta
    Drive (LocalScript)
      VirtualInput (BindableEvent)   ← AQUI injetamos input programático
    Car (ObjectValue) → carModel no Workspace
    Values/ (RPM, Gear, InputThrottle, InputBrake, SteerC, SteerT, PBrake...)
    Controls/ (mapeamento de teclas como StringValues)
    Mobile/ (UI mobile)
    IsOn (BoolValue)
```

**Modelo do carro no Workspace:**
```
CarModel/
  DriveSeat (VehicleSeat)          ← onde jogador senta
  Body/
    #Weight (Part)                 ← peso criado pelo Initialize no server
  Wheels/ (FL, FR, RL, RR)
    #AV (HingeConstraint Motor)    ← propulsão
    #BV (HingeConstraint Motor)    ← freio
    Arm, Base, Steer, AxleP...
  A-Chassis Tune (ModuleScript)
    README (ModuleScript) → retorna versão string
      Units (ModuleScript)
    Initialize (Script) ← roda no servidor quando modelo entra no Workspace
```

**Como o A-Chassis processa input (Drive.luau):**
- Input nativo: `UserInputService.InputBegan/Changed/Ended` para WASD e gamepad
- Input virtual: `VirtualInput.Event:Connect(DealWithInput)` — aceita InputObjects sintéticos
- Variáveis internas: `_IThrot` (0-1), `_IBrake` (0-1), `_GSteerT` (-1..1)
- Para gamepad analógico: `Position.X` para steer (Thumbstick1), `Position.Z` para throttle/brake (ButtonR2/L2)

---

## Código criado nesta sessão

### 1. `src/client/vehicle/VehicleControlAdapter.lua`
Interface genérica. Define: `enable(carModel)`, `disable()`, `setThrottle(0-1)`, `setBrake(0-1)`, `setSteering(-1..1)`, `setHandbrake(bool)`, `shiftUp()`, `shiftDown()`.

### 2. `src/client/vehicle/AChassisAdapter.lua`
Implementação concreta para A-Chassis v1.7+:
- `enable(carModel)`: busca `PlayerGui.A-Chassis Interface.Drive.VirtualInput` (aguarda até 5s se necessário)
- `setThrottle/setBrake/setSteering`: injeta via `VirtualInput:Fire()` com InputObjects sintéticos simulando gamepad (ButtonR2, ButtonL2, Thumbstick1)
- `disable()`: zera todos os inputs antes de desativar

### 3. `src/client/input/VehicleInputController.lua` (refatorado)
- `enable(seat, adapter?)`: aceita adapter opcional
- Loop de input preparado para M004 (gamepad analógico via adapter)
- Para M003 WASD: A-Chassis gerencia nativamente, VehicleInputController só detecta E para sair
- Removida escrita direta em `VehicleSeat.Steer` e `VehicleSeat.Throttle`

### 4. `src/shared/config/VehicleConfig.lua`
Configuração dos veículos disponíveis. Define `TestCar` como veículo padrão em `ReplicatedStorage.Vehicles`.

### 5. `src/server/services/VehicleSpawnService.server.lua` (atualizado)
- Primeiro tenta spawnar modelo A-Chassis de `ReplicatedStorage.Vehicles.TestCar`
- Fallback automático para placeholder M002 se modelo não estiver disponível
- Valida estrutura mínima (DriveSeat, Wheels, A-Chassis Tune)

---

## Próximos passos IMEDIATOS (para testar M003)

### Passo 1 — Importar modelo A-Chassis no Roblox Studio
```
Opção A (Toolbox):
  - Roblox Studio → View → Toolbox → Modelos
  - Pesquisar: "A-Chassis 1.7"
  - Asset ID: 13999609938
  - Inserir no lugar

Opção B (GitHub .rbxm):
  - Baixar: github.com/lisphm/A-Chassis/releases/tag/v1.7.2-stable
  - Arquivo: A-Chassis.rbxm
  - Studio → File → Insert from File
```

### Passo 2 — Mover para ReplicatedStorage
- No Explorer do Studio: arrastar modelo para `ReplicatedStorage`
- Criar pasta: `ReplicatedStorage.Vehicles`
- Renomear modelo para `TestCar`
- Resultado: `ReplicatedStorage.Vehicles.TestCar`

### Passo 3 — Aplicar fix de levitação (OBRIGATÓRIO)
O A-Chassis levita com Roblox 2024 density update. Fix no DevForum:
- Buscar: "Lower Minimum Part Density Rollout A-Chassis fix"
- Aplicar script de fix nas partes do carro

### Passo 4 — Testar
- Play test no Studio
- Verificar Output: "[VehicleSpawnService] A-Chassis spawned"
- Verificar: carro aparece no mundo com física
- Pressionar E perto do DriveSeat
- Verificar: jogador senta, câmera muda
- WASD: carro deve se mover com física real (suspensão, inércia)
- E de volta: jogador sai

---

## Critérios M003

| Critério | Status |
|----------|--------|
| Carro A-Chassis spawna no mapa | ⏳ Aguarda import no Studio |
| Fisica real visível (suspensão, inércia) | ⏳ |
| Entrada/saída com E funcionam | ⏳ |
| Camera segue o carro | ✅ (CameraController existente) |
| VehicleInputController usa adapter pattern | ✅ Código criado |
| Sem erros no Output | ⏳ |
| Sem levitação | ⏳ Requer fix |

---

## Arquitetura final confirmada

```
Garoa Systems (InputContextController)
      ↓
VehicleInputController (detecta E, loop gamepad M004)
      ↓
AChassisAdapter (injeta via VirtualInput)
      ↓
A-Chassis Drive.luau (physics loop 60Hz)
      ↓
Roblox Physics (HingeConstraints nas rodas)
```

---

## Notas técnicas importantes

1. **A-Chassis já tem gamepad nativo** — `ContlrSteer/Throttle/Brake`. Para M004, podemos usar o adapter OU simplesmente deixar o A-Chassis lidar com o gamepad físico.

2. **VirtualInput é BindableEvent** — não RemoteEvent. Só funciona do cliente para o Drive script (mesmo processo). Seguro e não expõe exploits.

3. **Drive script é clonado para PlayerGui** — não fica no carro. O Initialize.luau (server) clona `A-Chassis Interface` para `player.PlayerGui` quando o jogador senta no `DriveSeat`.

4. **O A-Chassis 1.7 tem fix de levitação incluído** via `GravComp` no Tune — mas pode precisar de ajuste manual dependendo da versão.
