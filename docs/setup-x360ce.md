# Setup x360ce — Garoa Car Culture

**Objetivo:** fazer o G29 ser lido pelo Roblox como se fosse um controle Xbox/XInput.

Não estamos tentando usar suporte nativo do Roblox ao G29.

O fluxo correto é:

```
G29 (volante físico)
↓
x360ce (emulador XInput)
↓
Roblox enxerga como Gamepad/Controle Xbox
↓
InputTestHUD mostra os valores em tempo real
```

---

## Por que x360ce?

O Roblox aceita entrada de gamepad via **XInput** (padrão Xbox). O G29 usa um protocolo diferente (DirectInput). O x360ce faz a tradução entre os dois, sem necessidade de qualquer driver especial no Roblox.

---

## Pré-requisitos

- Logitech G HUB instalado e G29 reconhecido pelo Windows
- x360ce baixado (versão **x64**)
  - Download: https://www.x360ce.com ou GitHub oficial
- Roblox Studio instalado

---

## Passo a passo

### 1. Confirmar G29 no Windows

1. Abrir **Logitech G HUB**
2. Confirmar que o G29 aparece e responde
3. Abrir **Painel de Controle → Dispositivos de Jogo** (joy.cpl)
4. Confirmar que o G29 aparece na lista
5. Clicar em Propriedades e testar eixos

### 2. Configurar o x360ce

1. Extrair o x360ce em uma pasta fácil (ex: `C:\x360ce\`)
2. Abrir `x360ce.exe` (versão x64)
3. Se o G29 não aparecer automaticamente, clicar em **Search**
4. Clicar no G29 na lista e depois em **Add**
5. Mapear os controles:

| Entrada do G29 | Campo no x360ce | Observação |
|---|---|---|
| Volante (eixo) | Left Thumbstick X | Eixo principal de direção |
| Acelerador | Right Trigger | Ou Right Thumbstick Y |
| Freio | Left Trigger | Ou Left Thumbstick Y |
| Embreagem | Left Thumbstick Y | Opcional |
| Botões do volante | Button A, B, X, Y, etc. | Mapear conforme preferência |

> **Importante:** Os eixos exatos dependem do modelo e configuração do seu x360ce. O InputTestHUD vai mostrar **qual eixo chegou de verdade** no Roblox — ajuste o x360ce conforme o resultado.

6. Clicar em **Save** para salvar a configuração

### 3. Copiar xinput1_3.dll (se necessário)

Em alguns casos, o Roblox precisa da DLL do x360ce na pasta dele:

1. Na pasta do x360ce, copiar `xinput1_3.dll` (x64)
2. Colar na pasta do Roblox Player:
   - Caminho típico: `C:\Users\[usuário]\AppData\Local\Roblox\Versions\[versão]\`
3. Reiniciar o Roblox Studio após isso

> Esta etapa pode ou não ser necessária. Teste primeiro sem ela. Se o HUD não detectar gamepad, tente com a DLL.

### 4. Testar com o InputTestHUD

1. Deixar o x360ce aberto em background
2. Abrir Roblox Studio
3. Conectar via Rojo (ver `docs/setup-rojo.md`)
4. Clicar em Play (F5)
5. O painel vermelho deve mostrar **"GAMEPAD CONECTADO"**
6. Mover o volante e pedais — os valores devem aparecer no HUD

---

## O que anotar durante o teste

Não assuma que o mapeamento está certo. Anote o que realmente aparece:

- Girar volante para **esquerda** → qual linha muda e para qual valor?
- Girar volante para **direita** → qual valor?
- Pisar **acelerador** → qual linha muda?
- Pisar **freio** → qual linha muda?
- Apertar botões → quais aparecem no HUD?

Esses dados serão usados para ajustar o `InputConfig.lua` com os eixos reais.

---

## Problemas comuns

| Problema | Causa provável | Solução |
|---|---|---|
| HUD mostra "NENHUM GAMEPAD DETECTADO" | x360ce não está ativo ou DLL não está na pasta correta | Verificar x360ce ativo + DLL |
| Volante não muda nenhum eixo | Eixo mapeado errado no x360ce | Testar outros eixos (Thumbstick2, etc.) |
| Valores invertidos | Eixo em inversão no x360ce | Marcar "Invert" no x360ce ou no InputConfig |
| Acelerador e freio no mesmo eixo | x360ce mapeou os dois para o mesmo eixo | Separar para triggers (L2/R2) |
| Jogo não responde no teclado | Normal — o HUD é só para gamepad | Teclado não aparece no HUD, isso é esperado |
