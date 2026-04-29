# ChatGPT → Opus
## 008 — Decisão: A-Chassis + Pesquisa de Projetos Open Source

**Projeto:** Garoa Car Culture  
**De:** Usuário / Executor  
**Para:** ChatGPT / Arquiteto  
**Status:** Decisão arquitetural + nova frente de pesquisa

---

# 1. Resultado do teste M002

O teste foi parcialmente bem-sucedido:

- ✅ Personagem spawnou e andou com WASD
- ✅ Carro vermelho apareceu no mapa
- ✅ Prompt [E] Entrar apareceu ao se aproximar
- ✅ E pressionado → entrou no carro
- ✅ Câmera mudou ao entrar
- ❌ Carro não se moveu (VehicleSeat com Torque insuficiente — problema de física nativa)
- ⏳ Saída do carro e câmera de retorno não chegaram a ser testadas

---

# 2. Problema identificado: VehicleSeat é limitado demais

O VehicleSeat nativo do Roblox não tem física realista.

Não serve para drift, suspensão, câmbio, feeling de carro real.

Para um jogo de car culture com drift no estilo No Hesi / Midnight Racing, precisamos de física real.

---

# 3. Decisão: adotar A-Chassis

Durante a pesquisa, identificamos:

**A-Chassis** (`github.com/lisphm/A-Chassis`)
- Padrão da indústria no Roblox para simulação de carros
- Usado por Midnight Racing: Tokyo e outros jogos sérios
- Suporta: motor, câmbio, drift, suspensão, valores realistas
- Open source, Luau, atualizado ativamente
- 75 stars no GitHub

**Decisão:** substituir o VehicleSeat simples por A-Chassis como base de física.

**Importante:** isso é para ganhar tempo, não para perder a essência do projeto.

A identidade do Garoa Car Culture — drift, São Paulo, cultura automotiva brasileira, No Hesi, G29 — continua 100% preservada.

A-Chassis é só a fundação de física. O que a gente constrói em cima é nosso.

---

# 4. Também identificado: RoWheel Bridge

**RoWheel Bridge** (DevForum 2025)
- Bridges DirectInput → virtual Xbox controller
- Suporte a **force feedback** em volantes Logitech G29
- Pode substituir o x360ce no futuro

Não é prioridade agora, mas é relevante para a camada do volante (M007+).

---

# 5. Nova frente: pesquisa de projetos open source

Antes de codificar mais, queremos pesquisar outros projetos open source de jogos de carro no Roblox para entender:

- Como implementam garagem / customização
- Como fazem spawn de carros
- Como estruturam os scripts (cliente/servidor)
- Boas práticas de economia in-game para jogos de carro
- Qualquer padrão que valha a pena adotar

Projetos para pesquisar:
1. A-Chassis (código fonte — entender a estrutura interna)
2. Outros jogos open source de carro no Roblox / DevForum
3. Padrões de garagem / tuning open source

---

# 6. Pergunta para o arquiteto

1. Confirma a decisão de adotar A-Chassis como base de física?
2. O que precisamos adaptar na nossa arquitetura de input (VehicleInputController) para funcionar com A-Chassis em vez de VehicleSeat nativo?
3. Quais projetos open source recomendas pesquisar antes de M003?
4. A M002 pode ser considerada concluída estruturalmente (loop entrar/sair funciona, física será substituída pelo A-Chassis)?

---

# 7. Estado atual dos milestones

```
M001 — ✅ concluída
M002 — ✅ concluída estruturalmente (loop de interação ok; física VehicleSeat descartada em favor de A-Chassis)
M003 — REDEFINIDA: integrar A-Chassis + adaptar input + pesquisa open source
```
