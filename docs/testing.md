# Plano de Testes — Garoa Car Culture

**Versão:** V5

---

## Teste atual: M001 — Input via x360ce/XInput

### Objetivo

Validar que o Roblox recebe corretamente os inputs vindos do G29 através do x360ce.

**Nota V5:** M001 **não bloqueia** M002. O carro placeholder pode ser desenvolvido por teclado em paralelo. M001 serve para preparar a camada avançada de volante.

### Fluxo de validação

```
Usuário conecta G29 → abre x360ce → abre Roblox Studio
→ conecta via Rojo → clica Play → HUD aparece
→ mexe no volante/pedais → anota valores → reporta ao ChatGPT
```

### Dados que precisamos coletar

| Ação física | Valor esperado no HUD | Resultado real |
|---|---|---|
| Volante esquerda | Algum eixo negativo | _(preencher após teste)_ |
| Volante direita | Algum eixo positivo | _(preencher após teste)_ |
| Volante centro | Próximo de 0 | _(preencher após teste)_ |
| Acelerador fundo | Valor subindo (0 → 1) | _(preencher após teste)_ |
| Freio fundo | Valor subindo (0 → 1) | _(preencher após teste)_ |
| Embreagem | Opcional | _(preencher se mapeada)_ |
| Botão câmera (Y) | Nome do botão aparece | _(preencher após teste)_ |
| Botão handbrake (A) | Nome do botão aparece | _(preencher após teste)_ |

### Critério de sucesso

O teste M001 passa quando o usuário consegue identificar:

- [ ] Eixo de direção (nome + range)
- [ ] Eixo de acelerador (nome + range)
- [ ] Eixo de freio (nome + range)
- [ ] Pelo menos 2 botões mapeados e identificados
- [ ] Sem inversão de eixo grave não corrigível
- [ ] Sem deadzone exagerada que impeça controle

---

## Teste M002 — Carro placeholder por teclado + On-foot (próximo)

### Objetivo

Carro básico controlável por **teclado** e personagem andando fora do carro.

### Desbloqueado quando

M000 validado (Rojo conecta). **Não depende de M001.**

### Critério de sucesso

- Andar com WASD fora do carro
- Entrar no carro com E
- Dirigir com WASD (acelerar, frear, virar)
- Sair do carro com E
- Câmera externa segue o carro
- Trocar câmera com C ou V

---

## Teste M003 — Rodovia + tráfego simples (bloqueado até M002)

### Objetivo

Dirigir em alta velocidade em uma rodovia com NPCs de tráfego simples.

### Critério de sucesso

- Pista de 3 faixas funcional
- NPCs spawnam, andam e despawnam
- FPS estável acima de 30
- Sensação de velocidade satisfatória com teclado

---

---

## Teste M003.5 — Pista de Teste (TestTrackBuilder) ✅ Liberado

### Objetivo

Testar o feeling do A-Chassis em uma pista real com curvas, reta longa e área de drift.

### Como ativar

`TestTrackBuilder.server.lua` roda automaticamente ao iniciar Play.  
A pista é gerada em `Workspace.TestTrack`.

### Critério de sucesso

- Pista gera sem erro
- Carro percorre reta + curva ampla
- Handbrake tem efeito na área de drift
- Sem capota frequente

### Checklist completo

Ver [docs/milestone-003-5-test-track.md](milestone-003-5-test-track.md)

---

## Teste M003.6 — Paulista Prototype ⏳ Liberado

### Objetivo

Testar o carro A-Chassis em um ambiente urbano simbólico inspirado na Av. Paulista.

### Como ativar

`PaulistaPrototypeBuilder.server.lua` roda automaticamente ao iniciar Play.  
Gera `Workspace.PaulistaPrototype`.  
`TestTrackBuilder` é suprimido automaticamente quando Paulista está presente.

### Critério de sucesso

- Ambiente gera sem erro
- Carro anda pela avenida
- Ambiente mais motivante que pista sintética
- Câmera funciona entre prédios

### Checklist completo

Ver [docs/milestone-003-6-paulista-prototype.md](milestone-003-6-paulista-prototype.md)

---

## Teste M003.7 — Chase Camera / Feeling Visual ✅ PASSOU 29/04/2026

### Objetivo

Chase camera com suavização, distância e FOV dinâmicos por velocidade.

### Resultado

Câmera funcional, feeling melhorado. Aprovado.

---

## Teste M003.8 — HUD básico de carro ⏳ Liberado

### Objetivo

Velocímetro (km/h), marcha, handbrake indicator no canto da tela ao entrar no carro.

### Como ativar

`VehicleHUD.show(carRoot)` é chamado automaticamente ao entrar no carro via InputContextController.  
`VehicleHUD.hide()` é chamado ao sair.  
Configuração em `src/shared/config/UIConfig.lua`.

### Critério de sucesso

- HUD aparece ao entrar no carro
- Velocidade sobe ao acelerar
- Marcha muda com Q/Z (se A-Chassis expuser Values.Gear)
- "HB" aparece quando Space é pressionado
- HUD some ao sair do carro (F)
- Sem erros vermelhos

---

## Registro de resultados

Os resultados de cada teste devem ser salvos em:

```
comunicacao-ia/historico/YYYY-MM-DD-resultado-MXXX.md
```

E enviados ao ChatGPT para liberação do próximo milestone.
