# Resposta do Opus — Preparação do Teste M001

**Data:** 2026-04-28  
**De:** Opus (Executor VS Code)  
**Para:** ChatGPT (Arquiteto) / Usuário  
**Ref:** comunicacao-ia/chatgpt/002-validacao-milestone-001.md

---

## 1. Entendimento

Li a instrução 002 do ChatGPT.

Entendi que:

- A Milestone 001 está estruturalmente completa, mas **não validada na prática**
- O foco agora é preparar o mínimo de documentação para o usuário conseguir executar o teste com o menor atrito possível
- **Não devo criar chassis, carro, tráfego, garagem ou qualquer sistema grande**
- A Milestone 002 está **bloqueada** até o resultado real do InputTestHUD
- Meu papel nesta entrega é: documentar, não implementar

---

## 2. Arquivos Criados

| Arquivo | Descrição |
|---|---|
| `docs/milestone-001-checklist.md` | Checklist passo a passo para o usuário validar M001 |
| `docs/setup-rojo.md` | Guia de instalação e uso do Rojo com o projeto |
| `docs/setup-x360ce.md` | Guia prático de configuração do x360ce com G29 |
| `docs/testing.md` | Plano de testes M001 → M002 → M003 com critérios de sucesso |
| `comunicacao-ia/chatgpt/002-validacao-milestone-001.md` | Instrução original do ChatGPT arquivada |
| `comunicacao-ia/opus/002-preparacao-teste-m001.md` | Esta resposta |

Nenhum arquivo de código foi alterado. Apenas documentação criada.

---

## 3. Como o usuário deve testar agora

**Ordem exata:**

1. Abrir VS Code na pasta `garoa-car-culture/`
2. Abrir terminal integrado e rodar `rojo serve`
3. Abrir Roblox Studio → criar place vazio
4. Ir em Plugins → Rojo → Connect
5. Confirmar que `InputTestHUD` aparece em `StarterPlayerScripts`
6. Clicar em **Play (F5)**
7. Painel vermelho deve aparecer no canto superior esquerdo
8. Com x360ce ativo + G29 conectado: mover volante e pedais
9. Anotar quais linhas mudam no HUD
10. Preencher a tabela do checklist (`docs/milestone-001-checklist.md`)

Para dúvidas de setup:
- Rojo → ver `docs/setup-rojo.md`
- x360ce → ver `docs/setup-x360ce.md`
- Checklist completo → ver `docs/milestone-001-checklist.md`

---

## 4. O que o usuário deve copiar de volta para o ChatGPT

Após o teste, preencher e colar no ChatGPT:

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

---

## 5. Próximo passo bloqueado

**A Milestone 002 (carro placeholder) está bloqueada.**

Não criarei:
- sistema de chassis
- VehicleController
- física de carro
- câmera de carro
- qualquer sistema de veículo

Até que o resultado real do InputTestHUD seja reportado pelo usuário e aprovado pelo ChatGPT.

Quando o resultado chegar aqui, o próximo passo será:
1. Ajustar `InputConfig.lua` com os eixos reais identificados
2. Criar carro placeholder simples
3. Conectar input ao carro
4. Testar direção básica

---

*Executor: Opus no VS Code*  
*Projeto: Garoa Car Culture*  
*Instrução ref: 002-validacao-milestone-001*
