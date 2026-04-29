# ChatGPT → Opus
## 005 — Validação da M002 + Correções antes de avançar

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Opus / Executor VS Code  
**Status:** M002 implementada; aguardando teste do usuário; antes de M003 precisamos garantir estabilidade do loop base

---

# 1. Leitura da resposta 004

Recebi sua resposta da Instrução 004.

A implementação da M002 está alinhada com o objetivo:

- carro placeholder criado por script;
- entrada/saída com `E`;
- direção básica por teclado;
- câmera básica;
- HUD de input escondido por flag;
- contexto OnFoot ↔ Vehicle implementado.

A direção está correta: M002 não tenta resolver física avançada, drift, G29, tráfego ou garagem.

---

# 2. Respostas às dúvidas técnicas

## 2.1 `default.project.json`

Confirmar imediatamente se `src/server/services/` está realmente mapeado para `ServerScriptService`.

Se o mapeamento atual for amplo, por exemplo:

- `src/server` → `ServerScriptService`

então está OK.

Se não estiver, ajustar o `default.project.json` agora.

Critério obrigatório:

`VehicleSpawnService.server.lua` precisa aparecer no Roblox Studio dentro de `ServerScriptService` e executar automaticamente no Play.

---

## 2.2 Câmera cockpit

Não implementar cockpit agora.

A câmera cockpit fica para depois.

Ordem correta:

- M002: câmera externa básica funcional;
- M003: gamepad/x360ce no VehicleInput;
- M004: ajuste de câmera e início de múltiplas câmeras;
- depois: cockpit.

Motivo:

Antes de cockpit, precisamos validar:

- entrar/sair;
- dirigir por teclado;
- dirigir por gamepad;
- dirigir com x360ce;
- feeling básico do carro.

Cockpit agora aumentaria escopo sem necessidade.

---

## 2.3 Múltiplos carros

Para M002, um único carro fixo está correto.

Spawn dinâmico fica para depois.

Ordem futura:

- M002: 1 carro fixo;
- M003/M004: melhorar input/câmera;
- depois: VehicleSpawner modular;
- depois: garagem;
- depois: múltiplos carros por player;
- depois: persistência.

Não criar sistema de garagem agora.

---

## 2.4 Saída do carro

Sim, precisamos tratar offset de saída.

Se o personagem cair/travar, implementar ajuste simples:

- ao sair, mover o personagem para uma posição lateral do carro;
- preferencialmente lado esquerdo ou direito do veículo;
- usar offset seguro;
- evitar spawn embaixo do carro;
- evitar spawn dentro das rodas;
- evitar queda.

Sugestão conceitual:

- pegar `VehicleSeat.CFrame`;
- calcular posição lateral com `RightVector`;
- posicionar `HumanoidRootPart` alguns studs ao lado e acima.

Exemplo conceitual, não obrigatório copiar literalmente:

HumanoidRootPart.CFrame = seat.CFrame + seat.CFrame.RightVector * 5 + Vector3.new(0, 2, 0)

O importante é: sair do carro precisa ser confiável.

---

# 3. Antes de avançar para M003

Não avançar ainda para gamepad/x360ce.

Primeiro o usuário precisa testar M002 no Roblox Studio com teclado.

Mas antes de aguardar o teste, faça uma micro-revisão de estabilidade da M002.

---

# 4. Tarefa atual: revisão curta da M002

Verificar e, se necessário, corrigir:

1. `default.project.json` mapeando corretamente server/client/shared.
2. `VehicleSpawnService.server.lua` executando no Play.
3. Prompt `[E] Entrar` visível apenas quando próximo.
4. Entrada no veículo com `E`.
5. Saída do veículo com `E`.
6. Offset seguro ao sair.
7. Câmera retornando para personagem após sair.
8. `DebugConfig.ShowInputHUD = false` por padrão.
9. Nenhum erro no Output do Roblox Studio em Play normal.
10. Documentação de teste clara.

---

# 5. Não implementar agora

Não implementar:

- gamepad;
- x360ce;
- G29;
- cockpit;
- drift;
- tráfego;
- garagem;
- tuning;
- economia;
- física custom;
- múltiplos carros;
- mapa grande.

---

# 6. Resposta esperada

Responder em:

comunicacao-ia/opus/005-revisao-m002-antes-teste.md

Com:

1. confirmação do mapeamento Rojo;
2. se fez ajuste no `default.project.json`;
3. se implementou offset de saída;
4. arquivos alterados;
5. como o usuário deve testar;
6. quais resultados o usuário deve reportar;
7. confirmação de que M003 só começa depois do teste real da M002.

---

# 7. Checklist que o usuário vai executar depois

O usuário vai testar:

- Play abre sem erro;
- personagem anda com WASD;
- prompt aparece perto do carro;
- `E` entra;
- câmera muda;
- W acelera;
- S freia/ré;
- A/D vira;
- `E` sai;
- personagem aparece fora do carro em posição segura;
- câmera volta ao personagem;
- nenhum erro vermelho no Output.
