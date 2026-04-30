# M003.5 — Presets de Pista e São Paulo

**Status:** 🔍 Pesquisa concluída  
**Objetivo:** Começar a testar em ambiente real sem construir do zero

---

## Ecossistema disponível (mapeado)

O Roblox tem recursos sólidos para jogos de corrida/direção urbana. Abaixo tudo que foi identificado.

---

## 1. Física de carro — alternativas ao A-Chassis

| Sistema | Onde achar | Quando usar |
|---|---|---|
| **A-Chassis** (já em uso) | Toolbox / GitHub lisphm | ✅ atual — simulação completa |
| **A-Chassis forks (drift/rally)** | GitHub: `Roblox Vehicle Physics`, `A-Chassis plugins` | M006 — tune de drift |
| **Raycast Vehicle Physics** | DevForum Roblox | Alternativa leve/moderna se A-Chassis travar |

---

## 2. Pista de teste — opções do mais rápido ao mais elaborado

### A) Script gerado (MAIS RÁPIDO — 0 assets externos)
Copilot gera `TestTrackBuilder.server.lua` que cria toda a pista em código:
- Reta longa 300+ studs
- Curva ampla 90°
- Curva fechada 90°
- Área aberta para drift
- Muros de limite

**→ Fazer isso primeiro para não travar em assets**

### B) Toolbox — Modular Road Kit
Buscar no Toolbox do Studio (Models → Free → Most Taken):

| Busca | O que pegar |
|---|---|
| `Road Essentials` | Kit modular de ruas encaixáveis |
| `Modular Road Kit` | Curvas, retas, zebras (curbs) |
| `drift track` | Layout de pista de drift |
| `Interlagos` | Réplica do autódromo para referência |

### C) Plugin "Roads" (Bézier curves)
Plugin do Studio que desenha curvas suaves com Bézier — bom para ruas irregulares de SP.
Instalar via: Studio → Plugins → "Roads"

---

## 3. Assets São Paulo — o que existe no Roblox

### Toolbox (buscar no Studio):

| Busca | O que pegar |
|---|---|
| `São Paulo` / `Sao Paulo` | Modelos/mapas de SP (qualidade varia) |
| `Brazil City` | Prédios estilo brasileiro |
| `Favela` | Construções de favela |
| `Posto Ipiranga` | Posto icônico brasileiro (sinalização) |
| `cobblestone street` | Paralelepípedo (calçada SP) |
| `Brazil traffic sign` | Sinalizações de trânsito BR |

### Plugin "OSM To Roblox" (DESTAQUE)
Importa malha real de ruas de São Paulo a partir do OpenStreetMap:
- Seleciona área geográfica real (ex: Av. Paulista, Marginal Pinheiros)
- Gera ruas + volumetria básica de prédios automaticamente no Studio
- **Ideal para M007+ (mapa SP real)**
- Instalar via: Studio → Plugins → `OSM To Roblox`

---

## 4. Roadmap de mapas para Garoa

| Fase | Mapa | Como fazer |
|---|---|---|
| **M003.5** | Pista de teste sintética | Script Luau gerado pelo Copilot |
| **M003.5 v2** | Pista com assets modulares | Modular Road Kit + plugin Roads |
| **M007** | Bairro de SP básico | Toolbox assets (Brazil City, Favela, Posto) |
| **M008+** | Ruas reais de SP | Plugin OSM To Roblox (Av. Paulista, Marginal) |

---

## Próximo passo imediato

Gerar script de pista: `src/server/map/TestTrackBuilder.server.lua`  
Elementos mínimos:
- Reta 300 studs (sentir velocidade máxima)
- Curva ampla (subesterço/sobreesterço)
- Curva fechada (handbrake / drift)
- Área aberta quadrada (drift livre)
- Superfície: asfalto cinza + linha branca central
