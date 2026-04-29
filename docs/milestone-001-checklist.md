# Milestone 001 — Checklist de Validação

**Projeto:** Garoa Car Culture  
**Milestone:** 001 — VS Code + Rojo + Input Test  
**Status:** Aguardando teste prático

---

## A. VS Code / Rojo

- [ ] Abrir pasta do projeto no VS Code (`garoa-car-culture/`)
- [ ] Confirmar existência do `default.project.json` na raiz
- [ ] Abrir terminal e rodar `rojo serve`
- [ ] Confirmar que o terminal mostra `Serving on port 34872` (ou similar)
- [ ] Abrir Roblox Studio
- [ ] Abrir ou criar um place vazio (File → New)
- [ ] Ir em **Plugins** → **Rojo** → clicar em **Connect**
- [ ] Confirmar que aparece "Connected" no plugin
- [ ] Expandir `StarterPlayer > StarterPlayerScripts` no Explorer
- [ ] Confirmar que aparece pasta `input` com `InputTestHUD`
- [ ] Expandir `ReplicatedStorage > Shared > config`
- [ ] Confirmar que aparece `InputConfig`

---

## B. HUD sem volante (teste básico)

- [ ] Clicar em **Play** (F5) no Roblox Studio
- [ ] Confirmar que aparece o **painel vermelho "GAROA CAR CULTURE — INPUT TEST [M001]"** no canto superior esquerdo da tela
- [ ] Confirmar que o HUD mostra **"NENHUM GAMEPAD DETECTADO"** se o x360ce não estiver ativo
- [ ] Confirmar que não há erros no Output do Roblox Studio

---

## C. x360ce / G29

- [ ] Abrir **Logitech G HUB** e confirmar que o G29 é reconhecido pelo Windows
- [ ] Abrir **x360ce** (versão x64)
- [ ] Confirmar que o G29 aparece na lista de controles do x360ce
- [ ] Mapear **volante** para eixo analógico (Thumbstick 1 X ou outro)
- [ ] Mapear **acelerador** para gatilho direito (Right Trigger / R2) ou eixo
- [ ] Mapear **freio** para gatilho esquerdo (Left Trigger / L2) ou eixo
- [ ] Salvar configuração no x360ce
- [ ] Fechar e reabrir o Roblox Studio com x360ce ativo em background
- [ ] Clicar em **Play** novamente
- [ ] Confirmar que o HUD mostra **"GAMEPAD CONECTADO — 1 dispositivo(s)"**

---

## D. Coleta de dados (preencher e reportar)

| Ação física | Linha que mudou no HUD | Range observado | Invertido? |
|---|---|---|---|
| Volante → esquerda | | | |
| Volante → direita | | | |
| Volante → centro | | | |
| Acelerador → fundo | | | |
| Freio → fundo | | | |
| Embreagem (se mapeada) | | | |
| Botões do volante | (listar quais apareceram) | | |

---

## E. Critério de sucesso da Milestone 001

A milestone está completa quando:

- [x] Estrutura de arquivos criada ✅
- [x] Rojo configurado ✅
- [x] InputTestHUD criado ✅
- [ ] Rojo conecta no Roblox Studio
- [ ] HUD aparece no Play
- [ ] x360ce é reconhecido como gamepad
- [ ] Valores de volante, acelerador e freio são identificados no HUD
- [ ] Tabela D preenchida e reportada ao ChatGPT

---

## F. O que reportar ao ChatGPT depois

Preencha e cole no chat do ChatGPT:

```markdown
# Resultado do InputTestHUD

## Rojo conectou?
Sim/Não

## HUD apareceu?
Sim/Não

## x360ce foi reconhecido como gamepad?
Sim/Não

## Volante
Linha que mudou:
Range observado:
Invertido? Sim/Não

## Acelerador
Linha que mudou:
Range observado:
Invertido? Sim/Não

## Freio
Linha que mudou:
Range observado:
Invertido? Sim/Não

## Botões
Quais apareceram:

## Problemas
Print/erro/comportamento estranho:
```
