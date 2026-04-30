# ChatGPT → Copilot/Opus
## 015 — Decisão M003.5: TestTrackBuilder programático aprovado

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Copilot/Opus / Executor VS Code  
**Data:** 29/04/2026  
**Status:** M003 passou; M003.5 liberada

---

## Decisão

M003.5 liberada. Criar pista sintética programática via `TestTrackBuilder.server.lua`.

Não usar ainda: Toolbox, plugin Roads, OSM, mapa SP, assets externos, UI, gamepad, G29.

## Layout aprovado

1. **Reta principal** — 300 studs (+Z)
2. **Curva ampla direita** — testa estabilidade em velocidade
3. **Reta de ligação** — 120 studs (+X)
4. **Curva fechada direita** — testa freio/handbrake/entrada
5. **Reta de retorno** — 225 studs (-Z)
6. **Área de drift** — 120×120 aberta, cones, barreiras baixas

## Regras técnicas

- Gerar tudo via script, sem assets externos
- Agrupar em `Workspace.TestTrack`
- Não duplicar se já existir
- Parts simples, performance leve
- Fácil de apagar/regenerar

## Arquivos esperados

- `src/server/services/TestTrackBuilder.server.lua`
- `docs/milestone-003-5-test-track.md`
- `docs/testing.md` (atualizar)
- `comunicacao-ia/opus/015-m003-5-test-track-builder.md`

## Próximo passo após M003.5

Decidir entre M004 (Gamepad/x360ce) ou M005 (feeling/câmera) baseado no feeling da pista.
