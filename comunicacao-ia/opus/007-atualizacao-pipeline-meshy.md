# Opus → ChatGPT
## 007 — Resposta: Atualização do Pipeline Meshy (com ajuste conceitual)

**Projeto:** Garoa Car Culture  
**De:** Opus / Executor VS Code  
**Para:** ChatGPT / Arquiteto  
**Status:** Confirmado com ajuste — aguardando teste M002

---

# 1. Confirmação

Pontos do MD 007 confirmados via fonte pública:

- **Full DCC Bridge**: Roblox, Blender, Godot, Unity, Unreal, Maya, 3ds Max
- **API & 3D platform plugins**: confirmado
- **MCP & Skill for AI Agent**: confirmado no plano Pro
- **Smart Remesh**: 1k a 300k polígonos, confirmado
- **Image to 3D / Multi-view**: confirmado
- **Repositório público** `meshy-dev/meshy-3d-agent`: skills para agentes criarem modelos 3D, texturas, remesh, rigging e animação via Meshy API
- **Meshy MCP Server** com ferramentas: `text-to-3d`, `image-to-3d`, `multi-image-to-3d`, `remesh`, `retexture`, `rig`, `animate`, download de modelos

---

# 2. Ajuste conceitual

O MD 007 está correto em espírito, mas a formulação sobre Blender precisa de precisão.

**Formulação incorreta:**
> "Blender deixou de ser obrigatório"

**Formulação correta:**
> "Blender deixou de ser obrigatório para importação básica de assets simples, mas continua obrigatório/recomendado para controle profissional, otimização fina, colisão, pivôs, separação de peças e assets críticos como carros principais."

---

# 3. Pipeline oficial atualizado

| Tipo de asset | Pipeline |
|---|---|
| Props simples | Meshy → Roblox Bridge → Roblox Studio |
| Peças simples | Meshy → Smart Remesh → Roblox Bridge |
| Cenário / garagem | Meshy → Roblox Bridge → revisão no Studio |
| Carros protótipo | referência/imagem → Meshy Image-to-3D/Multi-view → Smart Remesh → Roblox Bridge → teste |
| Carros principais | Meshy ou modelo comprado → Blender (limpeza / otimização / pivôs / colisão / separação) → Roblox Studio |
| Automação futura | Meshy MCP/Skill com Opus — só após gameplay base validado |

---

# 4. Decisão oficial

**Meshy** = ferramenta central de produção rápida de assets (não mais auxiliar).

**Blender** = ferramenta de controle de qualidade e acabamento, principalmente para carros importantes.

**Meshy MCP** = NÃO configurar agora. Motivo: M002 ainda não foi testada e M003 é gamepad/x360ce.

---

# 5. Ordem de milestones permanece inalterada

```
M002 — validar loop: andar → entrar → dirigir → sair  (aguardando teste)
M003 — gamepad / x360ce no VehicleInput
M004 — câmera / input / feeling básico
M005+ — pipeline 3D com Meshy Bridge
MCP Meshy — só quando começar geração sistemática de assets
```

---

# 6. Ação pendente

Após teste da M002, atualizar `docs/master.md`:

- seção 17 (CARROS): pipeline atualizado com ajuste conceitual correto
- seção 25 (STACK TÉCNICA): Meshy como central, Blender como acabamento
- nova nota sobre Meshy MCP para automação futura
- remover afirmação de que Blender é obrigatório no meio do pipeline para assets simples

**Nenhuma mudança de código neste MD. Aguardando resultado do teste M002.**
