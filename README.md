# Garoa Car Culture

Simulador automotivo brasileiro no Roblox. Cultura de carro, São Paulo, drift, No Hesi, tuning profundo, progressão econômica, mecânica avançada, suporte a volante.

## Stack

- Roblox Studio + Luau
- VS Code + Rojo (sincronização)
- Git / GitHub
- Blender (pipeline de modelos)
- Meshy (assets auxiliares)
- Logitech G29 via x360ce/XInput

## Estrutura

```
garoa-car-culture/
  src/
    client/          → StarterPlayerScripts (LocalScripts)
      input/         → InputTestHUD e sistema de input
      controllers/   → Controladores de veículo
      ui/            → Interface do jogador
      camera/        → Sistema de câmeras
    server/          → ServerScriptService (Scripts)
      services/      → Serviços principais
      economy/       → Sistema de economia
      traffic/       → Tráfego NPC
      persistence/   → Salvamento de dados
    shared/          → ReplicatedStorage/Shared (ModuleScripts)
      config/        → Configurações globais (InputConfig, etc.)
      vehicle/       → Módulos de veículo compartilhados
      types/         → Tipos e interfaces
      utils/         → Utilitários
  assets/
    vehicles/        → Modelos de carros
    props/           → Props e objetos de cena
    maps/            → Mapas e terreno
  comunicacao-ia/    → Comunicação entre ChatGPT e Opus
  MD/                → Documentos master e técnicos
  default.project.json  → Configuração Rojo
```

## Milestone Atual

**Milestone 001** — VS Code + Rojo + Roblox Studio + Input Test

Status: **EM ANDAMENTO**

### Como conectar (Rojo)

1. Instalar Rojo plugin no Roblox Studio
2. Instalar Rojo CLI: `aftman install` ou `cargo install rojo`
3. Na pasta do projeto, rodar: `rojo serve`
4. No Roblox Studio, clicar em "Connect" no plugin Rojo

### Como testar o Input HUD

1. Conectar via Rojo
2. Abrir Play no Roblox Studio
3. O painel vermelho aparece no canto superior esquerdo
4. Conectar G29 com x360ce configurado
5. Mover volante e pedais — valores aparecem em tempo real

## Roadmap

Ver `MD/garoa_car_culture_documento_master_v_4.md`
