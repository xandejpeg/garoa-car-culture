# Milestones — Garoa Car Culture

**Versão:** V14  
**Baseado em:** MD Master V5 + decisão arquitetural 009 (A-Chassis) + 017 (Paulista Prototype) + 019 (câmera/feeling) + 025 (tire smoke) + 026 (drift score) + 028 (M008-lite passou)  
**Atualizado:** 2026-04-30

---

## Visão geral

| Milestone | Nome | Status |
|---|---|---|
| M000 | Setup e estrutura | ✅ Concluído |
| M001 | Input Test + Diagnóstico | ✅ Concluído estruturalmente |
| M002 | Carro placeholder por teclado + On-foot | ✅ Concluído estruturalmente |
| M003 | A-Chassis integrado | ✅ PASSOU 29/04/2026 |
| M003.5 | Test Track sintético | ✅ PASSOU 29/04/2026 |
| M003.6 | Avenida Paulista Prototype | ✅ PASSOU 29/04/2026 |
| M003.7 | Chase Camera / Feeling Visual | ✅ PASSOU 29/04/2026 |
| M003.8 | HUD básico de carro | ✅ PASSOU 29/04/2026 |
| M006-lite | Drift/Handbrake Feeling Inicial | ✅ PASSOU 29/04/2026 |
| M006.5 | Vehicle Audio | ❌ Cancelado — A-Chassis já tem áudio nativo |
| M006.6 | Tire Smoke / Drift Particles | ✅ PASSOU 29/04/2026 |
| M008-lite | Score/Dinheiro básico de drift | ✅ PASSOU 30/04/2026 |
| M004 | Gamepad/x360ce com A-Chassis | 🔒 Bloqueado |
| M005 | Feeling inicial + câmera | 🔒 Bloqueado |
| M006 | Drift básico + handbrake | 🔒 Bloqueado |
| M007 | Garagem simples | ⏳ Em implementação |
| M008 | No Hesi loop + Dinheiro básico | 🔒 Bloqueado |
| M008+ | **Paulista real** (OSM, Meshy, assets BR) | 🔒 Bloqueado — futuro |
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

## M003 — A-Chassis integrado ✅ PASSOU 29/04/2026

**Objetivo:** integrar A-Chassis como base de física, carro se movendo com teclado.

**Resultado:** todos os checks aprovados. A-Chassis v1.7.2 funcional, entrada/saída/câmera OK.

---

## M003.5 — Test Track sintético ✅ PASSOU 29/04/2026

**Objetivo:** pista de teste programática para sentir física do A-Chassis.

**Resultado:** pista apareceu, carro rodou. Feeling OK. Usuário pediu ambiente urbano SP.

---

## M003.6 — Avenida Paulista Prototype ✅ PASSOU 29/04/2026

**Objetivo:** ambiente urbano mínimo simbólico inspirado na Av. Paulista.

**Não é a Paulista real** — protótipo motivacional para testar carro em contexto urbano SP.

**Entregue:**
- `src/server/services/PaulistaPrototypeBuilder.server.lua`
- `docs/milestone-003-6-paulista-prototype.md`

**Ver:** `docs/milestone-003-6-paulista-prototype.md`

---

## M003.7 — Chase Camera / Feeling Visual ⏳

**Desbloqueado quando:** M003.6 testada e aprovada. ✅

**Objetivo:** substituir câmera básica por chase camera com suavização, FOV e distância dinâmicos por velocidade.

**Entregue (planejamento):**
- `src/shared/config/CameraConfig.lua` ✅ criado
- `docs/milestone-003-7-chase-camera.md` ✅ criado
- `src/client/camera/CameraController.lua` — a alterar na implementação

**Ver:** `docs/milestone-003-7-chase-camera.md`

---

## M003.8 — HUD básico de carro 🔒

**Desbloqueado quando:** M003.7 testada.

**Objetivo:** velocímetro, marcha, handbrake indicator. Sem UI final.

**Criar:**
- `src/client/ui/VehicleHUD.client.lua`
- `src/shared/config/UIConfig.lua`
- `docs/milestone-003-8-vehicle-hud.md`

---

## M006-lite — Drift/Handbrake Feeling Inicial ⏳

**Desbloqueado quando:** M003.8 testada. ✅

**Objetivo:** ajuste de handbrake + oversteer básico no A-Chassis. Sem drift scoring.

**Entregue:**
- `src/server/services/DriftTuneService.server.lua` ✅

**Valores ajustados:**
- `RearGrip 1.0 → 0.45` (oversteer)
- `FrontGrip 1.0 → 0.85`
- `PBrakeForce 1.0 → 3.0` (handbrake agressivo)
- `Steer 35 → 45` (mais ângulo)
- `FrontBias 0.0 / RearBias 1.0` (RWD puro)

---

## FUTURO — Avenida Paulista real (M008+)

> O usuário quer ver no futuro uma Avenida Paulista mais fiel. Isso está registrado como objetivo futuro.

Ferramentas planejadas:
- Plugin **OSM To Roblox** (ruas reais + volumetria de prédios)
- **Meshy** / Blender para prédios customizados
- Assets Toolbox brasileiros (Brazil City, Posto Ipiranga, sinalização)
- Semáforos, tráfego, pedestres, cruzamentos
- Iluminação noturna, atmosfera real de SP

**Não implementar antes de M004, M005, M006.**

---

## M004 — Gamepad/x360ce com A-Chassis 🔒

**Desbloqueado quando:** M003.6 validado.

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
