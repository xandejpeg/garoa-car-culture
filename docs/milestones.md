# Milestones — Garoa Car Culture

**Versão:** V6  
**Baseado em:** MD Master V5 + decisão arquitetural 009 (A-Chassis)  
**Atualizado:** 2026-04-28

---

## Visão geral

| Milestone | Nome | Status |
|---|---|---|
| M000 | Setup e estrutura | ✅ Concluído |
| M001 | Input Test + Diagnóstico | ✅ Concluído estruturalmente |
| M002 | Carro placeholder por teclado + On-foot | ✅ Concluído estruturalmente |
| M003 | Pesquisa + Protótipo mínimo A-Chassis | 🔄 Em andamento |
| M004 | Gamepad/x360ce com A-Chassis | 🔒 Bloqueado |
| M005 | Feeling inicial + câmera | 🔒 Bloqueado |
| M006 | Drift básico + handbrake | 🔒 Bloqueado |
| M007 | Garagem simples | 🔒 Bloqueado |
| M008 | No Hesi loop + Dinheiro básico | 🔒 Bloqueado |
| M009 | Rodovia MVP + Tráfego simples | 🔒 Bloqueado |
| M010 | G29 avançado + RoWheel Bridge | 🔒 Bloqueado |
| M011 | Expansão (cidade, hub, portais) | 🔒 Bloqueado |

---

## M000 — Setup e estrutura ✅

**Objetivo:** ambiente de desenvolvimento funcional.

**Entregue:**
- Estrutura de pastas `src/`, `docs/`, `assets/`, `comunicacao-ia/`
- `default.project.json` (Rojo)
- `README.md` e `.gitignore`
- Documentação inicial (`docs/setup-rojo.md`, `docs/setup-x360ce.md`)
- Protocolo de comunicação IA

**Critério de sucesso:**
- ✅ Estrutura criada
- ⏳ Rojo conectando no Roblox Studio (pendente teste do usuário)

---

## M001 — Input Test + Diagnóstico ✅

**Objetivo:** validar que o Roblox recebe inputs de gamepad/XInput corretamente.

**Entregue:**
- `src/client/input/InputTestHUD.client.lua` — HUD de diagnóstico em tempo real
- `src/shared/config/InputConfig.lua` — configuração de eixos/botões V5
- `src/shared/config/DebugConfig.lua` — flags de debug
- `docs/milestone-001-checklist.md`

**Status:** ✅ Concluído estruturalmente. HUD criado, input V5 arquitetado.

---

## M002 — Carro placeholder + On-foot ✅

**Objetivo:** carro básico jogável por teclado e personagem andando fora do carro.

**Entregue:**
- `src/server/services/VehicleSpawnService.server.lua` — spawna carro placeholder
- `src/client/input/OnFootInputController.lua` — input a pé + prompt de entrada
- `src/client/input/VehicleInputController.lua` — input no carro (teclado)
- `src/client/input/InputContextController.client.lua` — troca de contexto
- `src/client/camera/CameraController.lua` — câmera básica
- `docs/milestone-002-placeholder-car.md`

**Resultado do teste:**
- ✅ Personagem spawnou e andou com WASD
- ✅ Carro vermelho apareceu no mapa
- ✅ Prompt [E] Entrar apareceu ao se aproximar
- ✅ E pressionado → entrou no carro
- ✅ Câmera mudou ao entrar
- ❌ Carro não se moveu — VehicleSeat nativo insuficiente para drift/car culture
- ⏳ Saída não chegou a ser testada (física bloqueou antes)

**Conclusão:** M002 concluída **estruturalmente**. Loop de interação (on-foot → enter → vehicle) funciona. VehicleSeat descartado como base física. A-Chassis aprovado como substituto.

**Ver:** `docs/vehicle-physics-decision.md`

---

## M003 — Pesquisa + Protótipo mínimo A-Chassis 🔄

**Desbloqueado:** M002 concluída estruturalmente.

**Objetivo:** integrar A-Chassis como base de física, carro se movendo com teclado.

**Escopo:**
- Estudar estrutura do A-Chassis (`github.com/lisphm/A-Chassis`)
- Importar A-Chassis para o projeto via Rojo
- Criar `VehicleControlAdapter` e `AChassisAdapter`
- Refatorar `VehicleInputController` para usar adapter (não mais VehicleSeat direto)
- Spawnar carro A-Chassis mínimo no mapa
- Testar: entrar → dirigir com WASD → sair
- Documentar API de input do A-Chassis

**Não fazer na M003:**
- Drift final
- Câmbio manual
- Gamepad/G29
- Garagem, tuning profundo, multiplayer

**Ver:** `docs/a-chassis-integration-plan.md`, `docs/open-source-research.md`

**Critério de sucesso:**
- Carro A-Chassis se move com WASD
- Física real visível (inércia, peso)
- Entrada/saída funcionam
- Câmera segue o carro
- Sem erros no Output

---

## M004 — Gamepad/x360ce com A-Chassis 🔒

**Desbloqueado quando:** M003 validado (carro A-Chassis funcional por teclado).

**Objetivo:** input de gamepad via x360ce funcionando no A-Chassis.

---

## M005 — Feeling inicial + câmera 🔒

**Desbloqueado quando:** M004 validado.

**Objetivo:** câmera polida, feeling de direção melhorado, ajustes básicos de drift.

---

## M006 — Drift básico + handbrake 🔒

**Desbloqueado quando:** M005 validado.

**Objetivo:** drift jogável, handbrake, oversteer controlado.

---

## M007 — Garagem simples 🔒

**Desbloqueado quando:** M006 validado.

---

## M008 — No Hesi loop + Dinheiro básico 🔒

**Desbloqueado quando:** M007 validado.

---

## M009 — Rodovia MVP + Tráfego simples 🔒

**Desbloqueado quando:** M008 validado.

---

## M010 — G29 avançado + RoWheel Bridge 🔒

**Desbloqueado quando:** M009 validado.

**Ver:** `docs/open-source-research.md` (seção RoWheel Bridge)

---

## M011 — Expansão (cidade, hub, portais) 🔒

**Desbloqueado quando:** M010 validado.
- Combo acumulado
- Dinheiro exibido no HUD
- Reset de combo ao bater
- HUD de velocidade + ganho

**Critério de sucesso:**
- 5 minutos de gameplay divertido com o loop básico

---

## M005 — Multiplayer pequeno 🔒

**Desbloqueado quando:** M004 validado.

**Objetivo:** testar sincronização de carros.

**Escopo:**
- 2 players
- Depois 5, 10, 20
- Sync básico de posição
- Análise de impacto no FPS

---

## M006 — Garagem simples 🔒

**Desbloqueado quando:** M005 validado.

**Objetivo:** primeira interface de garagem com troca de peça e persistência.

---

## M007 — Tuning inicial 🔒

**Desbloqueado quando:** M006 validado.

**Objetivo:** tuning que muda comportamento real do carro.

---

## M008 — Expansão 🔒

**Desbloqueado quando:** M007 validado.

**Objetivo:** cidade, hub, portais, mais carros, economia completa, monetização.

---

## Regra de desbloqueio

Nenhuma milestone pode ser iniciada sem a anterior validada em teste prático pelo usuário e aprovada pelo ChatGPT.

Exceção: M001 e M002 podem ocorrer em paralelo (M001 = diagnóstico de volante, M002 = carro por teclado).
