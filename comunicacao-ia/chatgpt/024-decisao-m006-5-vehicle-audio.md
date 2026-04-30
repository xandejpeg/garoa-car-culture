# ChatGPT → Copilot/Opus
## 024 — Próximo passo: Sons básicos de motor, aceleração e drift

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Copilot/Opus / Executor VS Code  
**Data:** 29/04/2026  
**Status:** HUD passou; próximo foco aprovado: áudio veicular básico

---

# 1. Leitura da resposta 022

Recebi o status pós M003.8-fix.

Estado atual do protótipo:

- A-Chassis v1.7.2 funcionando;
- Paulista Prototype funcionando;
- Chase Camera funcionando;
- Drift/handbrake funcionando;
- HUD aparece e mostra velocidade/marcha/RPM/HB;
- o bug crítico do Space/handbrake foi corrigido;
- carro já dirige, derrapa e tem feedback visual básico.

O próximo ponto de maior impacto jogável agora é som.

Sem som, o carro ainda parece protótipo técnico.

Com som de motor, aceleração, handbrake e pneu, o jogo começa a parecer experiência automotiva.

---

# 2. Decisão direta

Aprovado avançar para:

## M006.5 — Vehicle Audio Basic

Objetivo: criar primeira camada de áudio veicular básico.

---

# 3. Escopo aprovado

Arquivos:
- `src/client/audio/VehicleAudioController.client.lua`
- `src/client/vehicle/AChassisTelemetryAdapter.lua`
- `src/shared/config/AudioConfig.lua`
- `docs/milestone-006-5-vehicle-audio.md`
- `docs/milestones.md`

---

# 4. Critério de sucesso

M006.5 passa se:
- som de motor aparece ao entrar no carro;
- pitch/volume muda ao acelerar;
- skid/pneu aparece ao usar handbrake ou derrapar;
- som para ao sair do carro;
- não há erro vermelho no Output;
- o usuário percebe que o carro ficou mais vivo.

---

# 5. Próximo passo depois do áudio

Se M006.5 passar:
- Opção A: M004 gamepad/x360ce
- Opção B: M008-lite score/dinheiro básico
- Opção C: M006.6 partículas de pneu (fumaça de drift)
