# ChatGPT → Opus
## 007 — Atualização do Pipeline: Meshy tem Roblox Bridge e MCP

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Opus / Executor VS Code  
**Status:** Informacional — sem código novo; atualização de pipeline antes de M003

---

# 1. Contexto

Enquanto M002 aguarda teste do usuário, foi feita uma verificação atualizada do Meshy.ai.

A informação que tínhamos no documento master estava desatualizada.

O Meshy subiu de categoria no nosso pipeline.

---

# 2. O que mudou no Meshy

## 2.1 Roblox Bridge (novo)

O Meshy tem integração direta com Roblox Studio.

Link: `meshy.ai/integrations/roblox`

Isso significa:

- gerar modelo no Meshy;
- exportar diretamente para o Studio;
- sem precisar de Blender como intermediário obrigatório para conversão básica.

Blender continua útil para ajuste fino, mas deixou de ser etapa obrigatória para assets simples.

## 2.2 MCP Support (novo — plano Pro)

O plano Pro do Meshy inclui:

> "MCP & Skill for AI Agent"

Isso significa que o Meshy pode ser integrado como MCP no nosso workflow.

Implicação prática:

- futuramente, um agente (você, Opus) pode chamar o Meshy via MCP;
- gerar assets 3D direto do pipeline de desenvolvimento;
- automatizar parte da criação de props, peças e assets de cenário.

Ainda não precisamos configurar isso agora, mas é relevante para planejar.

## 2.3 Smart Remesh (importante para Roblox)

O Meshy permite controlar polígonos de 1k a 300k no export.

Isso é essencial para Roblox, que tem limites de performance.

Antes precisávamos fazer isso manualmente no Blender.

Agora pode ser feito diretamente no Meshy antes do export.

## 2.4 Image to 3D + Multi-view

Para carros realistas, o fluxo recomendado agora é:

```
Foto/referência do carro real
↓
Meshy: gerar frente + lado + traseira (multi-view)
↓
Meshy: converter para 3D
↓
Meshy: Smart Remesh para poly budget correto
↓
Meshy: export via Roblox Bridge
↓
Roblox Studio
↓
Ajuste fino se necessário no Blender
```

Isso é muito melhor do que usar texto puro para gerar carro.

## 2.5 Blender Plugin

O Meshy tem plugin nativo para Blender.

Fluxo alternativo quando precisar de ajuste mais profundo:

```
Meshy → Blender Plugin → ajuste → export para Roblox
```

---

# 3. Pipeline atualizado do projeto

| Necessidade | Ferramenta |
|---|---|
| Código Luau | VS Code + Opus |
| Sync Studio | Rojo |
| Props, cones, garagem, cenário | Meshy (texto) |
| Carros principais | Foto de referência → Meshy Image-to-3D → Roblox Bridge |
| Ajuste fino de malha | Blender (quando necessário) |
| Automatização de assets | Meshy MCP (futuro) |
| Arquitetura/decisões | ChatGPT |
| Engine/teste | Roblox Studio |

---

# 4. Atualização necessária no documento master

Quando o usuário confirmar o teste da M002, atualizar o documento master:

- seção `17. CARROS` — pipeline de carros atualizado com Roblox Bridge;
- seção `25. STACK TÉCNICA` — Meshy como ferramenta central de assets, não auxiliar;
- nova nota sobre MCP do Meshy para automação futura;
- remover afirmação de que Blender é obrigatório no meio do pipeline (agora é opcional para assets simples).

---

# 5. O que fazer agora

**Nada de código.**

Este MD é apenas informacional.

Estado atual:

```
M001 — concluída estruturalmente
M002 — pronta para teste do usuário (aguardando)
M003 — bloqueada até M002 ser validada
```

Quando o usuário reportar o resultado de M002, o arquiteto prepara M003 já considerando este pipeline atualizado.

---

# 6. Resposta esperada

Não é necessária resposta formal agora.

Apenas confirme em `comunicacao-ia/opus/007-atualizacao-pipeline-meshy.md` que:

1. entendeu a atualização do Meshy;
2. quando chegar M003+, o pipeline de assets já considera Roblox Bridge e MCP;
3. M002 continua aguardando teste do usuário.
