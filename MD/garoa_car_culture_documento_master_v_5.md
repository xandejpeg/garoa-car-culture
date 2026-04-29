# 🚗 GAROA CAR CULTURE
## Documento Master de Produto, Técnica, Testes e Desenvolvimento
### Simulador Automotivo Realista — Cultura Brasileira / São Paulo / Roblox

---

# 0. STATUS DO DOCUMENTO

Este documento é a base viva do projeto **Garoa Car Culture**.

Ele serve para:

- manter a visão do jogo organizada;
- documentar todas as decisões importantes;
- guiar o desenvolvimento no VS Code + Roblox Studio;
- orientar o uso de IA como arquiteto, programador, designer de sistemas e auxiliar de produção;
- evitar que o jogo vire uma mistura desorganizada de ideias;
- permitir que cada sistema seja criado, testado, validado e só então expandido.

Este documento não deve ser tratado como um pitch curto.

Ele deve ser tratado como:

- documento de produto;
- documento técnico;
- bíblia de gameplay;
- mapa de arquitetura;
- guia de produção;
- guia para prompts enviados ao Opus no VS Code;
- histórico de evolução do projeto.

---

# 1. VISÃO DO PRODUTO

**Garoa Car Culture** é um jogo multiplayer no Roblox focado em simular a cultura automotiva brasileira com forte inspiração em São Paulo.

O jogo mistura:

- drift;
- corrida;
- No Hesi;
- mundo aberto;
- evolução de carro;
- mecânica profunda;
- tuning realista;
- progressão econômica;
- vida automotiva;
- direção com volante;
- física semi-realista;
- tráfego urbano e rodoviário;
- cultura gearhead.

A proposta não é criar apenas um jogo onde o jogador entra, escolhe um carro e acelera.

A proposta é criar uma experiência onde o jogador sente que está entrando em um ecossistema automotivo vivo.

O jogador deve sentir que:

- começou pequeno;
- ganhou seu primeiro carro com dificuldade;
- aprendeu a dirigir;
- aprendeu a mexer no carro;
- quebrou peças por erro próprio;
- evoluiu com conhecimento;
- dominou drift, trânsito, rodovia e tuning;
- construiu uma identidade dentro do jogo.

---

# 2. NOME DO JOGO

## 2.1 Nome principal

**Garoa Car Culture**

## 2.2 Sentido do nome

“Garoa” conecta o jogo diretamente com São Paulo, com a ideia de cidade grande, rua molhada, luz refletindo no asfalto, trânsito, noite, túnel, avenida, marginal, serra, oficina, posto, encontro de carro e cultura urbana.

“Car Culture” define que o jogo não é apenas corrida. É cultura de carro.

O nome permite o jogo abranger:

- JDM;
- euro cars;
- muscle cars;
- carros brasileiros;
- projetos turbo;
- carros aspirados;
- drift;
- rolê;
- meet;
- oficina;
- personalização;
- garagem;
- tuning;
- história de progressão;
- socialização.

---

# 3. POSICIONAMENTO

## 3.1 O que o jogo NÃO é

Garoa Car Culture não é:

- arcade simples;
- jogo de corrida casual genérico;
- simulador hardcore inacessível;
- apenas mapa bonito com carro;
- apenas drift point farm;
- apenas No Hesi copiado;
- apenas jogo de garagem;
- apenas Roblox car showcase.

## 3.2 O que o jogo É

Garoa Car Culture é:

- simulador automotivo acessível;
- jogo de cultura de carro;
- mundo aberto dividido em zonas;
- experiência focada em volante;
- jogo para gearheads;
- jogo de progressão real;
- jogo onde mecânica importa;
- jogo onde dirigir bem gera dinheiro;
- jogo onde tuning errado pode quebrar o carro;
- jogo onde o jogador precisa entender o próprio veículo.

## 3.3 Frase central

**Garoa Car Culture é um simulador de vida automotiva brasileira dentro do Roblox, onde dirigir, mexer, quebrar, consertar, evoluir e dominar o carro fazem parte da mesma experiência.**

---

# 4. PÚBLICO-ALVO

## 4.1 Público principal

O público principal é o jogador **gearhead**.

Ou seja:

- pessoa que gosta de carro de verdade;
- pessoa que entende ou quer entender mecânica;
- pessoa que gosta de preparação;
- pessoa que curte drift;
- pessoa que curte No Hesi;
- pessoa que curte volante;
- pessoa que gosta de simuladores;
- pessoa que valoriza carro com comportamento e personalidade.

## 4.2 Público secundário

Também pode atrair:

- jogadores de Roblox que gostam de carro;
- fãs de Midnight Chasers;
- fãs de CarX;
- fãs de Assetto Corsa;
- fãs de No Hesi;
- jogadores que gostam de roleplay urbano;
- jogadores que gostam de economia e progressão;
- jogadores que gostam de coleção de carros.

## 4.3 Consequência de design

Como o público principal é gearhead, o jogo não pode tratar carro como skin.

Cada carro precisa ter:

- comportamento;
- peso;
- tração;
- resposta;
- som;
- potencial de preparação;
- peças;
- limitações;
- risco de quebra;
- identidade.

---

# 5. PLATAFORMA

## 5.1 Plataforma inicial

O jogo será focado em:

- PC;
- Roblox Studio;
- teclado + mouse como base obrigatória;
- controle/gamepad como suporte importante;
- volante Logitech G29 via x360ce/XInput como modo avançado/ideal de direção.

## 5.2 Correção arquitetural importante

O jogo **não é volante-only**.

O volante é uma experiência ideal e avançada para quem quer máxima imersão na direção, mas o jogo precisa funcionar completo com teclado e mouse.

Motivo:

- o jogador precisa andar fora do carro;
- o jogador precisa interagir com garagem;
- o jogador precisa usar lojas, menus, oficinas e interfaces;
- nem todo jogador terá volante;
- o jogo precisa ser acessível para Roblox/PC;
- a progressão, exploração e economia não podem depender de volante.

Portanto, a arquitetura correta é:

```text
Input do jogador
├─ On-foot / personagem
│  ├─ teclado + mouse
│  ├─ câmera normal
│  ├─ andar
│  ├─ pular
│  ├─ interagir
│  └─ entrar/sair de veículo
│
├─ Vehicle / carro
│  ├─ teclado como base obrigatória
│  ├─ controle/gamepad como suporte
│  └─ volante via x360ce/XInput como modo avançado
│
└─ Garage/UI
   ├─ mouse
   ├─ teclado
   └─ suporte futuro a controle
```

## 5.3 Mobile

Mobile não é prioridade inicial.

Motivos:

- direção realista sofre no mobile;
- tuning complexo fica ruim no mobile;
- interface avançada de garagem fica pesada;
- tráfego e física exigem performance;
- a primeira versão deve priorizar PC.

## 5.4 Console

Console pode ser considerado no futuro, mas não no início.

---

# 6. FILOSOFIA DE DIREÇÃO

## 6.1 Direção semi-realista

A física desejada é **semi-realista**.

Isso significa:

- não é arcade puro;
- não é simulação hardcore impossível;
- deve parecer real;
- deve ser previsível;
- deve permitir drift controlado;
- deve funcionar bem com volante;
- deve ser fácil de começar;
- deve ser difícil de dominar.

## 6.2 Referências de feeling

O jogo mistura referências como:

- CarX Drift Racing para drift acessível;
- Assetto Corsa para base de comportamento real;
- No Hesi para tráfego e alta velocidade;
- Midnight Chasers para presença de tráfego contínuo e salas;
- Car Mechanic Simulator para profundidade mecânica.

## 6.3 Direção facilitada

Mesmo com comportamento realista, o jogador não deve sentir que precisa ser piloto profissional para jogar.

O jogo deve possuir assistências invisíveis:

- estabilização leve;
- suavização de volante;
- controle de rotação em baixa velocidade;
- recuperação parcial de drift;
- curva de input configurável;
- deadzone ajustável;
- resposta progressiva de pedal.

A assistência não deve parecer artificial.

Ela deve apenas tornar o carro dirigível.

---

# 7. SUPORTE A INPUT, TECLADO, CONTROLE E VOLANTE

## 7.1 Decisão atual do projeto

A arquitetura oficial de input do **Garoa Car Culture** é baseada em múltiplos contextos e múltiplos dispositivos.

O jogo deve funcionar com:

- teclado + mouse;
- controle/gamepad;
- volante Logitech G29 via x360ce/XInput.

O volante é uma prioridade de experiência para direção, mas **não é bloqueador absoluto do desenvolvimento**.

A base obrigatória do jogo é teclado + mouse.

## 7.2 Contextos de input

O sistema de input deve ser separado por contexto:

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

## 7.3 On-foot é obrigatório

O jogador precisa andar fora do carro.

Isso é parte central do jogo porque o Garoa Car Culture terá:

- hub social;
- garagem;
- oficina;
- lojas;
- encontros;
- portais físicos;
- interação com veículos;
- entrada e saída do carro;
- exploração de áreas.

Portanto, o input de personagem não pode ser tratado como detalhe secundário.

## 7.4 Teclado como base obrigatória

O teclado precisa controlar o carro desde o início.

Mapeamento inicial esperado:

- W: acelerar;
- S: frear/ré;
- A/D: direção;
- Space: freio de mão;
- E: entrar/sair/interagir;
- C ou V: trocar câmera;
- Shift/Ctrl: funções futuras.

O carro placeholder da Milestone 002 deve ser jogável por teclado antes de depender de volante.

## 7.5 Controle/gamepad

Controle/gamepad deve ser suportado como camada intermediária.

Ele também será a base técnica para o volante via x360ce, já que o x360ce fará o G29 aparecer como controle Xbox/XInput.

## 7.6 Volante via x360ce/XInput

O suporte a volante será baseado inicialmente no fluxo:

```text
Logitech G29 / volante físico
  ↓
x360ce / camada de emulação XInput
  ↓
Roblox reconhecendo como controle Xbox
  ↓
VehicleInput do jogo
```

O objetivo não é depender de suporte nativo perfeito do Roblox ao G29.

O objetivo é usar o método comum de PC: transformar o volante/pedais em entradas compatíveis com controle Xbox/XInput.

## 7.7 O que precisa ser testado

O InputTestHUD continua útil, mas agora ele não é uma trava absoluta para criar o primeiro carro placeholder.

Ele serve para:

- validar x360ce + Roblox;
- descobrir eixo real de direção;
- descobrir acelerador/freio;
- calibrar deadzone;
- calibrar sensibilidade;
- preparar suporte avançado a volante.

## 7.8 Nova ordem correta

A ordem oficial passa a ser:

1. Setup + Rojo + documentação;
2. arquitetura de input por contexto;
3. personagem/on-foot mantido funcional;
4. carro placeholder por teclado;
5. entrada/saída do veículo;
6. câmera básica;
7. gamepad/x360ce;
8. calibração G29;
9. física/feeling avançado.

## 7.9 Marco obrigatório revisado

O marco de input não é mais:

“o G29 precisa estar perfeito antes de tudo”.

O marco correto é:

**O jogo precisa ter input modular, com teclado como base e volante como camada avançada.**

---

# 8. SISTEMA DE CÂMERAS

## 8.1 Quantidade de câmeras

O jogo terá 4 câmeras principais:

1. Câmera externa traseira;
2. Câmera cockpit/interna;
3. Câmera cinematográfica externa;
4. Câmera superior.

## 8.2 Câmera externa traseira

Uso:

- direção geral;
- drift;
- players casuais;
- controle visual do carro.

Requisitos:

- seguir o carro suavemente;
- não tremer demais;
- permitir ver ângulo de drift;
- abrir campo de visão em alta velocidade;
- ajustar distância conforme velocidade.

## 8.3 Câmera cockpit

Uso:

- imersão;
- volante;
- No Hesi;
- gearheads.

Requisitos:

- interior minimamente realista;
- painel visível;
- velocímetro;
- conta-giros;
- volante animado se possível;
- sensação de velocidade;
- FOV ajustável.

## 8.4 Câmera cinematográfica

Uso:

- visual;
- gravação;
- screenshots;
- highlights;
- encontros de carro.

Requisitos:

- ângulos mais bonitos;
- leve atraso;
- foco no carro;
- sensação de câmera de filmagem.

## 8.5 Câmera superior

Uso:

- visão tática;
- testes;
- estacionamento;
- possível modo mecânico/garagem;
- mapa técnico.

## 8.6 Alternância

O jogador deve alternar câmeras rapidamente.

No volante, isso pode ser mapeado para botão.

No teclado, pode ser tecla padrão.

---

# 9. MUNDO E MAPA

## 9.1 Estrutura geral

O jogo não será um mapa único infinito.

Será um mundo dividido em **zonas grandes conectadas por portais físicos**.

Isso permite:

- sensação de mundo enorme;
- melhor performance;
- carregamento por área;
- servidores específicos por modo;
- expansão futura;
- controle de tráfego por zona;
- evitar que o Roblox sofra com um mapa contínuo gigante.

## 9.2 Zonas principais

O mundo terá, inicialmente, estas zonas:

- Hub Central;
- Cidade de São Paulo inspirada;
- Rodovias No Hesi;
- Serra/Touge;
- Pistas de drift;
- Oficinas e garagens;
- áreas futuras especiais.

## 9.3 Hub Central

O Hub Central é o ponto social.

Funções:

- spawn inicial;
- encontro de jogadores;
- lojas;
- oficina;
- garagem;
- aluguel de carro;
- acesso a portais;
- fila para servidores premium;
- visualização de carros;
- início de missões/trabalhos.

O Hub precisa parecer vivo.

Ele pode conter:

- posto de gasolina;
- oficina grande;
- estacionamento;
- avenida larga;
- túnel de acesso;
- viaduto;
- entrada de marginal;
- área de meet;
- lojas de peças;
- concessionária;
- leilão de usados no futuro.

## 9.4 Rodovias No Hesi

As rodovias são o núcleo de ganho de dinheiro inicial.

Características:

- alta velocidade;
- tráfego intenso;
- várias faixas;
- curvas longas;
- túneis;
- entradas e saídas;
- risco constante;
- recompensa por precisão.

Jogador ganha dinheiro por:

- passar perto de carros;
- manter velocidade alta;
- não bater;
- manter combo;
- dirigir por tempo sem colisão;
- fazer ultrapassagens arriscadas.

## 9.5 Cidade

A cidade representa a cultura urbana de São Paulo.

Características:

- avenidas;
- trânsito;
- faróis no futuro;
- cruzamentos;
- ruas menores;
- bairros;
- estacionamento;
- postos;
- oficinas;
- prédios;
- visual noturno forte.

A cidade serve para:

- rolê;
- socialização;
- missões;
- trabalhos;
- deslocamento;
- eventos;
- encontros.

## 9.6 Serra / Touge

A serra é a área técnica de drift.

Características:

- curvas fechadas;
- descidas;
- subidas;
- hairpins;
- guard rails;
- baixa iluminação;
- risco alto;
- recompensa por controle.

Serve para:

- drift técnico;
- treino;
- corridas 1v1;
- eventos de comunidade;
- ranking por trecho.

## 9.7 Pistas de drift

Áreas fechadas para treino e competição.

Características:

- cones;
- clipping points;
- zonas de pontuação;
- ranking;
- eventos;
- menos tráfego;
- foco em habilidade pura.

---

# 10. SISTEMA DE PORTAIS

## 10.1 Conceito

Os portais não devem parecer menu artificial.

Eles devem ser integrados no mapa.

Exemplos:

- túnel para rodovia;
- entrada de serra;
- cancela de pista;
- rampa de estacionamento;
- viaduto;
- pedágio;
- garagem subterrânea;
- entrada de oficina.

## 10.2 Função técnica

Portais permitem:

- trocar o jogador de servidor;
- carregar outra zona;
- reduzir peso do mapa;
- controlar quantidade de players;
- separar tráfego por região;
- aplicar regras específicas por área.

## 10.3 Exemplo de fluxo

Jogador nasce no Hub.

Ele dirige até um túnel.

O túnel tem placa indicando Rodovia.

Ao entrar, o jogo:

- confirma zona;
- procura servidor disponível;
- coloca na fila se necessário;
- teleporta para rodovia;
- carrega o carro do jogador;
- mantém status do veículo.

---

# 11. MULTIPLAYER

## 11.1 Estrutura de servidores

O jogo terá dois tipos principais de experiência multiplayer:

### Servidores leves

- até 20 jogadores;
- gameplay principal;
- rodovias;
- cidade;
- serra;
- menor custo de performance.

### Servidor central / premium

- até 100 jogadores;
- foco social;
- hub gigante;
- fila de entrada;
- prioridade para membros/premium;
- encontros e eventos.

## 11.2 Por que separar

Física de carro + tráfego + multiplayer é pesado.

Separar servidores ajuda a manter:

- estabilidade;
- FPS;
- física mais confiável;
- tráfego mais previsível;
- menos lag.

## 11.3 Sincronização de carros

A sincronização precisa ser pragmática.

Opção provável:

- cada jogador controla seu carro localmente;
- servidor valida posição/velocidade;
- outros jogadores veem interpolação suavizada;
- colisão entre players pode ser simplificada;
- física completa não precisa rodar igual para todos.

## 11.4 Decisão pendente

Precisamos testar:

- impacto de 5 carros;
- impacto de 10 carros;
- impacto de 20 carros;
- tráfego NPC junto;
- latência;
- colisão.

A decisão final de física multiplayer será tomada após protótipos.

---

# 12. TRÁFEGO NPC — NO HESI CORE

## 12.1 Objetivo

O tráfego é um dos sistemas mais importantes do jogo.

Ele cria:

- risco;
- adrenalina;
- gameplay constante;
- oportunidade de ganho;
- sensação de cidade viva;
- desafio estilo No Hesi.

## 12.2 Referência de comportamento

Inicialmente, o tráfego deve funcionar de forma parecida com jogos como Midnight Chasers:

- carros sempre presentes;
- surgem em áreas fora do acesso do jogador;
- seguem caminhos definidos;
- têm velocidades variadas;
- criam fluxo constante;
- não precisam ser extremamente inteligentes no início.

## 12.3 Sistema inicial

MVP do tráfego:

- lanes fixas;
- pontos de spawn fora da visão;
- pontos de despawn depois de certo trecho;
- velocidade aleatória dentro de faixa;
- modelos simples;
- colisão básica;
- reaproveitamento por pooling.

## 12.4 Sistema avançado futuro

Depois:

- troca de faixa;
- reação ao player;
- frenagem;
- variação de agressividade;
- veículos lentos e rápidos;
- caminhões;
- motos;
- ônibus;
- densidade por horário;
- comportamento urbano diferente de rodoviário.

## 12.5 Performance

Tráfego deve usar otimização agressiva:

- carros NPC simplificados;
- física reduzida;
- colisão leve;
- modelos low-poly;
- pooling;
- spawn baseado em distância;
- atualização reduzida longe do player;
- despawn automático.

---

# 13. DIREÇÃO E FÍSICA

## 13.1 Objetivo da física

A física precisa entregar:

- sensação realista;
- controle com volante;
- drift possível;
- alta velocidade estável;
- colisão com consequência;
- tuning que muda comportamento;
- carros com personalidade.

## 13.2 Prioridade inicial

Prioridade definida pelo usuário:

**sensação de velocidade e experiência No Hesi**.

Isso significa que, no MVP, o foco inicial não será desmontar motor completo nem mapa gigante.

O foco inicial será:

- carro controlável;
- volante funcionando;
- rodovia;
- tráfego;
- velocidade;
- risco/recompensa;
- dinheiro básico;
- dano simples.

## 13.3 Componentes físicos importantes

O sistema de carro deve considerar:

- massa;
- torque;
- potência;
- curva de torque;
- tração;
- grip longitudinal;
- grip lateral;
- transferência de peso;
- suspensão;
- centro de massa;
- aerodinâmica simplificada;
- freio;
- diferencial;
- pneu;
- marcha;
- embreagem;
- estabilidade.

## 13.4 Slip angle

Slip angle é um conceito central para drift.

Ele representa a diferença entre:

- direção que o carro está apontando;
- direção real em que ele está se movendo.

Quanto maior o slip angle controlado, maior a sensação de drift.

Mas se passar do limite:

- carro roda;
- perde controle;
- perde combo;
- pode bater.

## 13.5 Assistências invisíveis

Para ser jogável, o carro pode ter assistências discretas:

- anti-spin leve;
- suavização de contraesterço;
- controle de yaw em baixa velocidade;
- redução de instabilidade extrema;
- curva de acelerador;
- curva de freio;
- estabilidade em linha reta.

Essas assistências precisam ser calibradas para não parecerem arcade.

## 13.6 Física de impacto

O impacto precisa ter consequência.

Dano deve considerar:

- velocidade;
- massa;
- ângulo;
- parte atingida;
- estado da peça;
- força acumulada.

No começo, dano pode ser simplificado.

Depois, vira sistema avançado.

---

# 14. SISTEMA DE DANO

## 14.1 Fases do dano

### Fase 1 — dano simples

- colisão reduz vida do carro;
- perda de performance;
- custo de reparo.

### Fase 2 — dano por componente

- motor;
- suspensão;
- roda;
- transmissão;
- turbo;
- radiador;
- chassi.

### Fase 3 — dano visual

- para-choque;
- capô;
- faróis;
- rodas desalinhadas;
- fumaça;
- vazamento;
- deformação limitada.

## 14.2 Quebra do carro

O carro pode chegar ao ponto de:

- não ligar;
- superaquecer;
- perder marcha;
- perder turbo;
- quebrar suspensão;
- estourar motor;
- ficar sem condições de rodar.

## 14.3 Consequência de ficar sem carro

Se o jogador perder o carro, ele pode:

- chamar guincho;
- pagar conserto;
- vender sucata;
- alugar carro;
- trabalhar para recuperar dinheiro;
- pegar empréstimo no futuro;
- começar novo projeto.

---

# 15. MECÂNICA PROFUNDA

## 15.1 Filosofia

A garagem é um dos pilares mais fortes do jogo.

Ela deve ser quase um jogo dentro do jogo.

A referência é algo próximo de Car Mechanic Simulator, mas adaptado ao Roblox e à progressão multiplayer.

## 15.2 Nível desejado

O usuário deseja:

- abrir motor peça por peça;
- trocar materiais;
- fazer swap de motor;
- fazer swap de câmbio;
- montar errado e quebrar;
- preparar motor;
- mexer em turbo;
- mexer em ECU;
- mexer em suspensão;
- criar projetos automotivos reais.

## 15.3 Componentes do motor

Possíveis componentes:

- bloco;
- cabeçote;
- pistões;
- anéis;
- bielas;
- virabrequim;
- comando;
- válvulas;
- molas de válvula;
- junta de cabeçote;
- coletor de admissão;
- coletor de escape;
- bomba de óleo;
- bomba de combustível;
- injetores;
- velas;
- bobinas;
- radiador;
- intercooler;
- turbo;
- wastegate;
- downpipe;
- escapamento.

## 15.4 Transmissão

Componentes:

- câmbio;
- embreagem;
- volante do motor;
- diferencial;
- semieixos;
- relação final;
- tipo de tração.

## 15.5 Suspensão

Componentes:

- molas;
- amortecedores;
- coilovers;
- braços;
- buchas;
- barras estabilizadoras;
- cambagem;
- caster;
- toe;
- altura.

## 15.6 Pneus e rodas

Parâmetros:

- largura;
- composto;
- pressão;
- desgaste;
- aderência;
- temperatura futura;
- tipo de pneu.

## 15.7 Materiais

As peças podem ter materiais/qualidades:

- OEM comum;
- reforçado;
- performance;
- competição;
- forjado;
- barato paralelo;
- usado;
- sucata;
- premium.

Cada material muda:

- durabilidade;
- peso;
- preço;
- resistência ao calor;
- resistência a torque;
- chance de falha;
- valor de revenda.

## 15.8 Erro de montagem

O jogo deve permitir erro.

Exemplos:

- peça incompatível;
- torque incorreto;
- combustível inadequado;
- pressão de turbo alta demais;
- AFR perigoso;
- peça fraca para potência;
- câmbio incompatível;
- diferencial errado;
- suspensão mal alinhada.

Erro gera consequência.

---

# 16. TUNING PROFUNDO

## 16.1 Filosofia

Tuning não é só slider bonito.

Tuning deve mudar o comportamento real do carro.

## 16.2 Ajustes possíveis

### Motor

- pressão de turbo;
- limite de giro;
- mapa de combustível;
- ignição;
- AFR;
- corte de giro;
- resposta de acelerador.

### Transmissão

- relação de marcha;
- relação final;
- tipo de diferencial;
- bloqueio do diferencial;
- embreagem.

### Suspensão

- altura;
- rigidez;
- amortecimento;
- cambagem;
- caster;
- toe;
- barra estabilizadora.

### Pneu

- largura;
- composto;
- pressão;
- desgaste.

### Freio

- força;
- bias frente/trás;
- ABS futuro;
- handbrake.

## 16.3 Consequências reais

Tuning pode:

- melhorar aceleração;
- piorar controle;
- aumentar chance de quebra;
- superaquecer motor;
- destruir câmbio;
- deixar carro instável;
- melhorar drift;
- piorar No Hesi;
- melhorar grip;
- consumir mais combustível.

## 16.4 Perfil de build

O jogador pode criar builds como:

- build drift;
- build No Hesi;
- build drag;
- build touge;
- build daily;
- build sleeper;
- build stance;
- build grip;
- build show car.

---

# 17. CARROS

## 17.1 Filosofia dos carros

O usuário quer carros reais, idênticos à vida real.

Porém, isso precisa ser tratado com cuidado por causa de marcas, direitos e uso dentro do Roblox.

A abordagem inicial recomendada:

- começar com modelos inspirados em carros reais;
- evitar nomes oficiais no início;
- manter proporção, cultura e feeling;
- decidir depois estratégia legal/comercial.

## 17.2 Pipeline inicial de carros

Caminho recomendado:

1. comprar/baixar modelo legalmente;
2. abrir no Blender;
3. verificar licença;
4. reduzir polígonos;
5. separar partes principais;
6. ajustar escala;
7. criar colisão simplificada;
8. separar rodas;
9. preparar pivôs;
10. exportar para Roblox;
11. testar performance;
12. integrar com chassis/física.

## 17.3 Meshy

Meshy foi comprado e será usado como ferramenta auxiliar.

Uso ideal do Meshy:

- props;
- peças genéricas;
- objetos de oficina;
- ferramentas;
- cones;
- placas;
- decoração;
- assets de cenário;
- ideias rápidas;
- protótipos.

Meshy não deve ser a única fonte de carros principais.

Carros principais devem vir de:

- modelos comprados;
- modelagem manual;
- ajustes em Blender;
- otimização cuidadosa.

## 17.4 Blender

Blender é obrigatório.

Será usado para:

- limpeza de mesh;
- otimização;
- ajuste de escala;
- separação de peças;
- preparação de rodas;
- pivôs;
- materiais;
- colisão;
- exportação;
- adaptação para Roblox.

---

# 18. ECONOMIA

## 18.1 Visão geral

A economia precisa reforçar a cultura automotiva.

Dinheiro não deve vir só de corrida.

O jogador pode ganhar dinheiro com:

- No Hesi;
- drift;
- corridas;
- trabalhos;
- aluguel de carro;
- eventos;
- missões;
- entrega;
- mecânica no futuro;
- revenda.

## 18.2 Gasto

O jogador gasta com:

- peças;
- manutenção;
- combustível;
- pneus;
- reparo;
- pintura;
- oficina;
- aluguel;
- guincho;
- carros;
- upgrades;
- cosméticos;
- acesso premium.

## 18.3 Progressão inicial

Jogador começa com:

- pouco dinheiro;
- carro fraco;
- baixo risco de quebra no início;
- sistemas simplificados.

Depois, conforme evolui:

- carros quebram mais;
- tuning fica mais arriscado;
- manutenção pesa;
- escolhas importam.

## 18.4 Primeira fonte de dinheiro

O No Hesi na rodovia deve ser uma das principais formas iniciais de ganhar dinheiro.

Isso conecta com a prioridade do jogador:

- sensação de velocidade;
- tráfego;
- risco;
- recompensa.

---

# 19. MONETIZAÇÃO

## 19.1 Desejo do usuário

O usuário quer monetizar de várias formas.

Possibilidades:

- premium/fila;
- carros especiais;
- cosméticos;
- passes;
- garagem expandida;
- slots de carro;
- acesso antecipado;
- eventos;
- oficinas premium;
- pinturas;
- rodas;
- placas;
- itens de personalização;
- assinatura/membro.

## 19.2 Cuidado

O jogo não deve virar pay-to-win extremo.

Se monetizar mal, destrói a credibilidade gearhead.

Melhor caminho:

- vender conveniência;
- vender cosmético;
- vender acesso social;
- vender slots;
- vender conteúdo premium sem quebrar equilíbrio;
- permitir que jogador dedicado também evolua jogando.

## 19.3 Premium queue

Servidor central premium pode ter:

- fila;
- prioridade para membros;
- acesso VIP;
- eventos exclusivos;
- encontros grandes.

---

# 20. PROGRESSÃO DO JOGADOR

## 20.1 Começo

O jogador começa com:

- carro simples;
- baixa potência;
- pouca grana;
- garagem limitada;
- pouca reputação.

## 20.2 Meio do jogo

O jogador começa a:

- fazer upgrades;
- entrar em eventos;
- ganhar dinheiro melhor;
- comprar peças;
- testar tuning;
- escolher estilo;
- construir build.

## 20.3 Endgame

O jogador avançado pode:

- ter vários carros;
- participar de eventos premium;
- criar builds complexas;
- dominar ranking;
- virar referência;
- ter garagem grande;
- mexer em setups profundos;
- participar de meet.

---

# 21. SISTEMAS FUTUROS SENSÍVEIS

## 21.1 Consumo, álcool, drogas etc.

O usuário mencionou desejo futuro de sistemas de consumo e vida social.

Porém, por causa de regras de plataforma, moderação, público e riscos, isso deve ficar para muito depois e provavelmente precisará ser tratado de forma abstrata ou removido.

Prioridade atual:

- carro;
- direção;
- tuning;
- economia;
- tráfego;
- garagem.

## 21.2 Regra de produção

Nada sensível deve ser construído no MVP.

---

# 22. ROADMAP DE DESENVOLVIMENTO

## 22.1 Fase 0 — Setup

Objetivo:

- preparar ambiente;
- instalar ferramentas;
- criar estrutura inicial;
- validar workflow.

Inclui:

- Roblox Studio;
- VS Code;
- Rojo;
- Git;
- GitHub;
- Blender;
- Meshy;
- organização de pastas;
- documento master;
- primeiro place de teste.

## 22.2 Fase 1 — Input e volante

Objetivo:

- testar G29;
- mapear eixos;
- criar HUD de input;
- controlar objeto simples;
- validar se o volante funciona.

Entrega:

- Input Test Place;
- script de leitura de input;
- tela de diagnóstico;
- relatório do que funciona.

## 22.3 Fase 2 — Chassis básico

Objetivo:

- criar primeiro carro funcional;
- mover com teclado;
- depois volante;
- testar aceleração, freio e direção.

Entrega:

- carro placeholder;
- física simples;
- câmera externa;
- câmera cockpit básica.

## 22.4 Fase 3 — Rodovia MVP

Objetivo:

- criar trecho de rodovia;
- spawn de tráfego simples;
- testar velocidade;
- testar desvio;
- testar performance.

Entrega:

- mapa rodovia;
- 2 a 3 lanes;
- NPC traffic simples;
- sistema de despawn.

## 22.5 Fase 4 — No Hesi dinheiro básico

Objetivo:

- transformar rodovia em gameplay.

Entrega:

- pontuação por near miss;
- combo;
- dinheiro;
- reset ao bater;
- HUD de velocidade e ganho.

## 22.6 Fase 5 — Multiplayer pequeno

Objetivo:

- testar 2, 5, 10, 20 players;
- sincronizar carros;
- medir performance;
- decidir arquitetura.

Entrega:

- servidor de teste;
- sync básico;
- análise de performance.

## 22.7 Fase 6 — Garagem simples

Objetivo:

- criar primeira garagem;
- trocar peça simples;
- salvar estado do carro.

Entrega:

- UI de garagem;
- troca de peça inicial;
- persistência básica.

## 22.8 Fase 7 — Tuning inicial

Objetivo:

- tuning que muda comportamento.

Entrega:

- turbo slider;
- suspensão básica;
- diferencial básico;
- risco de quebra simplificado.

## 22.9 Fase 8 — Expansão

Objetivo:

- cidade;
- hub;
- portal;
- serra;
- mais carros;
- economia completa;
- monetização.

---

# 23. COMO VAMOS TESTAR O JOGO

## 23.1 Regra principal

Nada deve ser construído grande sem teste pequeno antes.

O processo será:

1. definir sistema;
2. criar protótipo mínimo;
3. testar no Roblox Studio;
4. validar com volante se aplicável;
5. medir performance;
6. corrigir;
7. documentar;
8. só então expandir.

## 23.2 Teste 1 — Setup

Verificar:

- VS Code abre projeto;
- Rojo conecta;
- Roblox Studio recebe arquivos;
- Git salva alterações;
- estrutura de pastas está limpa.

Critério de sucesso:

- editar script no VS Code e ver no Roblox Studio.

## 23.3 Teste 2 — Input do G29

Verificar:

- Roblox detecta volante;
- Roblox detecta acelerador;
- Roblox detecta freio;
- Roblox detecta embreagem;
- botões aparecem;
- eixos são utilizáveis.

Critério de sucesso:

- valores analógicos aparecem na tela em tempo real.

## 23.4 Teste 3 — Controle básico

Verificar:

- volante vira um objeto;
- acelerador move;
- freio reduz;
- direção tem curva suave.

Critério de sucesso:

- player consegue dirigir um carro placeholder com G29.

## 23.5 Teste 4 — Chassis

Verificar:

- carro anda;
- freia;
- vira;
- não capota sem motivo;
- responde ao peso;
- funciona com câmera.

Critério de sucesso:

- dirigir por 2 minutos sem bugs graves.

## 23.6 Teste 5 — Rodovia

Verificar:

- velocidade alta;
- escala da pista;
- sensação de velocidade;
- câmera funciona;
- FPS estável.

Critério de sucesso:

- dirigir rápido em linha/curvas sem travar.

## 23.7 Teste 6 — Tráfego

Verificar:

- NPCs spawnam;
- andam em lanes;
- despawnam;
- não acumulam infinitamente;
- não destroem FPS.

Critério de sucesso:

- rodovia com tráfego por alguns minutos sem colapso.

## 23.8 Teste 7 — No Hesi loop

Verificar:

- near miss detectado;
- combo sobe;
- dinheiro entra;
- bater reseta combo;
- HUD mostra progresso.

Critério de sucesso:

- gameplay divertido por 5 minutos.

## 23.9 Teste 8 — Dano simples

Verificar:

- colisão gera dano;
- dano reduz performance;
- reparo custa dinheiro;
- carro pode ficar ruim.

Critério de sucesso:

- impacto tem consequência clara.

## 23.10 Teste 9 — Multiplayer

Verificar:

- dois players se veem;
- posições sincronizam;
- carros não teleportam muito;
- tráfego continua estável.

Critério de sucesso:

- 5 players jogam sem quebrar a experiência.

---

# 24. COMO VAMOS TRABALHAR COM IA

## 24.1 Papel do ChatGPT

Este chat será o centro de arquitetura.

Funções:

- manter documento master;
- decidir ordem de construção;
- escrever prompts para Opus;
- revisar respostas do Opus;
- transformar erros em próximos passos;
- evitar escopo impossível;
- documentar decisões;
- criar roadmap;
- criar sistemas conceituais.

## 24.2 Papel do Opus no VS Code

O Opus será executor técnico.

Funções:

- criar arquivos;
- configurar Rojo;
- escrever código Luau;
- rodar comandos;
- organizar módulos;
- ler erros;
- implementar sistemas pequenos;
- gerar relatórios de alterações.

## 24.3 Papel do usuário

O usuário será diretor criativo e testador principal.

Funções:

- explicar visão;
- testar no volante;
- dizer se o feeling está certo;
- validar o jogo rodando;
- decidir prioridades;
- fornecer assets e ideias;
- colar erros e resultados aqui.

## 24.4 Regra de comunicação com o Opus

Todo prompt para Opus deve conter:

- objetivo específico;
- escopo limitado;
- o que não fazer;
- arquivos esperados;
- critério de sucesso;
- pedido de relatório final.

Nunca mandar o Opus “fazer o jogo inteiro”.

---

# 25. STACK TÉCNICA

## 25.1 Ferramentas principais

- Roblox Studio;
- VS Code;
- Rojo;
- Git;
- GitHub;
- Blender;
- Meshy;
- IA de código no VS Code;
- ChatGPT como arquiteto.

## 25.2 Estrutura inicial recomendada

Possível estrutura:

```text
GaroaCarCulture/
  docs/
    master.md
    testing.md
    roadmap.md
    vehicle_system.md
    traffic_system.md
  src/
    client/
      controllers/
      ui/
      camera/
      input/
    server/
      services/
      economy/
      traffic/
      persistence/
    shared/
      config/
      vehicle/
      types/
      utils/
  assets/
    vehicles/
    props/
    maps/
  rojo/
    default.project.json
  README.md
```

## 25.3 Princípio de arquitetura

Separar:

- input;
- veículo;
- física;
- câmera;
- UI;
- tráfego;
- economia;
- persistência;
- garagem;
- tuning.

Nada deve ficar tudo em um script gigante.

---

# 26. MVP REALISTA

## 26.1 O MVP não é o jogo completo

O MVP deve provar que o projeto é possível.

MVP precisa responder:

- volante funciona?
- carro é divertido?
- rodovia dá sensação de velocidade?
- tráfego funciona?
- gameplay No Hesi gera dinheiro?
- performance aguenta?

## 26.2 MVP recomendado

MVP inicial:

- 1 carro placeholder;
- 1 trecho de rodovia;
- 1 câmera externa;
- 1 câmera cockpit simples;
- input teclado + tentativa G29;
- tráfego simples;
- near miss;
- dinheiro básico;
- dano simples;
- sem garagem profunda ainda;
- sem cidade gigante ainda;
- sem 100 players ainda.

## 26.3 Por que esse MVP

Porque ele testa o coração do jogo:

- direção;
- volante;
- No Hesi;
- tráfego;
- sensação de velocidade;
- loop de dinheiro.

Se isso for ruim, o resto não importa.

---

# 27. BACKLOG DE SISTEMAS

## 27.1 Sistemas obrigatórios

- input G29;
- chassis;
- câmera;
- rodovia;
- tráfego;
- near miss;
- economia básica;
- dano simples;
- garagem;
- tuning;
- persistência;
- multiplayer.

## 27.2 Sistemas avançados

- desmontagem peça por peça;
- motor completo;
- materiais;
- swap;
- tuning avançado;
- servidores premium;
- cidade;
- serra;
- ranking;
- eventos;
- comércio entre players;
- oficina de players;
- leilão;
- polícia futura;
- clima;
- ciclo dia/noite;
- som avançado.

## 27.3 Sistemas para depois

- consumo/vida social sensível;
- RP pesado;
- sistemas fora do foco automotivo;
- mapa gigante demais;
- deformação visual complexa;
- 100 players com física completa.

---

# 28. DECISÕES JÁ TOMADAS

- Nome: Garoa Car Culture.
- Plataforma inicial: PC.
- Volante G29 é prioridade.
- Física: semi-realista.
- Direção: facilitada, mas com profundidade.
- Público: gearheads.
- Mundo: múltiplas áreas conectadas por portais.
- Tráfego: intenso, especialmente em rodovias.
- Multiplayer: servidores leves de até 20; servidor central/premium maior.
- Progressão: começa com carro fraco e evolui.
- Mecânica: profunda, peça por peça no futuro.
- Tuning: real, com risco de quebra.
- Visual: realista inspirado em São Paulo.
- Meshy comprado e será usado como ferramenta auxiliar de 3D.
- Blender será obrigatório no pipeline.
- Desenvolvimento coordenado por este chat + execução no VS Code com Opus.

---

# 29. DECISÕES PENDENTES

- Nome legal final dos carros.
- Grau de uso de marcas reais.
- Como Roblox detecta o G29 na prática.
- Arquitetura final de física multiplayer.
- Dano visual no MVP ou só depois.
- Sistema de polícia.
- Sistema de combustível.
- Ciclo dia/noite.
- Clima e chuva.
- Som realista de motor.
- Interface visual da garagem.
- Primeira lista de carros.
- Primeira região do mapa.
- Estratégia de monetização balanceada.

---

# 30. PRÓXIMO PASSO IMEDIATO

O próximo passo não é criar garagem nem cidade gigante.

O próximo passo é preparar o ambiente e criar o primeiro teste técnico.

## 30.1 Ordem imediata

1. Criar repositório do projeto.
2. Configurar VS Code.
3. Configurar Rojo.
4. Conectar Roblox Studio.
5. Criar estrutura inicial.
6. Criar Input Test Place.
7. Testar G29.
8. Documentar resultado.
9. Criar primeiro carro placeholder.
10. Testar direção básica.

## 30.2 Critério de sucesso da primeira etapa

A primeira etapa só termina quando:

- VS Code sincroniza com Roblox Studio;
- existe um place de teste;
- existe HUD de input;
- o G29 foi testado;
- sabemos o que funciona e o que não funciona.

---

# 31. PRIMEIRO PROMPT PARA OPUS NO VS CODE

O primeiro prompt para o Opus deve ser focado em setup.

Ele não deve criar o jogo inteiro.

Ele deve:

- preparar estrutura;
- não inventar sistemas avançados;
- criar documentação inicial;
- configurar Rojo;
- criar base para Input Test.

Prompt será escrito separadamente quando o usuário pedir.

---

# 32. REGRA DE OURO DO PROJETO

Não construir sistema gigante sem teste jogável.

A ordem correta é:

- testar;
- sentir;
- ajustar;
- documentar;
- expandir.

O jogo será guiado pelo feeling.

Principalmente porque volante e carro não se resolvem só com documento.

O usuário precisa dirigir, sentir e dizer:

- está pesado;
- está leve;
- está sem força;
- está escorregando demais;
- está arcade demais;
- está difícil demais;
- está bom.

---

# 33. VISÃO FINAL DE LONGO PRAZO

No futuro, Garoa Car Culture deve permitir que um jogador:

- entre no Hub em São Paulo;
- veja outros players e carros;
- pegue seu carro na garagem;
- vá para a rodovia;
- faça No Hesi no trânsito;
- ganhe dinheiro;
- bata e danifique o carro;
- volte para oficina;
- troque peça;
- ajuste turbo;
- erre o acerto e quebre motor;
- trabalhe para recuperar grana;
- alugue carro;
- compre peças melhores;
- monte um projeto;
- vá para serra fazer drift;
- encontre outros players;
- participe de eventos;
- construa reputação;
- tenha sua própria garagem;
- viva a cultura automotiva dentro do Roblox.

---

# 34. CONTADOR DE LINHAS

LINHAS TOTAIS ESTIMADAS DESTE DOCUMENTO: 1218

Última atualização conceitual:

- adicionada visão completa de testes;
- adicionada arquitetura de trabalho com IA;
- adicionada stack técnica;
- adicionada estratégia de MVP;
- adicionada seção de G29;
- adicionada seção de tráfego;
- adicionada seção de garagem/mecânica;
- adicionada estratégia de portais;
- adicionada ordem real de desenvolvimento;
- adicionada lista de decisões tomadas e pendentes.

