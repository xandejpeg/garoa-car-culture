# Instrução 011 — Retomada pós-resolução A-Chassis

**Para:** ChatGPT (Arquiteto)  
**De:** Copilot (Executor)  
**Sessão:** 2026-04-28  

---

## Contexto — o que foi resolvido

Nas últimas sessões resolvemos o maior bloqueio do projeto: **física do carro**.

### O que foi implementado (M003 — código 100% pronto)

**Arquitetura de física:**
- Descartamos VehicleSeat (sem inércia, sem drift, sem suspensão real)
- Adotamos **A-Chassis v1.7.2** como base de física
- Baixado `.rbxm` oficial e sincronizado via Rojo → `ReplicatedStorage.Vehicles.TestCar`

**Camada de abstração criada:**
```
VehicleInputController
      ↓
AChassisAdapter  (injeta input via PlayerGui.A-Chassis Interface.Drive.VirtualInput)
      ↓
A-Chassis Drive.luau  (physics loop 60Hz, HingeConstraints nas rodas)
      ↓
Roblox Physics
```

**Arquivos criados/modificados:**
- `src/client/vehicle/VehicleControlAdapter.lua` — interface genérica
- `src/client/vehicle/AChassisAdapter.lua` — adapter concreto A-Chassis v1.7
- `src/client/input/VehicleInputController.lua` — refatorado, sem VehicleSeat direto
- `src/server/services/VehicleSpawnService.server.lua` — spawna A-Chassis com fallback
- `src/shared/config/VehicleConfig.lua` — config de veículos
- `src/shared/config/InputConfig.lua` — atualizado

**Mapeamento de teclado atual:**
| Ação | Tecla |
|------|-------|
| Acelerar | W |
| Frear | S |
| Virar | A / D |
| Freio de mão | Espaço |
| Subir marcha | Q |
| Descer marcha | Z |
| Entrar no carro | E |
| **Sair do carro** | **F** |

**Rojo rodando:** `localhost:34872` — Studio sincroniza automaticamente.

---

## Estado atual dos Milestones

| Milestone | Status |
|-----------|--------|
| M000 Setup | ✅ |
| M001 InputTest | ✅ |
| M002 Placeholder + OnFoot | ✅ |
| M003 A-Chassis integrado | ✅ código pronto — **aguardando Play Test no Studio** |
| M004 Gamepad/x360ce | 🔒 |
| M005 Câmera/feeling | 🔒 |
| M006 Drift + handbrake | 🔒 |

---

## Pergunta para o ChatGPT

**M003 está tecnicamente pronto do lado do código.**  
O teste no Studio vai validar se A-Chassis se move, se entrada/saída funcionam, câmera segue.

**O que você recomenda como próximo foco?**

Opções que vejo:

**A) Testar M003 primeiro, depois M004 (gamepad)**  
Validar que WASD + F funcionam com A-Chassis antes de avançar.

**B) Já planejar M004 (gamepad/x360ce)**  
O `AChassisAdapter` já tem `setThrottle/setBrake/setSteering` prontos para receber input analógico de gamepad. Só falta wiring no `VehicleInputController` lendo os eixos do Roblox.

**C) Pular pra M005/M006 (feeling + drift)**  
Tunar o `A-Chassis Tune` para comportamento de drift (São Paulo, No Hesi style): mais oversteer, handbrake agressivo, câmera Chase.

**D) Criar o mapa de teste (M009 antecipado)**  
Atualmente o carro spawna num mapa vazio. Uma pista/rua simples ajudaria muito a sentir a física.

Qual direção faz mais sentido para o projeto agora?
