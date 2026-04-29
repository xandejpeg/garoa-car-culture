# Decisão: Física Veicular — VehicleSeat vs A-Chassis

**Projeto:** Garoa Car Culture  
**Versão:** 1.0  
**Data:** 2026-04-28  
**Status:** Decisão tomada — A-Chassis aprovado como base candidata

---

## 1. Contexto

Durante o teste da M002, o carro placeholder construído sobre `VehicleSeat` nativo do Roblox não se moveu conforme esperado. Investigação identificou que o problema vai além de um valor de Torque — o `VehicleSeat` nativo é fundamentalmente limitado para um jogo de car culture com drift.

---

## 2. Limitações do VehicleSeat nativo

| Limitação | Impacto no Garoa |
|---|---|
| Sem suspensão real | Carro pula/treme em terreno irregular |
| Física simples de torque | Sem feeling de aceleração/peso/inércia |
| Sem câmbio | Sem marcha, sem motor, sem som de RPM |
| Sem drift nativo | Impossível simular oversteer realista |
| Sem handbrake | Sem freio de mão para drift |
| Valores limitados | MaxSpeed/TurnSpeed/Torque são grosseiros |
| Sem tuning de física | Impossível ajustar suspensão, rigidez, camber |

**Conclusão:** `VehicleSeat` nativo serve para protótipos simples. Não serve como base para Garoa Car Culture.

---

## 3. Decisão oficial

### 3.1 VehicleSeat descartado como base de movimento principal

O `VehicleSeat` nativo está descartado como fundação física do jogo.

Pode continuar existindo no modelo do carro como interface de entrada do jogador (hitbox/seat), mas não como motor de física.

### 3.2 A-Chassis aprovado como base candidata

**A-Chassis** (`github.com/lisphm/A-Chassis`) aprovado como base candidata de física veicular.

Status: **candidata** — precisa de protótipo antes de ser considerada definitiva.

Critérios para A-Chassis virar definitivo:
- [ ] Carro anda bem por teclado
- [ ] Aceita adaptação do input modular do Garoa
- [ ] Aceita tuning de valores (drift, suspensão, câmbio)
- [ ] Pode ser modularizado sem virar caixa-preta
- [ ] Funciona com Rojo sem quebrar o pipeline
- [ ] Performance aceitável em multiplayer
- [ ] Compatível com pipeline de carros (Meshy → Roblox Bridge → A-Chassis)

---

## 4. Arquitetura de camadas

O A-Chassis **não domina** o projeto inteiro. É apenas a fundação física.

```
Garoa Systems
(input, progressão, economia, UI, tuning macro, garagem)
        ↓
Vehicle Abstraction Layer
(VehicleControlAdapter — comandos genéricos)
        ↓
AChassisAdapter
(tradução de comandos genéricos → A-Chassis API)
        ↓
A-Chassis
(motor de física: suspensão, câmbio, drift, peso)
        ↓
Roblox Physics Engine
```

O Garoa continua dono de:
- Input (teclado, gamepad, volante)
- Progressão e economia
- Garagem e tuning macro
- UI e HUD
- Mapas e tráfego
- Identidade cultural brasileira
- Multiplayer

---

## 5. Impacto no VehicleInputController

O `VehicleInputController` atual escreve diretamente em `VehicleSeat.Throttle` e `VehicleSeat.Steer`.

Isso precisará ser refatorado para uma interface de comandos genéricos:

**Comandos genéricos (agnósticos de chassis):**
- `steer`: -1 a 1
- `throttle`: 0 a 1
- `brake`: 0 a 1
- `handbrake`: 0 a 1
- `shiftUp`: boolean
- `shiftDown`: boolean
- `exitVehicle`: boolean

O `AChassisAdapter` traduz esses comandos para a API interna do A-Chassis.

---

## 6. O que não muda

A identidade e visão do Garoa Car Culture permanecem intactas:

- Drift no estilo No Hesi / Midnight Racing: Tokyo
- São Paulo e cultura automotiva brasileira
- Evolução de carro, tuning, garagem
- Suporte a G29 via x360ce / RoWheel Bridge (futuro)
- Experiência acessível: teclado + controle + volante

A-Chassis é apenas a fundação técnica. O produto continua sendo Garoa.

---

## 7. Referências

- Repositório oficial: `github.com/lisphm/A-Chassis`
- DevForum: [Is A-Chassis reliable enough?](https://devforum.roblox.com)
- Plano de integração: `docs/a-chassis-integration-plan.md`
- Pesquisa open source: `docs/open-source-research.md`
