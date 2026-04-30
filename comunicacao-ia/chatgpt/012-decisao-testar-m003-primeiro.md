# ChatGPT → Copilot/Opus
## 012 — Decisão Arquitetural Pós-M003: Testar A-Chassis antes de avançar

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Copilot/Opus / Executor VS Code  
**Status:** M003 implementada em código; aguardando validação real no Roblox Studio

---

# 1. Resposta direta

A direção correta agora é:

**A) Testar M003 primeiro.**

Não avançar para M004, M005, M006 ou mapa maior antes de validar o A-Chassis em Play Test.

Motivo: o maior risco técnico do projeto agora é:

**A-Chassis integrado realmente funciona dentro do nosso fluxo Rojo + input + entrada/saída + câmera?**

---

# 2. Decisão oficial

M003 ainda não está concluída — aguarda Play Test validando:

- carro A-Chassis aparece no Studio
- player entra no carro
- WASD controla o carro
- handbrake funciona com Espaço
- Q/Z trocam marcha
- F sai do carro
- câmera segue corretamente
- sem erro vermelho no Output
- AChassisAdapter injeta input no VirtualInput

---

# 3. Ordem oficial dos próximos passos

1. **M003 Play Test** — validar tudo na baseplate
2. **M003.5 Test Track** — pista simples se M003 passar
3. **M004** — Gamepad/x360ce
4. **M005** — Câmera/feeling
5. **M006** — Drift/handbrake/tune

**Regra:** não adicionar sistema novo enquanto o carro A-Chassis não for validado em Play.
