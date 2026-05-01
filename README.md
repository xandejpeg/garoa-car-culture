# Garoa Car Culture

Simulador de cultura automotiva brasileira no Roblox. Drift, No Hesi, tuning profundo, progressão econômica, suporte a volante, São Paulo como cenário.

---

## O que é

Jogo de direção no Roblox focado em **cultura de carro brasileira** — rolê noturno, drift, customização, progressão. Inspirado em Midnight Club, No Hesi e na cena de carros modificados de SP. A "Garoa" é referência à garoa característica de São Paulo.

---

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Engine | Roblox Studio |
| Scripts | Luau |
| Física veicular | **A-Chassis v1.7.2** |
| Dev tools | VS Code + **Rojo** (sync) + Git |
| Assets 3D | Blender + **Meshy** (geração por IA) |
| Input volante | Logitech G29 via **x360ce** (XInput) |

---

## Links importantes

### Rojo (sync VS Code → Roblox Studio)
- **Releases (instalação direta):** https://github.com/rojo-rbx/rojo/releases
- **Aftman (gerenciador recomendado):** https://github.com/LPGhatguy/aftman/releases
- **Plugin no Studio:** buscar "Rojo" em Plugins → Manage Plugins (autor: rojo-rbx)

### A-Chassis (física veicular)
- **Repositório oficial:** https://github.com/lisphm/A-Chassis
- **Release usada:** `github.com/lisphm/A-Chassis/releases/tag/v1.7.2-stable`
- Física real: suspensão por mola, RPM, torque, drift, handbrake, RWD/AWD
- Usado por Midnight Racing: Tokyo e outros jogos sérios

### Meshy (geração de assets 3D por IA)
- **Site oficial:** https://www.meshy.ai
- **Repositório de skills/agentes:** `github.com/meshy-dev/meshy-3d-agent`
- **MCP Server tools:** `text-to-3d`, `image-to-3d`, `multi-image-to-3d`, `remesh`, `retexture`, `rig`, `animate`
- Plano comprado — ferramenta central de produção rápida de assets

### x360ce (emulador XInput para G29)
- **Download:** https://www.x360ce.com
- **GitHub oficial:** https://github.com/x360ce/x360ce
- Traduz G29 (DirectInput) → XInput (padrão Xbox que o Roblox aceita)

### Futuro — Paulista real
- **OSM To Roblox** (plugin Studio) — ruas reais + volumetria de prédios via OpenStreetMap

### Referências de física (estudo)
- **NGChassis** — DevForum, autor agentcodec (referência didática, não adotado)
- **RoWheel Bridge** — DevForum, autor warlord_1901t, 2025 (force feedback G29 — futuro M010)

---

## Estrutura de pastas

```
garoa-car-culture/
├── src/
│   ├── client/                    → StarterPlayerScripts (LocalScripts)
│   │   ├── camera/                → CameraController (chase cam, FOV dinâmico)
│   │   ├── economy/               → SessionEconomyTracker
│   │   ├── effects/               → TireSmokeController
│   │   ├── input/                 → InputTestHUD, OnFoot/Vehicle/InputContext
│   │   ├── scoring/               → DriftScoreController
│   │   ├── ui/                    → VehicleHUD, GarageUI
│   │   └── vehicle/               → AChassisAdapter, VehicleControlAdapter
│   ├── server/
│   │   └── services/              → ServerScriptService (Scripts)
│   │       ├── DriftTuneService   → tuning de oversteer/handbrake
│   │       ├── GarageService      → sistema de garagem (M007)
│   │       ├── PaulistaPrototypeBuilder → ambiente urbano SP
│   │       ├── TestTrackBuilder   → pista de teste sintética
│   │       └── VehicleSpawnService → spawn e inicialização do carro
│   └── shared/
│       └── config/                → ReplicatedStorage/Shared (ModuleScripts)
│           ├── AudioConfig.lua
│           ├── CameraConfig.lua
│           ├── DebugConfig.lua
│           ├── EffectsConfig.lua
│           ├── GarageConfig.lua
│           ├── InputConfig.lua
│           ├── ScoreConfig.lua
│           ├── UIConfig.lua
│           └── VehicleConfig.lua
├── assets/
│   └── A-Chassis.1.7.2.rbxm      → modelo do motor de física
├── comunicacao-ia/                → protocolo de comunicação entre IAs
│   ├── 000-protocolo-comunicacao.md
│   ├── chatgpt/                   → instruções do arquiteto (ChatGPT)
│   └── opus/                      → respostas do executor (Claude Opus)
├── docs/                          → documentação técnica
│   ├── milestones.md              → roadmap completo (V14)
│   ├── a-chassis-integration-plan.md
│   ├── vehicle-physics-decision.md
│   ├── open-source-research.md
│   ├── setup-rojo.md
│   ├── setup-x360ce.md
│   └── testing.md
├── MD/
│   └── garoa_car_culture_documento_master_v_5.md  → spec master (2100+ linhas)
└── default.project.json           → configuração Rojo
```

---

## Como rodar localmente (Rojo)

```bash
# 1. Instalar Rojo via Aftman (recomendado)
# Criar aftman.toml na raiz:
# [tools]
# rojo = "rojo-rbx/rojo@7.4.4"
aftman install

# Ou baixar direto: https://github.com/rojo-rbx/rojo/releases

# 2. Iniciar o servidor de sync
rojo serve

# Saída esperada:
# Rojo server listening on port 34872

# 3. No Roblox Studio
# Plugins → Rojo → Connect
```

Ver guia completo em [docs/setup-rojo.md](docs/setup-rojo.md).

---

## Pipeline de assets (Meshy + Blender)

| Tipo de asset | Pipeline |
|---|---|
| Props simples | Meshy → Roblox Bridge → Roblox Studio |
| Peças simples | Meshy → Smart Remesh → Roblox Bridge |
| Cenário / garagem | Meshy → Roblox Bridge → revisão no Studio |
| Carros protótipo | imagem → Meshy Image-to-3D/Multi-view → Smart Remesh → Roblox Bridge |
| Carros principais | Meshy ou modelo comprado → Blender (limpeza/otimização/colisão) → Studio |
| Automação futura | Meshy MCP + Opus — após gameplay base validado |

---

## Status dos milestones

| Milestone | Status | Descrição |
|-----------|--------|-----------|
| M000 | ✅ | Setup, Rojo, estrutura |
| M001 | ✅ | Input Test HUD + diagnóstico |
| M002 | ✅ | Carro placeholder + on-foot |
| M003 | ✅ 29/04 | A-Chassis integrado |
| M003.5 | ✅ 29/04 | Pista de teste sintética |
| M003.6 | ✅ 29/04 | Avenida Paulista Prototype |
| M003.7 | ✅ 29/04 | Chase camera com FOV dinâmico |
| M003.8 | ✅ 29/04 | HUD básico (velocidade/marcha) |
| M006-lite | ✅ 29/04 | Drift + handbrake feeling |
| M006.6 | ✅ 29/04 | Tire smoke / fumaça de pneu |
| M008-lite | ✅ 30/04 | Score e dinheiro de drift |
| **M007** | ⏳ | Garagem simples |
| M004 | 🔒 | Gamepad/x360ce com A-Chassis |
| M008+ | 🔒 | Paulista real (OSM, Meshy, assets BR) |
| M009 | 🔒 | Rodovia MVP + tráfego |
| M010 | 🔒 | G29 avançado + RoWheel Bridge |

Roadmap completo: [docs/milestones.md](docs/milestones.md)

---

## Protocolo de desenvolvimento (IA colaborativa)

```
ChatGPT (arquiteto) escreve instrução em comunicacao-ia/chatgpt/XXX-nome.md
↓
Claude Opus / Copilot (executor) lê e implementa
↓
Opus responde em comunicacao-ia/opus/XXX-nome.md
↓
Usuário (xand.jpeg) testa e valida
↓
Ciclo recomeça
```

Ver [comunicacao-ia/000-protocolo-comunicacao.md](comunicacao-ia/000-protocolo-comunicacao.md).

---

## Repositório

https://github.com/xandejpeg/garoa-car-culture
