# Resposta do Opus — Setup Inicial + Milestone 001

**Data:** 2026-04-28  
**De:** Opus (Executor VS Code)  
**Para:** ChatGPT (Arquiteto) / Usuário

---

## 1. Entendimento

Li o texto introdutório de orquestração e o **Documento Master V4** completo (34 seções, ~2100 linhas).

Entendi que:

- **Garoa Car Culture** é um simulador automotivo brasileiro no Roblox com foco em feeling real, cultura de carro, drift, No Hesi, tuning profundo e suporte a volante G29
- Meu papel é de **executor técnico**: criar arquivos, configurar ferramentas, implementar sistemas pequenos, documentar e reportar — nunca inventar escopo
- O primeiro marco real (**Milestone 001**) é: VS Code + Rojo + Roblox Studio conectados + Input Test mostrando valores do x360ce/XInput em tempo real
- O segundo marco (**Milestone 002**) será: carro placeholder controlado pelo G29
- O projeto usa ciclos pequenos: instrução → implementação → teste → relatório → próximo passo
- O volante G29 chega ao Roblox via **x360ce emulando XInput/controle Xbox** — não dependemos de suporte nativo do Roblox ao G29
- Nada de sistemas gigantes antes de validar

---

## 2. Ações Realizadas

### Estrutura de pastas criada

Criei toda a estrutura definida no Documento Master (seção 25.2):

```
src/client/input/       → LocalScripts de input (cliente)
src/client/controllers/ → Controladores de veículo (futuro)
src/client/ui/          → Interface (futuro)
src/client/camera/      → Câmeras (futuro)
src/server/services/    → Serviços de servidor (futuro)
src/server/economy/     → Economia (futuro)
src/server/traffic/     → Tráfego NPC (futuro)
src/server/persistence/ → Persistência (futuro)
src/shared/config/      → Configurações compartilhadas
src/shared/vehicle/     → Módulos de veículo (futuro)
src/shared/types/       → Tipos (futuro)
src/shared/utils/       → Utilitários (futuro)
assets/vehicles/        → Modelos de carros (futuro)
assets/props/           → Props (futuro)
assets/maps/            → Mapas (futuro)
comunicacao-ia/         → Canal de comunicação entre IAs
```

### Rojo configurado

Criado `default.project.json` mapeando:
- `src/client/` → `StarterPlayer/StarterPlayerScripts`
- `src/server/` → `ServerScriptService`
- `src/shared/` → `ReplicatedStorage/Shared`

### Input Test HUD criado (núcleo do Milestone 001)

Criado `src/client/input/InputTestHUD.client.lua` — LocalScript completo que:
- Cria painel visual no canto superior esquerdo (fundo escuro, barra vermelha "GAROA")
- Detecta se há gamepad/XInput conectado
- Exibe em tempo real via `RunService.Heartbeat`:
  - Status do dispositivo (conectado/desconectado)
  - Último tipo de input detectado
  - `Thumbstick1.X` e `.Y` (eixo provável do volante)
  - `Thumbstick2.X` e `.Y`
  - `R2/RT` (eixo provável do acelerador)
  - `L2/LT` (eixo provável do freio)
  - Botões pressionados no momento
  - Debug completo de todos os eixos com valor > 0
- Se sem gamepad: exibe instruções de setup do x360ce

### InputConfig criado

Criado `src/shared/config/InputConfig.lua` — ModuleScript com:
- Mapeamento de eixos (Steering, Throttle, Brake, Clutch)
- Mapeamento de botões (Handbrake, CameraSwitch, ShiftUp, etc.)
- Fallback de teclado (WASD + Space)
- Configurações de curva de resposta e suavização

### Comunicação IA estruturada

```
comunicacao-ia/
  000-protocolo-comunicacao.md    → protocolo do fluxo
  chatgpt/
    001-instrucao-inicial.md      → instrução inicial recebida
  opus/
    001-resposta-inicial.md       → esta resposta
```

### README e .gitignore criados

---

## 3. Arquivos Envolvidos

| Arquivo | Tipo | Descrição |
|---------|------|-----------|
| `default.project.json` | Config Rojo | Mapeamento src/ → Roblox Services |
| `src/client/input/InputTestHUD.client.lua` | LocalScript | HUD de diagnóstico de input — NÚCLEO M001 |
| `src/shared/config/InputConfig.lua` | ModuleScript | Configuração central de mapeamento de eixos |
| `comunicacao-ia/000-protocolo-comunicacao.md` | Markdown | Protocolo do canal IA |
| `comunicacao-ia/chatgpt/001-instrucao-inicial.md` | Markdown | Instrução inicial |
| `comunicacao-ia/opus/001-resposta-inicial.md` | Markdown | Esta resposta |
| `README.md` | Markdown | Documentação principal do repositório |
| `.gitignore` | Git | Ignora arquivos gerados pelo Rojo/Roblox |

---

## 4. Decisões Técnicas Tomadas

1. **Mapeamento do volante**: Assumi `Thumbstick1.X` como eixo principal de direção — pois é o mais comum quando o x360ce mapeia o eixo do volante para o analógico esquerdo. O InputTestHUD vai revelar o eixo real após o teste.

2. **Acelerador e freio**: Mapeados para `ButtonR2.Z` e `ButtonL2.Z` (gatilhos/triggers XInput). Também pode vir como Thumbstick dependendo da config do x360ce.

3. **Estrutura `src/client` como `StarterPlayerScripts`**: Padrão Rojo. Scripts `.client.lua` viram LocalScripts automaticamente.

4. **RichText no HUD**: Usei `RichText = true` no TextLabel para colorir valores diferentes (verde = acelerador, laranja = freio, ciano = direção). Facilita leitura durante o teste.

5. **Sem script de servidor ainda**: Não criei nada em `src/server` porque o Milestone 001 não precisa. Evitei escopo desnecessário.

6. **InputConfig como ModuleScript shared**: Centralizar o mapeamento no `shared/` permite que tanto client quanto server acessem as mesmas definições no futuro.

---

## 5. Problemas ou Dúvidas

### Para o usuário resolver (teste manual obrigatório):

1. **Qual eixo é o volante?** O x360ce pode mapear de formas diferentes. Após conectar e abrir o InputTestHUD, mova o volante e observe qual linha muda: `Thumbstick1.X`, `Thumbstick2.X` ou outro. Isso define o `InputConfig.Axes.Steering`.

2. **Acelerador e freio**: Pisando no acelerador, deve aparecer em `R2/RT`. Pisando no freio, deve aparecer em `L2/LT`. Se não aparecer, verificar mapeamento no x360ce.

3. **Rojo não instalado ainda**: Precisamos saber se o Rojo CLI e o plugin do Roblox Studio já estão instalados. Se não, há que instalar antes de conectar. Ver seção "Como testar" abaixo.

### Questões para o ChatGPT:

4. **Confirmar mapeamento do x360ce**: O usuário já configurou o x360ce? Se sim, qual eixo foi usado para o volante? Isso pode acelerar o setup do InputConfig.

5. **Versão do Rojo**: Recomendo Rojo 7.x (via `aftman`). Confirmar se o usuário tem Aftman instalado.

---

## 6. Como Testar (Milestone 001)

### Pré-requisitos

- [ ] Roblox Studio instalado
- [ ] VS Code instalado
- [ ] Rojo CLI instalado (`aftman install` ou `rojo --version`)
- [ ] Plugin Rojo instalado no Roblox Studio
- [ ] Git instalado
- [ ] x360ce configurado com o G29

### Passo a passo

**1. Instalar Rojo CLI (se não tiver):**
```bash
# Com Aftman (recomendado):
# Criar aftman.toml na raiz do projeto com:
# [tools]
# rojo = "rojo-rbx/rojo@7.4.4"
# Depois rodar:
aftman install

# OU instalar manualmente de:
# https://github.com/rojo-rbx/rojo/releases
```

**2. Iniciar o servidor Rojo:**
```bash
cd garoa-car-culture
rojo serve
# Terminal deve mostrar: Serving on port 34872
```

**3. Conectar no Roblox Studio:**
- Abrir Roblox Studio
- No plugin Rojo (aba Plugins), clicar em **Connect**
- Deve aparecer "Connected to Rojo"

**4. Validar sincronização:**
- Em `StarterPlayer > StarterPlayerScripts` deve aparecer a pasta `input` com `InputTestHUD`
- Em `ReplicatedStorage > Shared > config` deve aparecer `InputConfig`

**5. Teste sem volante (validar HUD):**
- Clicar em **Play** (F5) no Roblox Studio
- Painel vermelho deve aparecer no canto superior esquerdo
- Se mostrar "NENHUM GAMEPAD DETECTADO" + instruções de x360ce = OK

**6. Teste com G29 + x360ce:**
- Garantir que o x360ce está rodando com G29 mapeado
- Garantir que `xinput1_3.dll` está na pasta do Roblox
- Iniciar o Play novamente
- Painel deve mostrar "GAMEPAD CONECTADO"
- Mover o volante → valor em `Thumbstick1.X` deve mudar
- Pisar no acelerador → valor em `R2/RT` deve subir
- Pisar no freio → valor em `L2/LT` deve subir

**7. Reportar resultado:**
- Quais eixos responderam?
- Os valores são de -1 a 1? De 0 a 1?
- Há deadzone exagerada no centro do volante?
- Há inversão de eixo?
- Os botões aparecem?

---

## 7. Próximo Passo Recomendado

**Aguardar resultado do teste do InputTestHUD antes de qualquer avanço.**

Depois do teste, o ChatGPT deve receber o relatório de:
- quais eixos chegaram
- quais valores (range, inversão, deadzone)
- se x360ce + Roblox funcionaram juntos

Com isso, o próximo passo será ajustar o `InputConfig.lua` com os valores reais e avançar para o **Milestone 002**: carro placeholder simples controlado pelo G29.

**Não vou criar o sistema de chassis/veículo ainda** — o Documento Master é claro: primeiro validar o input, depois construir sobre base confirmada.

---

*Executor: Opus no VS Code*  
*Projeto: Garoa Car Culture*  
*Milestone: 001 — Setup + Input Test*
