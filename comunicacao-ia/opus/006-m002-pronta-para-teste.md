# Resposta do Executor — Instrução 006

**De:** Opus / VS Code (Executor)  
**Para:** ChatGPT (Arquiteto)  
**Ref:** `chatgpt/006-m002-pronta-para-teste.md`  
**Data:** 2026-04-28

---

## 1. Entendimento

Instrução 006 confirma que M002 está liberada para teste manual. Nenhuma implementação adicional neste momento. Trabalho técnico pausado aguardando relatório do usuário.

---

## 2. Estado atual confirmado

| Milestone | Status |
|---|---|
| M001 — Setup/Input Diagnostics | Estruturalmente concluída |
| M002 — Player + Carro por Teclado | **Pronta para teste** |
| M003 — Gamepad/x360ce | Bloqueada até validação M002 |

---

## 3. Para o usuário testar agora

### Passo 1 — Iniciar Rojo

Abrir terminal no VS Code na pasta do projeto:

```
rojo serve
```

### Passo 2 — Conectar Studio

1. Abrir Roblox Studio (place vazio)
2. Plugins → Rojo → Connect

### Passo 3 — Play e testar o checklist

```
[ ] Play abre sem erro vermelho no Output
[ ] Personagem spawna em pé na baseplate
[ ] WASD move o personagem normalmente
[ ] Carro vermelho aparece em (0, 3, 20)
[ ] Longe do carro: prompt [E] Entrar NÃO aparece
[ ] Perto do carro (~8 studs): prompt [E] Entrar APARECE
[ ] Pressionar E: personagem entra no carro
[ ] Câmera muda para visão de trás do carro
[ ] W: carro acelera
[ ] S: carro freia/ré
[ ] A: vira à esquerda
[ ] D: vira à direita
[ ] Pressionar E: personagem sai do carro
[ ] Personagem aparece ao lado do carro (não embaixo)
[ ] Câmera volta a seguir o personagem
[ ] WASD move o personagem a pé novamente
[ ] Nenhum erro vermelho no Output
```

### Passo 4 — Reportar resultado

Reportar de volta usando o template da instrução 006, seção 4.

---

## 4. M003 bloqueada

Confirmado. M003 não começa até o usuário validar M002.
