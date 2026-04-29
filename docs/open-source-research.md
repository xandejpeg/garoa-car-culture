# Pesquisa Open Source — Física Veicular Roblox

**Projeto:** Garoa Car Culture  
**Versão:** 1.0  
**Data:** 2026-04-28  
**Status:** Em andamento — A-Chassis é prioridade

---

## Tabela de projetos

| Projeto | Link/referência | O que investigar | Prioridade | Decisão |
|---|---|---|---|---|
| A-Chassis | `github.com/lisphm/A-Chassis` | física, input, tuning, setup, modularidade | **Alta** | Prototipar em M003 |
| NGChassis | DevForum (agentcodec) | simplicidade, arquitetura didática | Média | Referência/estudo |
| OpenChassis | GitHub (se disponível) | camada modular, abstração | Média | Referência/estudo |
| SL-Chassis | DevForum/GitHub | ideias úteis, comparação | Baixa | Referência secundária |
| RoWheel Bridge | DevForum (warlord_1901t, 2025) | force feedback, G29, DirectInput | Futura | Não implementar agora |

---

## 1. A-Chassis

**Repositório:** `github.com/lisphm/A-Chassis`  
**Stars:** 75 (atualizado ativamente)  
**Linguagem:** Luau  
**Usado por:** Midnight Racing: Tokyo e outros jogos sérios

### O que oferece
- Motor com RPM, torque, câmbio
- Suspensão por mola com ajuste de stiffness
- Drift real via oversteer controlado
- Handbrake
- Valores realistas (peso, inércia, transferência de carga)
- Extensível via plugins internos

### O que investigar
- [ ] Estrutura de arquivos e onde ficam os scripts
- [ ] Como o input chega no A-Chassis (API interna)
- [ ] Como são passados os valores de controle (steer/throttle/brake)
- [ ] Como importar via Rojo (Toolbox model → arquivos .lua?)
- [ ] Onde definir os valores de tuning
- [ ] Como funciona com multiplayer (servidor vs cliente)
- [ ] Dependências externas
- [ ] Riscos: caixa-preta? Difícil de manter?

### Status
⏳ Pendente pesquisa técnica — será o foco da M003

---

## 2. NGChassis 1.02

**Autor:** agentcodec  
**Referência:** DevForum Community Resources  
**Linguagem:** Lua/Luau

### O que oferece
- Chassis simples e didático
- Focado em ser compreensível para quem está aprendendo
- Não tão avançado quanto A-Chassis
- Boa referência para entender conceitos

### O que investigar
- [ ] Como implementa suspensão de forma simples
- [ ] Como estrutura scripts cliente/servidor
- [ ] Ideias de arquitetura que possam ser aproveitadas

### Status
🔖 Referência de estudo — não será adotado

---

## 3. OpenChassis

**Referência:** GitHub (buscar)  
**Foco:** Modularidade e abstração

### O que investigar
- [ ] Existe? Encontrar repositório ativo
- [ ] Como implementa a camada de abstração entre input e física
- [ ] Como permite substituir sistemas internos

### Status
🔖 Pesquisa pendente — referência secundária

---

## 4. SL-Chassis

**Referência:** DevForum/GitHub  
**Foco:** Alternativa ao A-Chassis

### Status
🔖 Baixa prioridade — pesquisar depois do protótipo A-Chassis

---

## 5. RoWheel Bridge

**Autor:** warlord_1901t  
**DevForum:** 2025  
**Repositório:** GitHub (disponível)

### O que oferece
- Aplicação .NET 9.0
- Bridge entre DirectInput (G29, outros volantes) → virtual Xbox controller
- Suporte a **force feedback** em jogos Roblox
- Alternativa ao x360ce com approach mais limpo

### Por que é relevante
- Substitui o x360ce para G29
- Force feedback = diferencial do Garoa (sensação do drift no volante)
- Open source — pode ser customizado

### Status
📋 Documentado — não implementar antes de M006+

---

## Notas de pesquisa

### Como funciona A-Chassis internamente (resumo inicial)

A-Chassis usa `HingeConstraints` nas rodas para simular suspensão e direção. O input chega via scripts de controle que manipulam `MotorVelocity` e `AngularVelocity` das restrições. Não usa `VehicleSeat.Throttle/Steer` diretamente.

Isso significa que a integração com nosso `VehicleInputController` vai exigir um adapter layer.

### Jogos de referência que usam A-Chassis
- Midnight Racing: Tokyo
- Driving Empire (variante modificada)
- Vários jogos de corrida na Toolbox

### Próximos passos desta pesquisa
1. Clonar/baixar A-Chassis e estudar estrutura de arquivos
2. Criar protótipo mínimo A-Chassis no projeto Garoa
3. Documentar API de input do A-Chassis
4. Criar `AChassisAdapter` para conectar ao `VehicleInputController`
