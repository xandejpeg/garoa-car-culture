# M003 — Play Test Checklist

**Status:** ✅ PASSOU — 29/04/2026  
**Pré-requisito:** M000, M001, M002 concluídos

---

## Setup

- [x] `rojo serve` rodando (`localhost:34872`)
- [x] Roblox Studio conectado ao Rojo (plugin Rojo → Connect)
- [x] `ReplicatedStorage.Vehicles.TestCar` existe no Explorer
- [x] Output sem erro vermelho ao iniciar Play

## Spawn

- [x] Player spawna normalmente a pé
- [x] Carro A-Chassis aparece no mapa
- [x] Carro não explode, não cai, não fica ancorado

## Entrada

- [x] Prompt `[E] Entrar` aparece perto do carro
- [x] Tecla `E` entra no carro
- [x] Câmera muda para seguir o carro

## Direção

- [x] `W` acelera
- [x] `S` freia / reduz
- [x] `A` vira esquerda
- [x] `D` vira direita
- [x] `Espaço` aciona handbrake
- [x] `Q` sobe marcha (se modo manual/semi)
- [x] `Z` desce marcha (se modo manual/semi)

## Saída

- [x] `F` sai do carro
- [x] Player aparece fora do carro em posição segura
- [x] Câmera volta ao personagem
- [x] WASD volta a mover o personagem a pé

## Output

- [x] Nenhum erro vermelho
- [x] Mensagem `[VehicleSpawnService] A-Chassis spawned` aparece
- [x] Mensagem `[VehicleInputController] enabled` aparece ao entrar

---

## Template de resultado (copiar e preencher)

```
### Rojo conectou?
Sim/Não

### TestCar apareceu em ReplicatedStorage?
Sim/Não

### Carro spawnou no mapa?
Sim/Não

### Entrou com E?
Sim/Não

### Câmera seguiu o carro?
Sim/Não

### W acelerou?
Sim/Não

### S freou?
Sim/Não

### A/D viraram?
Sim/Não

### Espaço handbrake funcionou?
Sim/Não

### Q/Z tiveram efeito?
Sim/Não/N-A

### F saiu do carro?
Sim/Não

### Câmera voltou ao personagem?
Sim/Não

### Erros no Output:
(cole aqui)

### Feeling:
(pesado/leve, rápido/devagar, capota, câmera ruim, etc)
```

---

## Se M003 passar → M003.5 Test Track

Criar pista simples antes de M004:
- reta longa
- curva aberta e fechada
- área para handbrake
- blocos/cones simples

Objetivo: sentir aceleração, frenagem, curva, câmera antes de adicionar gamepad.
