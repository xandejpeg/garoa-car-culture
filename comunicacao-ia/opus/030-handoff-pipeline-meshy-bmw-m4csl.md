# Opus / Copilot -> Proximo Agente
## 030 — Handoff: pipeline Meshy + BMW M4CSL

**Projeto:** Garoa Car Culture  
**Data:** 2026-05-01  
**Status:** pipeline de assets criado; BMW M4CSL processada no Meshy; falta importacao no Roblox Studio e encaixe no A-Chassis

---

## 1. Contexto rapido

O usuario quer automatizar ao maximo o fluxo de carros 3D para o jogo Roblox usando:

- Sketchfab / assets gratuitos;
- Meshy premium/API para remesh e conversao;
- Rojo para sincronizar assets versionados;
- A-Chassis como base fisica dirigivel.

O objetivo imediato era levar um asset de BMW para o jogo.

---

## 2. O que foi implementado no repo

### Rojo

`default.project.json` agora tem:

```json
"VehicleAssets": {
  "$path": "assets/vehicles"
}
```

Isso faz qualquer `.rbxm` / `.rbxmx` em `assets/vehicles` aparecer em:

```text
ReplicatedStorage.VehicleAssets
```

O A-Chassis atual continua em:

```text
ReplicatedStorage.Vehicles.TestCar
```

### Scripts criados

```text
tools/register-vehicle-asset.ps1
```

Registra `.rbxm` / `.rbxmx` exportado do Roblox Studio em `assets/vehicles`.

Uso:

```powershell
.\tools\register-vehicle-asset.ps1 -SourceModelPath "C:\caminho\modelo.rbxm" -Name "bmw-m4csl"
```

```text
tools/import-vehicle-source.ps1
```

Pipeline local com Blender headless para `.zip`, `.blend`, `.fbx`, `.glb`, `.gltf`, `.obj`, `.rbxm`, `.rbxmx`. Observacao: nesta maquina o `blender.exe` nao foi encontrado no PATH.

```text
tools/meshy-remesh.ps1
tools/meshy-remesh-status.ps1
```

Automacao real da Meshy API usando `MESHY_API_KEY` no ambiente. Submete `.fbx/.glb/.gltf/.obj/.stl` local ou URL direta para `/openapi/v1/remesh`, consulta status e baixa outputs.

---

## 3. BMW M4CSL processada

O usuario baixou o arquivo do Sketchfab:

```text
C:\Users\xandao\Downloads\bmw-m4csl.zip
```

Ele foi extraido para:

```text
assets/vehicle-source/bmw-m4csl/
```

Arquivos fonte relevantes:

```text
assets/vehicle-source/bmw-m4csl/source/bmwm8Car.zip
assets/vehicle-source/bmw-m4csl/source/bmwm8Car/bmwm8CarSave001.fbx
assets/vehicle-source/bmw-m4csl/textures/internal_ground_ao_texture.jpeg
```

A tarefa Meshy Remesh criada foi:

```text
019de201-0490-716e-9323-2c8b386ff5b9
```

Status final:

```text
SUCCEEDED 100%
```

Outputs baixados para:

```text
assets/meshy-output/bmw-m4csl/
```

Esperado nessa pasta:

```text
task-id.txt
bmw-m4csl.glb
bmw-m4csl.fbx
```

---

## 4. O que ainda falta para entrar no jogo

Rojo nao transforma `.fbx` / `.glb` em MeshPart sozinho. Ainda precisa passar pelo Roblox Studio ou por Open Cloud/Bridge.

Proximo passo manual mais seguro:

1. Abrir Roblox Studio com o projeto conectado no Rojo.
2. Importar `assets/meshy-output/bmw-m4csl/bmw-m4csl.fbx` ou `.glb` via Import 3D.
3. Conferir escala e textura.
4. Salvar o modelo importado como `.rbxm` ou `.rbxmx`.
5. Rodar:

```powershell
.\tools\register-vehicle-asset.ps1 -SourceModelPath "CAMINHO_DO_RBXM_EXPORTADO" -Name "bmw-m4csl"
```

6. Conectar Rojo e verificar:

```text
ReplicatedStorage.VehicleAssets.bmw-m4csl
```

7. Para virar carro dirigivel, usar esse asset como body/casca visual em cima do `ReplicatedStorage.Vehicles.TestCar` A-Chassis. Nao substituir o A-Chassis inteiro pelo mesh.

---

## 5. Licenca do asset

Pelo download do Sketchfab mostrado pelo usuario:

```text
BMW M4csl by Mpgs.studio3DModels
License: CC Attribution
Commercial use allowed
Author must be credited
```

Creditar o autor em documentacao/creditos do jogo antes de publicar.

---

## 6. Alertas importantes

- A chave `MESHY_API_KEY` foi configurada no ambiente desta maquina, mas uma key chegou a ser colada no chat. O ideal e revogar essa key no Meshy e criar outra depois.
- Nao imprimir a chave em terminal ou docs.
- A importacao no Roblox ainda depende do Studio/Bridge/Open Cloud.
- Mesh visual nao anda sozinho: A-Chassis e quem fornece fisica, rodas, DriveSeat, Tune e scripts.

---

## 7. Comandos uteis

Checar status e baixar outputs Meshy:

```powershell
.\tools\meshy-remesh-status.ps1 -TaskId 019de201-0490-716e-9323-2c8b386ff5b9 -Name "bmw-m4csl" -Download
```

Submeter novo asset ao Meshy:

```powershell
.\tools\meshy-remesh.ps1 -Source "C:\caminho\asset.fbx" -Name "nome-do-carro" -TargetPolycount 9000
```

Registrar `.rbxm/.rbxmx` no Rojo:

```powershell
.\tools\register-vehicle-asset.ps1 -SourceModelPath "C:\caminho\modelo.rbxm" -Name "nome-do-carro"
```

---

## 8. Estado para o proximo agente

Continuar daqui:

1. Validar que `assets/meshy-output/bmw-m4csl/bmw-m4csl.fbx` existe.
2. Importar no Roblox Studio.
3. Exportar `.rbxm/.rbxmx`.
4. Registrar em `assets/vehicles`.
5. Montar visual da BMW no A-Chassis sem quebrar `DriveSeat`, `Wheels`, `A-Chassis Tune`, `Drive`, `Initialize`.