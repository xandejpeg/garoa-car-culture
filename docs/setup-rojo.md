# Setup Rojo — Garoa Car Culture

**Objetivo:** conectar VS Code ao Roblox Studio para que edições em `.lua` no VS Code apareçam automaticamente no Roblox Studio.

---

## O que é o Rojo?

Rojo é uma ferramenta que sincroniza arquivos do seu sistema de arquivos com o Roblox Studio em tempo real.

Em vez de editar scripts dentro do Roblox Studio, você edita no VS Code e o Rojo publica automaticamente.

```
VS Code edita src/client/input/InputTestHUD.client.lua
↓
Rojo detecta a mudança
↓
Roblox Studio atualiza o script em StarterPlayerScripts automaticamente
```

---

## Instalação

### Opção 1 — Rojo CLI via instalador direto (mais simples)

1. Ir em: https://github.com/rojo-rbx/rojo/releases
2. Baixar o executável para Windows (`rojo.exe`)
3. Colocar em uma pasta no PATH (ex: `C:\tools\`) ou na pasta do projeto
4. Verificar: abrir terminal e rodar `rojo --version`

### Opção 2 — Via Aftman (gerenciador de ferramentas Roblox)

1. Baixar Aftman: https://github.com/LPGhatguy/aftman/releases
2. Rodar `aftman --version` para confirmar
3. Na pasta do projeto, criar `aftman.toml`:

```toml
[tools]
rojo = "rojo-rbx/rojo@7.4.4"
```

4. Rodar `aftman install` na pasta do projeto

### Plugin no Roblox Studio

1. Abrir Roblox Studio
2. Ir em **Plugins → Manage Plugins**
3. Buscar por **Rojo**
4. Instalar o plugin oficial (by rojo-rbx)

---

## Como usar no projeto

### 1. Abrir o projeto no VS Code

```
Abrir VS Code → File → Open Folder → selecionar garoa-car-culture/
```

### 2. Iniciar o servidor Rojo

Abrir terminal integrado do VS Code (Ctrl+`) e rodar:

```bash
rojo serve
```

Saída esperada:
```
Rojo server listening on port 34872
```

### 3. Conectar no Roblox Studio

1. Abrir Roblox Studio
2. Criar ou abrir um **place vazio** (File → New)
3. Ir em **Plugins** → clicar no botão **Rojo**
4. Clicar em **Connect**
5. O plugin deve mostrar: `Connected to localhost:34872`

### 4. Verificar sincronização

Após conectar, no **Explorer** do Roblox Studio:

- `StarterPlayer → StarterPlayerScripts` deve conter:
  - Pasta `input` com `InputTestHUD`
- `ReplicatedStorage → Shared → config` deve conter:
  - `InputConfig`

### 5. Testar edição ao vivo

1. No VS Code, editar qualquer script (ex: mudar uma linha no `InputTestHUD`)
2. Salvar o arquivo (Ctrl+S)
3. No Roblox Studio, o script deve atualizar automaticamente (sem precisar reconectar)

---

## Estrutura do default.project.json

O arquivo `default.project.json` na raiz do projeto define como os arquivos são mapeados:

```json
{
  "name": "GaroaCarCulture",
  "tree": {
    "$className": "DataModel",
    "StarterPlayer": {
      "StarterPlayerScripts": { "$path": "src/client" }
    },
    "ServerScriptService": { "$path": "src/server" },
    "ReplicatedStorage": {
      "Shared": { "$path": "src/shared" }
    }
  }
}
```

**Convenção de nomes de arquivo:**

| Extensão | Tipo no Roblox |
|---|---|
| `.client.lua` | LocalScript |
| `.server.lua` | Script |
| `.lua` (em shared/) | ModuleScript |

---

## Problemas comuns

| Problema | Solução |
|---|---|
| `rojo: command not found` | Adicionar rojo.exe ao PATH ou rodar `./rojo serve` |
| Plugin não conecta | Confirmar que `rojo serve` está rodando no terminal |
| Scripts não aparecem no Studio | Verificar se o place está vazio (não um place com conteúdo já existente) |
| Erro de permissão no plugin | Abrir Roblox Studio como administrador |
| Mudança não atualiza no Studio | Salvar o arquivo no VS Code (Ctrl+S) — Rojo precisa do save |
