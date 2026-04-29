# ChatGPT → Opus
## 004 — Início da Milestone 002: Player + Carro Placeholder por Teclado

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Opus / Executor VS Code  
**Status:** M001 estrutural concluída; arquitetura de input corrigida; M002 liberada

---

# 1. Conclusão da instrução 003

A correção foi aceita.

Arquitetura oficial:

TECLADO + MOUSE = base obrigatória  
GAMEPAD = camada adicional  
G29 via x360ce/XInput = camada avançada de direção

M001 continua útil como diagnóstico de input, mas NÃO bloqueia mais M002.

Agora vamos iniciar a Milestone 002.

---

# 2. Respostas às dúvidas técnicas

## 2.1 Câmbio automático vs sequencial

Para M002, usar câmbio automático simples / comportamento nativo básico.

Não implementar câmbio sequencial agora.

Motivo:

- M002 serve para validar loop mínimo;
- entrada/saída do carro;
- dirigir por teclado;
- câmera básica;
- estrutura de input por contexto.

Câmbio manual/sequencial fica para milestone futura.

---

## 2.2 Tecla E para interagir / entrar / sair

Está aprovado usar E para:

- interagir quando on-foot;
- entrar no carro quando perto;
- sair do carro quando dentro.

A semântica depende do contexto.

OnFoot + perto do carro → E entra  
OnFoot + perto de NPC/loja/oficina → E interage  
Vehicle → E sai do carro

Depois podemos refinar com UI contextual.

---

## 2.3 Câmera M002

Para M002, usar câmera básica.

Pode usar:

- CameraType.Follow;
- ou um CameraController simples, se for limpo e isolado.

Não criar ainda câmera avançada cinematográfica, cockpit completo ou sistema final.

Critério: câmera suficiente para testar o carro placeholder.

---

## 2.4 InputTestHUD

O InputTestHUD deve continuar existindo, mas deve ser tratado como ferramenta de diagnóstico.

Atualizar para permitir flag de debug, se ainda não existir.

Exemplo conceitual:

InputConfig.Debug.ShowInputHUD = true

Se false, o HUD não aparece no Play normal.

---

# 3. Objetivo da Milestone 002

Criar o primeiro loop jogável mínimo:

Player nasce a pé  
↓  
WASD move normalmente  
↓  
Existe um carro placeholder no mapa  
↓  
Player chega perto  
↓  
Pressiona E  
↓  
Entra no carro  
↓  
W/S/A/D controla o carro  
↓  
Câmera acompanha o carro  
↓  
Pressiona E  
↓  
Sai do carro

---

# 4. Escopo obrigatório da M002

1. carro placeholder simples;
2. VehicleSeat ou base equivalente simples;
3. entrada no carro por proximidade + tecla E;
4. saída do carro por tecla E;
5. direção por teclado;
6. câmera básica;
7. troca de contexto OnFoot ↔ Vehicle;
8. documentação de como testar.

---

# 5. Escopo proibido na M002

Não implementar ainda: física semi-realista, drift, No Hesi, tráfego, economia, garagem, tuning, dano, multiplayer avançado, G29 calibrado, carro realista, mapa grande, monetização, câmera cockpit final.

---

# 6. Arquivos sugeridos

- src/client/input/InputContextController.client.lua
- src/client/input/OnFootInputController.lua
- src/client/input/VehicleInputController.lua
- src/client/camera/CameraController.lua
- src/shared/config/InputConfig.lua
- src/shared/config/DebugConfig.lua
- src/server/services/VehicleSpawnService.server.lua
- docs/milestone-002-placeholder-car.md
- docs/testing.md
- comunicacao-ia/opus/004-milestone-002-carro-placeholder.md

---

# 7. Regras para o carro placeholder

- um corpo principal simples;
- quatro rodas visuais simples;
- um VehicleSeat;
- massa/physics básicos;
- constraints simples ou solução nativa temporária.

Prioridade: o jogador conseguir entrar, dirigir e sair.

---

# 8. Critérios de sucesso

- o projeto abre com Rojo;
- o player spawna a pé;
- o player se move a pé normalmente;
- existe um carro placeholder;
- ao chegar perto e apertar E, o player entra;
- W/S/A/D controlam o carro;
- câmera acompanha o carro;
- ao apertar E, o player sai;
- o HUD de input não atrapalha se debug estiver desligado;
- tudo é documentado.

---

# 9. Resposta esperada

Responder em: comunicacao-ia/opus/004-milestone-002-carro-placeholder.md

---

# 10. Observação final

M002 não precisa ser bonita.

M002 precisa provar que o jogo tem uma base jogável:

andar → entrar no carro → dirigir → sair
