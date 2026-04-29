# Arquitetura de Input — Garoa Car Culture

**Versão:** V5  
**Baseado em:** MD Master V5, Seções 5 e 7

---

## Decisão central

**Garoa Car Culture não é volante-only.**

| Dispositivo | Papel |
|---|---|
| Teclado + mouse | Base obrigatória |
| Controle / Gamepad | Suporte importante |
| Volante G29 via x360ce/XInput | Modo avançado / ideal de direção |

O jogo deve funcionar completo com teclado e mouse. O volante é uma camada adicional de imersão para direção.

---

## Arquitetura por contexto

O sistema de input é dividido em 4 contextos independentes:

```
InputSystem
├─ OnFootInput           (personagem fora do carro)
├─ VehicleInput          (personagem dentro do carro)
├─ GarageInput           (garagem / UI / oficina)
└─ InputDeviceMapper     (resolve dispositivo ativo → contexto)
```

### OnFootInput

Responsável por: movimento do personagem, câmera, interação com o mundo.

| Ação | Teclado | Gamepad |
|---|---|---|
| Andar | WASD | Thumbstick esquerdo |
| Câmera | Mouse | Thumbstick direito |
| Pular | Space | Button A |
| Interagir / entrar no carro | E | Button X |
| Correr | Shift (hold) | L3 ou trigger |

### VehicleInput

Responsável por: controle do carro enquanto o jogador está dentro.

| Ação | Teclado | Gamepad | Volante (x360ce) |
|---|---|---|---|
| Acelerar | W | R2 / Right Trigger | Pedal acelerador → R2 |
| Frear / Ré | S | L2 / Left Trigger | Pedal freio → L2 |
| Direção esquerda | A | Thumbstick1 X negativo | Volante → Thumbstick1 X |
| Direção direita | D | Thumbstick1 X positivo | Volante → Thumbstick1 X |
| Freio de mão | Space | Button A | Botão do volante → A |
| Trocar câmera | C ou V | Button Y | Botão do volante → Y |
| Sair do carro | E | Button X | Botão do volante → X |
| Shift up (futuro) | Q ou R | Button R1 | Paddle / botão → R1 |
| Shift down (futuro) | Z ou F | Button L1 | Paddle / botão → L1 |

### GarageInput

Responsável por: interação com a garagem, UI de peças, menus de tuning.

| Ação | Dispositivo |
|---|---|
| Navegar menus | Mouse / teclado / D-Pad |
| Selecionar peça | Clique / Enter / A |
| Cancelar | ESC / B |
| Inspecionar peça | Mouse hover / R3 |
| Instalar peça | E / Button X |

### InputDeviceMapper

Responsável por: detectar qual dispositivo está ativo e alimentar o contexto correto.

Lógica:
1. Detectar se há gamepad conectado (`UserInputService:GetConnectedGamepads()`)
2. Se gamepad presente → ativar mapeamento gamepad
3. Se não → usar teclado/mouse
4. Contexto atual (OnFoot / Vehicle / Garage) determina qual handler processa o input
5. Troca de contexto acontece ao entrar/sair do carro ou abrir garagem

---

## Fluxo de troca de contexto

```
Spawn do player
↓
OnFootInput ativo
↓
Jogador pressiona E perto do carro
↓
VehicleInput ativo (OnFootInput suspenso)
↓
Jogador pressiona E dentro do carro
↓
OnFootInput reativado
```

```
Jogador entra na garagem
↓
GarageInput ativo (VehicleInput / OnFootInput suspensos)
↓
Jogador sai da garagem
↓
Contexto anterior restaurado
```

---

## Mapeamento de teclado oficial (VehicleInput)

```
W         → Acelerar
S         → Frear / Ré
A         → Virar esquerda
D         → Virar direita
Space     → Freio de mão / handbrake
E         → Entrar / Sair do carro
C ou V    → Trocar câmera
Shift     → (futuro)
Ctrl      → (futuro)
Q / R     → Shift up (câmbio sequencial, futuro)
Z / F     → Shift down (câmbio sequencial, futuro)
```

---

## Prioridade de desenvolvimento

| Fase | Dispositivo | Status |
|---|---|---|
| M001 | InputTestHUD — diagnóstico de gamepad/XInput | Em andamento |
| M002 | Teclado como base do carro placeholder | Próximo |
| M002 | Personagem on-foot básico | Próximo |
| M002 | Troca de contexto (entrar/sair do carro) | Próximo |
| M003+ | Gamepad / controle | Após M002 |
| M003+ | Volante G29 via x360ce calibrado | Após M002 |

---

## InputTestHUD — papel revisado

O InputTestHUD **não é bloqueador** do carro placeholder.

Ele é uma ferramenta de diagnóstico que:
- valida se x360ce + Roblox estão funcionando
- descobre eixos reais do gamepad
- calibra deadzone e sensibilidade
- prepara a camada avançada de volante

O desenvolvimento do carro placeholder (M002) pode iniciar em paralelo usando teclado.

---

## Arquivos de implementação

| Arquivo | Responsabilidade |
|---|---|
| `src/client/input/InputContextController.client.lua` | Orquestrador — gerencia contexto ativo |
| `src/client/input/OnFootInputController.lua` | Input do personagem a pé |
| `src/client/input/VehicleInputController.lua` | Input dentro do carro |
| `src/client/input/GarageInputController.lua` | Input na garagem/UI |
| `src/client/input/InputDeviceMapper.lua` | Detecta dispositivo, resolve bindings |
| `src/shared/config/InputConfig.lua` | Todas as configurações e mapeamentos |
| `src/client/input/InputTestHUD.client.lua` | Diagnóstico de gamepad (ferramenta) |
