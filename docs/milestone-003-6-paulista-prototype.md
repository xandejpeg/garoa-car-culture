# M003.6 — Avenida Paulista Prototype

**Status:** ✅ PASSOU — 29/04/2026  
**Pré-requisito:** M003.5 ✅ PASSOU (29/04/2026)

> **NOTA:** Esta NÃO é a Avenida Paulista final/real.  
> É um protótipo simbólico para dar identidade visual e motivação ao projeto.  
> A Paulista real (OSM, Meshy, assets brasileiros) é objetivo futuro — M008+.

---

## Objetivo

Testar o A-Chassis em um ambiente urbano mínimo inspirado na Av. Paulista.  
O objetivo é responder: **faz sentido dirigir aqui? A escala está boa? O carro parece São Paulo?**

---

## O que foi criado

`PaulistaPrototypeBuilder.server.lua` gera tudo programaticamente em `Workspace.PaulistaPrototype`.

| Elemento | Detalhe |
|---|---|
| Comprimento | 600 studs |
| Faixas | 4 por sentido |
| Canteiro central | 5 studs, grama |
| Calçadas | 9 studs cada lado |
| Guias/meio-fio | Simples |
| Faixas de pedestre | 3 cruzamentos falsos (Z=150, 300, 450) |
| Linhas de pista | Tracejadas brancas + amarelas no canteiro |
| Postes de luz | 20 postes alternados, lados opostos |
| Prédios | 27 blocos variados (concreto, cimento, vidro) |
| Estrutura MASP simbólica | 2 pilares vermelhos + bloco branco em Z=205 |
| Spawn do carro | Faixa direita, X≈9.25, Z=35 |

**TestTrack é suprimido automaticamente** quando PaulistaPrototype está presente.

---

## Checklist de teste

### Setup
- [ ] Rojo conectado (`localhost:34872`)
- [ ] Play sem erro vermelho
- [ ] `Workspace.PaulistaPrototype` aparece no Explorer
- [ ] Carro spawna na faixa direita (marcador amarelo, início da avenida)

### Ambiente
- [ ] Prédios visíveis dos dois lados
- [ ] Estrutura MASP simbólica visível (Z≈205, lado esquerdo)
- [ ] Postes de iluminação visíveis
- [ ] Calçadas e canteiro central visíveis

### Direção
- [ ] Carro anda pela reta principal
- [ ] Carro não fica preso em calçada ou prédio
- [ ] Câmera funciona com prédios nas laterais
- [ ] `F` sai do carro normalmente

### Feeling
- [ ] Ambiente mais motivante que a pista sintética?
- [ ] Escala da avenida parece adequada?
- [ ] Carro parece pequeno/grande demais?
- [ ] Sensação de "São Paulo" presente?

---

## Template de resultado (preencher após teste)

```
### PaulistaPrototype gerou sem erro?
Sim/Não

### Prédios apareceram?
Sim/Não

### Estrutura MASP visível?
Sim/Não

### Carro rodou pela avenida?
Sim/Não

### Câmera funcionou entre prédios?
Sim/Não

### Erros no Output:
(cole aqui)

### Feeling (comparando com pista sintética):
- Motivação: pior / igual / melhor
- Escala da rua: pequena / boa / grande
- Carro: parece pequeno / adequado / grande
- Sensação de SP: não / um pouco / sim
- Performance/FPS: ok / caiu
- O que falta:
- O que ficou bom:
```

---

## Critério de sucesso

M003.6 passa se:
- Ambiente gera sem erro
- Carro consegue andar pela avenida
- Ambiente é mais motivante que pista sintética
- Câmera funciona entre prédios
- Sem crash de performance

---

## Futuro — Paulista real (M008+)

O usuário quer ver no futuro uma Avenida Paulista mais fiel usando:
- Plugin **OSM To Roblox** (ruas reais + volumetria)
- **Meshy** / Blender para prédios customizados
- Assets brasileiros (Toolbox: Brazil City, Posto Ipiranga, sinalização)
- Semáforos, tráfego, pedestres, cruzamentos reais
- Iluminação noturna, atmosfera real de SP

**Isso é escopo M008+ — não implementar antes de validar M004, M005, M006.**

---

## Próximo passo após M003.6

Com base no feeling reportado:
- **Câmera/direção ruim** → M005 (feeling/câmera)
- **Controle OK, quer gamepad** → M004 (Gamepad/x360ce)
- **Drift não está respondendo** → M006 (drift/handbrake tune)
