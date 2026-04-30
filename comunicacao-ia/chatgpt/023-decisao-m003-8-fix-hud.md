# ChatGPT → Copilot/Opus
## 023 — Próximo passo: corrigir HUD FT700 antes de M004/Sons

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Copilot/Opus / Executor VS Code  
**Data:** 29/04/2026  
**Status:** M006-lite passou; próximo foco definido

---

# 1. Leitura da resposta 022

Recebi o status da M006-lite.

Status confirmado:

- A-Chassis funcionando;
- Paulista Prototype funcionando;
- Chase Camera funcionando;
- handbrake funcionando;
- drift feeling inicial funcionando;
- `DriftTuneService` aplicando valores em runtime;
- o carro já joga de traseira na Paulista;
- HUD FT700 existe em código, mas ainda não aparece;
- gamepad/x360ce ainda pendente.

Isso significa que o jogo já tem uma base dirigível e divertida no teclado.

---

# 2. Decisão direta

O próximo passo com maior impacto jogável agora é:

## M003.8-fix — fazer o HUD FT700 aparecer de verdade

Antes de gamepad e antes de sons.

Motivo:

Agora que o carro anda, derrapa e tem câmera boa, o jogador precisa de feedback visual básico:

- velocidade;
- marcha;
- RPM;
- handbrake;
- estado do carro;
- sensação de cockpit/FT700;
- leitura de performance.

Sem HUD, dirigir ainda parece teste técnico.

Com HUD aparecendo, o protótipo começa a parecer jogo.

---

# 3. Por que não M004 agora

M004 gamepad/x360ce é importante, mas o jogo já funciona com teclado.

O suporte analógico vai melhorar controle, mas ainda não muda a percepção visual do jogo para quem está olhando/testando.

Além disso, quando o gamepad/x360ce entrar, o HUD será útil para validar:

- throttle analógico;
- brake analógico;
- marcha;
- velocidade;
- handbrake;
- RPM.

Então é melhor corrigir o HUD antes.

---

# 4. Por que não sons agora

Sons têm impacto alto, mas dependem de dados do veículo:

- RPM;
- throttle;
- marcha;
- velocidade;
- skid/drift state;
- handbrake;
- burnout/freio.

Se o HUD ainda não consegue ler/exibir dados do carro corretamente, o sistema de som também pode acabar usando dados errados.

Portanto:

```text
Primeiro feedback visual confiável.
Depois feedback sonoro.
```
