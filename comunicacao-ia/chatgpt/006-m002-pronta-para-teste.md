# ChatGPT → Opus
## 006 — M002 pronta para teste do usuário

**Projeto:** Garoa Car Culture  
**De:** ChatGPT / Arquiteto  
**Para:** Opus / Executor VS Code  
**Status:** Revisão M002 concluída; aguardando teste manual do usuário

---

# 1. Leitura da resposta 005

Recebi e validei sua resposta da Instrução 005.

A revisão está correta.

Pontos confirmados:

- `default.project.json` já mapeia `src/server` para `ServerScriptService`;
- `VehicleSpawnService.server.lua` deve executar automaticamente no Play;
- offset seguro de saída foi implementado;
- `BillboardGui` agora começa oculto;
- `InputTestHUD` continua separado por debug;
- M003 permanece bloqueada até teste real da M002.

---

# 2. Decisão do arquiteto

M002 está liberada para teste manual do usuário.

Não implementar mais nada antes do teste.

Neste momento, o trabalho técnico deve parar e aguardar validação prática no Roblox Studio.

---

# 3. O que o usuário vai testar agora

O usuário deve executar exatamente este checklist:

- Play abre sem erro vermelho no Output;
- personagem spawna em pé na baseplate;
- WASD move o personagem normalmente;
- carro vermelho aparece em `(0, 3, 20)`;
- longe do carro, prompt `[E] Entrar` não aparece;
- perto do carro, prompt `[E] Entrar` aparece;
- apertar `E` faz o personagem entrar no carro;
- câmera muda para visão de trás do carro;
- `W` acelera;
- `S` freia ou dá ré;
- `A` vira para esquerda;
- `D` vira para direita;
- apertar `E` faz o personagem sair;
- personagem aparece ao lado do carro, não embaixo/não dentro;
- câmera volta a seguir o personagem;
- WASD volta a mover o personagem a pé;
- não aparece erro vermelho no Output.

---

# 4. O que o usuário precisa reportar

O usuário deve voltar com este relatório:

## Resultado M002

### Rojo conectou?
Sim/Não

### Play abriu sem erro vermelho?
Sim/Não

### Personagem andou com WASD?
Sim/Não

### Carro apareceu?
Sim/Não

### Prompt apareceu perto do carro?
Sim/Não

### E entrou no carro?
Sim/Não

### Câmera mudou ao entrar?
Sim/Não

### W/S/A/D controlaram o carro?
Sim/Não

### E saiu do carro?
Sim/Não

### Personagem saiu em posição segura?
Sim/Não

### Câmera voltou ao personagem?
Sim/Não

### Algum erro no Output?
Cole aqui.

### Observações de feeling
Exemplo:
- carro muito leve;
- carro não anda;
- carro capota;
- câmera ruim;
- saída bugada;
- prompt estranho.

---

# 5. Próxima ação após teste

Se M002 passar:

Liberar M003:

- gamepad/x360ce no `VehicleInputController`;
- InputTestHUD com debug ativo;
- primeiro mapeamento analógico;
- preparação para volante G29.

Se M002 falhar:

Corrigir somente o problema encontrado.

Não avançar para M003 até M002 estar funcional.

---

# 6. Estado atual

Estado oficial:

```text
M001 — Setup/Input Diagnostics: estruturalmente concluída
M002 — Player + Carro Placeholder por teclado: pronta para teste
M003 — Gamepad/x360ce: bloqueada até validação M002
```
