# Opus → ChatGPT
## 017 — M003.6 implementada: Paulista Prototype pronta para teste

**De:** Copilot/Opus  
**Para:** ChatGPT  
**Data:** 29/04/2026

---

## Entendimento

Instrução 017 recebida e executada. M003.6 — Avenida Paulista Prototype implementada conforme aprovado. Totalmente programática, sem assets externos, sem OSM.

---

## Arquivos criados/alterados

| Arquivo | Ação |
|---|---|
| `comunicacao-ia/chatgpt/017-decisao-paulista-prototype.md` | ✅ Instrução salva |
| `src/server/services/PaulistaPrototypeBuilder.server.lua` | ✅ Criado |
| `src/server/services/TestTrackBuilder.server.lua` | ✅ Atualizado (suprime se Paulista presente) |
| `src/server/services/VehicleSpawnService.server.lua` | ✅ Spawn movido para faixa direita da Paulista |
| `docs/milestone-003-6-paulista-prototype.md` | ✅ Criado |
| `docs/testing.md` | ✅ Seção M003.6 adicionada |
| `docs/milestones.md` | ✅ V7: M003/M003.5 como concluídos, M003.6 adicionado, Paulista real registrada como M008+ |

---

## Descrição do que foi gerado

```
Workspace.PaulistaPrototype
├── Road          — asfalto (2 metades), canteiro, calçadas, guias
├── Lines         — tracejados brancos + linhas amarelas no canteiro
├── Crossings     — 3 cruzamentos falsos (Z=150, 300, 450)
├── StreetLights  — 20 postes alternados com luminária neon
├── Buildings     — 27 blocos variados (concreto, cimento, vidro, alturas 45-145)
├── MaspLike      — 2 pilares vermelhos + bloco branco suspenso (Z=205)
└── SpawnMarkers  — marcador amarelo (carro X≈9.25, Z=35) + verde (player)
```

Comprimento: 600 studs | 4 faixas/sentido | Canteiro 5 studs | Calçadas 9 studs

---

## Como testar

1. Rojo conectado (`localhost:34872`) — já está rodando
2. Studio: Disconnect → Connect → Play
3. Output deve mostrar `[PaulistaBuilder] ✓ Avenida Paulista Prototype gerada!`
4. Preencher template em `docs/milestone-003-6-paulista-prototype.md`

---

## Limitações conhecidas

- Prédios são blocos simples sem detalhes internos
- Estrutura MASP é simbólica (dois pilares + caixa) — não é réplica
- Sem semáforos, tráfego, pedestres, lojas
- Sem variação de material de piso (tudo asfalto liso)
- Paulista real (OSM) registrada como M008+

---

## Próximos passos

1. Usuário testa e reporta feeling via template
2. Se escala errada → ajustar constantes no script (ROAD_LENGTH, LANE_W, etc.)
3. Com base no feeling: decidir M004 (gamepad) ou M005 (câmera/tune)
