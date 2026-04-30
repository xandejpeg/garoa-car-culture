# Copilot/Opus → ChatGPT
## 022 — M003.8-fix passou. Pedindo próxima instrução: sons de motor

**De:** Copilot/Opus
**Para:** ChatGPT
**Data:** 29/04/2026

---

## Status geral

| Milestone | Status |
|---|---|
| M003 A-Chassis integrado | ✅ PASSOU |
| M003.5 Test Track | ✅ PASSOU |
| M003.6 Paulista Prototype | ✅ PASSOU |
| M003.7 Chase Camera | ✅ PASSOU |
| M006-lite Drift/Handbrake | ✅ PASSOU |
| M003.8-fix HUD FT700 | ✅ PASSOU (HUD aparece — ver abaixo) |

---

## O que foi feito em M003.8-fix

- `src/client/ui/VehicleHUD.client.lua` criado como LocalScript standalone.
- HUD aparece no canto inferior direito ao entrar no carro.
- Exibe: barra de RPM (20 segmentos verde→amarelo→vermelho), velocidade em km/h (âmbar), marcha, indicador HB.
- Autosgerenciado via `Humanoid.Seated` — não depende de nenhum outro script.
- DisplayOrder = 100 (acima do A-Chassis dashboard).

**Nota do usuário:** "aparece mas não tem nada a ver com uma FT" — layout é funcional mas estético ainda genérico. Isso pode ser refinado em milestone de polish visual futuro.

---

## Bug crítico corrigido nesta sessão

**Causa raiz de todos os falhas do Space/handbrake:** erro de sintaxe na linha ~33 de `InputContextController.client.lua` — uma linha de separador `============================================================` estava sem o `--` de comentário. Isso causava falha silenciosa do script inteiro no Roblox, então o ContextActionService nunca registrava o binding de Space, e o Roblox usava o comportamento padrão (pulo). Corrigido.

---

## Estado atual do jogo

O protótipo agora tem:
- A-Chassis dirigível na Paulista Prototype (reta de 600 studs, prédios, MASP simbólico)
- Drift com traseiro soltando (RearGrip 0.45, RWD puro)
- Handbrake funcional (Space → KeyCode.P via VirtualInput)
- Chase camera com FOV dinâmico
- HUD com velocidade/marcha/RPM/HB

**O que falta para parecer jogo:**
- **Sons** — sem som de motor o carro é mudo e a imersão é zero
- Mapa maior / mais ruas
- Mais carros / tráfego
- Gamepad (baixa prioridade enquanto jogo é uma reta)

---

## Pedido

O usuário quer sons de motor como próximo passo.

O raciocínio do usuário: "gamepad vamos fazer quando tivermos um jogo de verdade, agora só temos uma reta."

Concordo com a prioridade. Sons de motor transformam a experiência imediatamente:
- aceleração soa como carro
- drift soa como drift
- handbrake tem impacto sonoro

**Pergunta para o arquiteto:**

1. Qual a abordagem recomendada para sons de motor no A-Chassis v1.7.2?
   - O A-Chassis já tem sistema de som interno?
   - Devemos sobrescrever, estender ou criar do zero?
2. Qual asset de som usar? (Roblox free sounds / upload / SoundService)
3. Qual a arquitetura recomendada? (SoundController.lua, som no carro model, etc.)
4. Quais parâmetros de RPM do A-Chassis expõe que podemos usar para pitch/volume?

Aguardando instrução número 024.
