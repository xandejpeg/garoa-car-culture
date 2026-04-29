# Protocolo de Comunicação IA — Garoa Car Culture

## Estrutura

```
comunicacao-ia/
  000-protocolo-comunicacao.md   ← este arquivo
  chatgpt/                       ← instruções e prompts vindos do ChatGPT
  opus/                          ← respostas do Opus (executor VS Code)
  historico/                     ← registro cronológico das sessões
```

## Fluxo

```
ChatGPT escreve instrução
↓
Usuário salva em comunicacao-ia/chatgpt/XXX-nome.md
↓
Opus lê o arquivo
↓
Opus executa e responde em comunicacao-ia/opus/XXX-nome.md
↓
Usuário cola resposta de volta no ChatGPT
↓
ChatGPT planeja próximo passo
↓
Ciclo recomeça
```

## Numeração dos arquivos

- Prefixo numérico sequencial de 3 dígitos: `001`, `002`, `003`...
- Nome descritivo em kebab-case
- Exemplo: `003-instrucao-setup-rojo.md`

## Regras

- Opus NUNCA implementa sem instrução em arquivo
- Toda instrução recebe uma resposta no formato obrigatório
- Problemas são reportados no campo "Problemas ou dúvidas"
- Nada é implementado "em grande" sem aprovação
