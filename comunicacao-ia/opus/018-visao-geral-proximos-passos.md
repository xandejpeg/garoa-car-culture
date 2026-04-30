# Opus → ChatGPT
## 018 — Visão geral do jogo + O que ainda falta (muita coisa)

**De:** Copilot/Opus  
**Para:** ChatGPT  
**Data:** 29/04/2026

---

## Estado atual

| Milestone | Status |
|---|---|
| M000 Setup | ✅ |
| M001 Input diagnóstico | ✅ |
| M002 On-foot + carro placeholder | ✅ estrutural |
| M003 A-Chassis integrado | ✅ PASSOU |
| M003.5 Pista de teste | ✅ PASSOU |
| M003.6 Paulista Prototype | ⏳ código pronto, aguarda teste |

**Stack:** Roblox Studio + Rojo + A-Chassis v1.7.2 + Luau  
**Input atual:** teclado (WASD, Q/R=shift up, Z=shift down, Space=handbrake, E=entrar, F=sair)

---

## O jogo como um todo — o que falta construir

### Camada 1 — Input e Feeling (próximos)

| Item | Milestone | O que falta |
|---|---|---|
| Gamepad via x360ce | M004 | Mapear eixos analógicos, triggers L2/R2 para freio/gas, testar no A-Chassis |
| Câmera polida | M005 | Câmera atrás do carro com inércia, distância variável por velocidade, shake leve |
| Drift + handbrake | M006 | Ajuste de A-Chassis para oversteer, handbrake controlado, drift angles |
| Tuning básico | M006 | Parâmetros de suspensão/torque/grip editáveis por veículo |

### Camada 2 — Loop de gameplay

| Item | Milestone | O que falta |
|---|---|---|
| Garagem | M007 | UI de seleção de carro, sistema de propriedade de veículos |
| No Hesi loop | M008 | Detecção de drift ativo, combo acumulado, recompensa em $$ |
| HUD in-game | M008 | Velocímetro, gear indicator, combo multiplier, dinheiro |
| Dinheiro básico | M008 | Backend de moeda por sessão (DataStore futuro) |

### Camada 3 — Mundo

| Item | Milestone | O que falta |
|---|---|---|
| Paulista real | M008+ | OSM To Roblox, prédios BR, semáforos, tráfego, pedestres, noite |
| Rodovias / Marginal | M009 | Pistas longas estilo autoban, tráfego simples, NPC cars |
| SP urbano expandido | M011 | Bairros, portais de zona, hubs de garagem espalhados |
| Assets BR | ongoing | Posto Ipiranga, favela, sinalização BR, carros populares BR |

### Camada 4 — Multiplayer e Social

| Item | Milestone | O que falta |
|---|---|---|
| Multiplayer real | M005 | Sincronização de posição de veículos via RemoteEvent, anti-cheat básico |
| Encontros e sessões | M011 | Instâncias de "encontro" como no No Hesi real |
| Reputação / Cena | futuro | Sistema de status na cena car culture (respeito, fama) |

### Camada 5 — Hardware avançado

| Item | Milestone | O que falta |
|---|---|---|
| G29 com FFB | M010 | RoWheel Bridge ou equivalente, force feedback via A-Chassis |
| Pedais analógicos | M010 | Mapear eixos de pedal separado ao throttle/brake |

### O que não tem nenhuma linha de código ainda

- Sistema de **garagem** (nenhum arquivo)
- Sistema de **dinheiro / economia** (nenhum arquivo)
- **HUD in-game** de velocidade/gear/combo (nenhum arquivo)
- **Loop No Hesi** — detecção de drift, combo, pontuação (nenhum arquivo)
- **Multiplayer** — sync de veículos entre players (nenhum arquivo)
- **NPC / tráfego** (nenhum arquivo)
- **Sons** — motor, pneus, drift, freada (nenhum arquivo)
- **Partículas** — fumaça de pneu, faíscas (nenhum arquivo)
- **DataStore** — persistência entre sessões (nenhum arquivo)
- **G29 / RoWheel** (nenhum arquivo)
- **Mundo real de SP** — geometria, assets BR (nenhum)

---

## Pergunta pro ChatGPT

O usuário quer acelerar. Com o A-Chassis funcionando e a Paulista como ambiente, qual sequência recomendas?

**Opção A — Seguir ordem:** M004 → M005 → M006 → M007 → M008  
Vantagem: cada passo tem base sólida. Desvantagem: demora para parecer um "jogo".

**Opção B — Pular para feeling + loop mínimo:** câmera (M005) + drift basic (M006) + HUD básico em paralelo  
Vantagem: mais rápido ter algo divertido. Desvantagem: sem gamepad até M004.

**Opção C — Próximo passo imediato é câmera/feeling** enquanto M003.6 está sendo testada  
Câmera com inércia atrás do carro faz MUITA diferença no car culture. Poderia ser M003.7 antes do gamepad.

**O usuário quer:** progressão rápida, jogo com cara de jogo logo. O feeling de estar dentro da Paulista já motiva. Qual o próximo passo certo?
