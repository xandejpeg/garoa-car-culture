# M003.5 — Test Track: Pista de Teste Programática

**Status:** ✅ PASSOU — 29/04/2026  
**Pré-requisito:** M003 ✅ PASSOU (29/04/2026)

---

## Objetivo

Criar uma pista de teste mínima para validar o feeling do A-Chassis antes de adicionar gamepad, câmera avançada ou mapa de SP.

A pista é **gerada por script** — sem assets externos, sem Toolbox, sem OSM.

---

## Como funciona

`TestTrackBuilder.server.lua` roda ao iniciar o servidor e cria toda a geometria programaticamente em `Workspace.TestTrack`.

Se `TestTrack` já existe, o script aborta sem duplicar.

---

## Layout da pista

```
[Spawn] → [RETA PRINCIPAL: 300 studs] → [CURVA AMPLA →] → [RETA LIGAÇÃO: 120] →
→ [CURVA FECHADA →] → [RETA RETORNO: 225] → [CONECTOR] → [ÁREA DE DRIFT 120×120]
```

| Seção | Descrição | Objetivo de teste |
|---|---|---|
| **Reta principal** | 300 studs, barreiras laterais, zona de frenagem | Aceleração, velocidade máxima, frenagem |
| **Curva ampla** | 90° com R=50, 4 segmentos | Estabilidade em velocidade, subesterço |
| **Reta de ligação** | 120 studs em +X | Transição entre curvas |
| **Curva fechada** | 90° com R=25, 3 segmentos | Freio, entrada de curva, sobreesterço |
| **Reta de retorno** | 225 studs paralela à principal | Frenagem, controle |
| **Área de drift** | 120×120, cones em anel, barreiras | Handbrake, sobreesterço, drift livre |

**Spawn do carro:** X=0, Y=3, Z=20 (início da reta principal — alinhado com VehicleSpawnService)

---

## Checklist de teste

### Setup
- [ ] Rojo conectado (`localhost:34872`)
- [ ] Play sem erro vermelho
- [ ] `Workspace.TestTrack` aparece no Explorer
- [ ] Carro spawna no início da reta (marcador amarelo)

### Reta principal
- [ ] `W` acelera na reta
- [ ] Zona de frenagem visível (linhas brancas antes da curva)
- [ ] `S` freia antes da curva ampla

### Curva ampla
- [ ] Carro navega a curva em velocidade média/alta
- [ ] Carro não capota nem sai da pista

### Curva fechada
- [ ] Necessário frear antes
- [ ] Handbrake (`Espaço`) tem efeito na entrada

### Área de drift
- [ ] Carro chega à área pelo conector
- [ ] Handbrake inicia sobreesterço
- [ ] Carro consegue fazer arcos ao redor dos cones

### Saída
- [ ] `F` sai do carro em qualquer seção
- [ ] Câmera volta ao personagem
- [ ] Sem erros no Output

---

## Template de resultado (preencher após teste)

```
### TestTrack gerou sem erro?
Sim/Não

### Carro chegou à curva ampla?
Sim/Não

### Curva ampla navegável?
Sim/Não

### Curva fechada exigiu frear?
Sim/Não

### Drift area funcionou?
Sim/Não

### Handbrake teve efeito real?
Sim/Não

### Carro capotou?
Sim/Não / Às vezes

### Erros no Output:
(cole aqui)

### Feeling:
- Aceleração: lenta / boa / rápida
- Frenagem: fraca / boa / forte
- Direção: leve / boa / pesada
- Velocidade geral: lenta / boa / rápida
- Câmera: ajuda / atrapalha
- Escala da pista: pequena / boa / grande
- Observações livres:
```

---

## Critério de sucesso

M003.5 passa se:
- Pista gera automaticamente sem erro
- Carro consegue percorrer reta + curva ampla
- Handbrake tem efeito visual na área de drift
- Sem crash/capota frequente

Não precisa estar bonito — precisa ser útil.

---

## Próximo passo após M003.5

Com base no feeling reportado:
- **Câmera/direção ruins** → M005 primeiro (feeling/câmera)
- **Controle OK, quer gamepad** → M004 (Gamepad/x360ce)
