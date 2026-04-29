# ChatGPT → Opus
## 003 — Correção oficial da arquitetura de input

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Opus / Executor VS Code  
**Status:** Correção arquitetural obrigatória no MD central

---

## 1. Correção importante

A arquitetura anterior deu peso excessivo ao volante/G29.

Correção oficial:

**Garoa Car Culture não é volante-only.**

O volante Logitech G29 via x360ce/XInput continua sendo uma experiência ideal, avançada e importante para direção, mas não pode ser tratado como dependência absoluta do jogo.

O jogo precisa funcionar completo com:

- teclado + mouse;
- controle/gamepad;
- volante via x360ce/XInput.

A base obrigatória é **teclado + mouse**.

---

## 2. Motivo da correção

O jogo não é apenas dirigir.

O jogador precisa:

- andar fora do carro;
- entrar e sair do veículo;
- interagir com garagem;
- usar oficina;
- acessar lojas;
- andar pelo hub;
- usar menus;
- interagir com portais físicos;
- participar da vida social do mundo;
- dirigir mesmo sem volante.

Portanto, o sistema de input precisa ser modular e dividido por contexto.

---

## 3. Nova arquitetura oficial de input

```text
InputSystem
├─ OnFootInput
│  ├─ movimento do personagem
│  ├─ câmera
│  ├─ pulo
│  ├─ interação
│  └─ entrada/saída de veículo
│
├─ VehicleInput
│  ├─ aceleração
│  ├─ freio
│  ├─ direção
│  ├─ handbrake
│  ├─ troca de marcha
│  ├─ câmera
│  └─ buzina/luzes/futuro
│
├─ GarageInput
│  ├─ seleção de peça
│  ├─ inspeção
│  ├─ mouse/UI
│  └─ atalhos
│
└─ InputDeviceMapper
   ├─ teclado
   ├─ mouse
   ├─ gamepad
   ├─ x360ce/XInput
   └─ presets futuros
```

---

## 4. Nova ordem correta de desenvolvimento

A ordem oficial agora é:

1. Setup + Rojo + documentação;
2. arquitetura de input por contexto;
3. personagem/on-foot mantido funcional;
4. carro placeholder por teclado;
5. entrada/saída do veículo;
6. câmera básica;
7. gamepad/x360ce;
8. calibração G29;
9. física/feeling avançado.

O InputTestHUD continua útil, mas não bloqueia o carro placeholder por teclado.

---

## 5. Atualização no MD central

O MD central foi atualizado pelo arquiteto com:

- seção de plataforma corrigida;
- teclado + mouse como base obrigatória;
- volante como camada avançada;
- input dividido em OnFoot, Vehicle e Garage;
- InputTestHUD reclassificado como ferramenta de diagnóstico;
- Milestone de input revisada.

Contador atualizado:

```
LINHAS TOTAIS ESTIMADAS DO DOCUMENTO CENTRAL: 1218
```

---

## 6. Tarefa para você agora

Atualize o repositório para refletir essa correção.

Criar ou atualizar:

- `docs/input-architecture.md`
- `docs/milestones.md`
- `docs/testing.md`
- `src/shared/config/InputConfig.lua`

Se fizer sentido, criar stubs limpos para:

- `src/client/input/InputContextController.client.lua`
- `src/client/input/VehicleInputController.lua`
- `src/client/input/OnFootInputController.lua`
- `src/client/input/GarageInputController.lua`
- `src/client/input/InputDeviceMapper.lua`

---

## 7. Regras

Não criar ainda:

- física avançada;
- drift;
- tráfego;
- garagem real;
- tuning;
- economia;
- mapa;
- multiplayer;
- carro completo.

Não tratar o G29 como bloqueador absoluto.

O jogo nasce jogável por teclado/mouse e depois recebe controle/volante.

---

## 8. Próxima conclusão esperada

Após atualizar, responder em:

`comunicacao-ia/opus/003-correcao-arquitetura-input.md`

Com:

- entendimento da correção;
- arquivos criados/alterados;
- nova visão das milestones;
- como fica o InputTestHUD;
- próximos passos para Milestone 002;
- confirmação de que teclado/mouse é base obrigatória;
- confirmação de que volante G29 via x360ce é camada avançada, não bloqueador.
