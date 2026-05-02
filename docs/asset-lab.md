# Garoa Asset Lab

Local browser tool for inspecting and cleaning rough GLB/FBX vehicle assets before importing them into Roblox Studio.

## Run

```powershell
.\tools\asset-lab\start-asset-lab.ps1
```

It opens:

```text
http://localhost:5177/
```

## What It Does

- Loads `.glb`, `.gltf`, and `.fbx` files in a Three.js viewport.
- Shows mesh count, material count, triangle count, and bounding size.
- Lets you adjust scale, position, and rotation.
- Lets you hide wheel-like meshes by name.
- Lets you apply simple body/trim material overrides.
- Lets you switch between the nicer Asset Lab preview and a flatter Roblox Studio preview.
- Sends the loaded model to Meshy Retexture through a local server-side proxy.
- Lets you check Meshy task status and load the generated GLB back into the viewer.
- Provides an in-view AI-style chat for Portuguese commands that immediately affect the car preview.
- Exports a cleaned `.glb` for Roblox Studio import.
- Exports a `.vehicle-fitment.json` config for future in-game fitment tooling.

## In-View Chat

The large chat at the bottom of the 3D viewer accepts Portuguese commands and applies what it can immediately:

- `mapa de pecas`
- `pinta de vermelho`
- `pinta farol azul`
- `pinta vidro preto`
- `pinta roda preta`
- `pinta tudo de amarelo`
- `pinta de azul`
- `esconde as rodas`
- `mostra tudo`
- `gira 90 graus`
- `normaliza`
- `preview Roblox`
- `manda para o Meshy com pintura branca e carbono`
- `checa status`
- `ver GLB gerado`

Local commands change the model instantly in the viewer. Meshy commands create or check Retexture tasks through the local server.

## Part Understanding

The Asset Lab now classifies visible meshes into semantic roles before applying chat commands:

- `carroceria`
- `vidro`
- `farol`
- `lanterna`
- `roda`
- `pneu`
- `aro`
- `grade`
- `acabamento`
- `retrovisor`
- `interior`
- `emblema`
- `placa`

This depends on the model actually having separate meshes or useful mesh/material names. If Meshy or another exporter returns the whole car as one mesh, the Asset Lab cannot paint just the headlight or glass because those parts do not exist as separate selectable geometry. In that case, use the original multi-mesh FBX/GLB, ask Meshy for separated parts, or separate the model by material/part in Blender before doing precise edits.

## Meshy Terminal

The Meshy panel is a local-only workflow:

1. Run the Asset Lab.
2. Paste the Meshy API key when PowerShell asks for it, or set `MESHY_API_KEY` before starting.
3. Load a `.glb`, `.gltf`, or `.fbx` file in the viewer.
4. Edit the prompt in `Meshy Terminal`.
5. Click `Enviar modelo`.
6. Use `Checar status` until the task succeeds.
7. Click `Ver GLB gerado` to load Meshy's generated GLB back into the viewer.

The API key stays in the local Node server process. It is not stored in Git and is not sent to the browser JavaScript.

## Why It Can Look Worse In Roblox

The Asset Lab uses Three.js lighting and PBR materials, so a rough model can look better in the browser than it will inside Roblox. Roblox Studio is the final conversion boundary: it turns GLB/FBX content into MeshParts and may simplify or ignore some material data.

Common causes:

- The Meshy file has no real texture images, only material colors.
- Roblox imports the mesh but not the same PBR lighting response seen in Three.js.
- Studio lighting is too flat, too gray, or using default environment settings.
- The imported MeshParts get generic gray material/color values.
- Normals, smoothing, or mesh scale are not ideal after import.
- A body shell is being placed on top of A-Chassis parts without a finished vehicle template.

Use the `Roblox Studio` preview mode before exporting. If the model only looks good in `Asset Lab` mode, it needs better textures/material setup before it will look good in-game.

## Roblox Import Checklist

1. Prefer `.glb` over `.fbx` when the source has materials or textures.
2. In Asset Lab, normalize to 13 studs and fix rotation before export.
3. Use `Roblox Studio` preview mode to catch flat gray materials early.
4. Import the exported GLB through Studio's 3D importer.
5. After import, inspect MeshParts and set body color/material manually if Studio imports them gray.
6. For production quality, run Meshy Retexture first and import the textured result, not the raw gray mesh.

## Boundary

This tool prepares assets for Roblox. It does not create `.rbxm` files. Roblox Studio still performs the final `Import 3D` step that turns GLB/FBX data into Roblox MeshParts.

## Recommended BMW Test File

```text
IMPORTAR_NO_ROBLOX\BMW_M4CSL_BODY_READY_COLORED.glb
```
