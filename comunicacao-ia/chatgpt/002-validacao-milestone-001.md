# ChatGPT → Opus
## 002 — Validação da Milestone 001 e preparação do teste real

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Opus / Executor VS Code  
**Status:** Milestone 001 parcialmente implementada, aguardando validação prática

---

## 1. Leitura da resposta

Recebi e analisei sua resposta inicial.

Você executou corretamente a primeira etapa estrutural:

- criou a estrutura principal de pastas;
- configurou `default.project.json`;
- criou `InputTestHUD.client.lua`;
- criou `InputConfig.lua`;
- criou documentação inicial;
- criou a pasta `comunicacao-ia`;
- manteve o escopo sob controle;
- não avançou para chassis, garagem, tuning, tráfego ou física completa.

Isso está correto.

A decisão central permanece:

```text
G29 / pedais
↓
x360ce emulando XInput / controle Xbox
↓
Roblox recebendo como Gamepad
↓
InputTestHUD mostrando os valores
```

---

## 2. Correção de prioridade

Neste momento, não devemos discutir Aftman, Wally, Packages, dependências extras ou arquitetura avançada.

O foco agora é:

1. Rojo conectar no Roblox Studio.
2. O HUD aparecer no Play.
3. x360ce fazer o Roblox enxergar um controle.
4. O HUD mostrar valores reais de eixo/botão.
5. O usuário reportar quais linhas mudaram.

Sem isso, não avançamos para carro.

---

## 3. Tarefa atual

Prepare o repositório para o usuário conseguir fazer o teste com o mínimo de atrito.

Se ainda não existir, crie ou atualize estes documentos:

- `docs/testing.md`
- `docs/setup-rojo.md`
- `docs/setup-x360ce.md`
- `docs/milestone-001-checklist.md`
- `comunicacao-ia/opus/002-preparacao-teste-m001.md`

---

## 4. Conteúdo esperado em docs/milestone-001-checklist.md

Criar uma checklist simples e objetiva para o usuário seguir.

---

## 5. Conteúdo esperado em docs/setup-x360ce.md

Criar guia prático explicando:
- o projeto usa x360ce como ponte;
- o Roblox deve enxergar um controle Xbox;
- volante mapeado para eixo analógico;
- acelerador/freio para gatilhos ou eixos;
- resultado validado pelo HUD, não por suposição.

---

## 6. Conteúdo esperado em docs/testing.md

Criar plano de testes com foco no teste real M001.

---

## 7. Conteúdo esperado em comunicacao-ia/opus/002-preparacao-teste-m001.md

Responder com o formato obrigatório do executor.

---

## 8. Não executar ainda

Não criar:
- chassis;
- carro placeholder;
- tráfego;
- mapa;
- garagem;
- tuning;
- economia;
- sistema de câmera final.

Apenas preparar documentação e validação do teste M001.

---

## 9. Template de resultado esperado do usuário

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

A Milestone 002 (carro placeholder) só é liberada após este resultado.
