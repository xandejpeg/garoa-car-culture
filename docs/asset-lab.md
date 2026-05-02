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
- Exports a cleaned `.glb` for Roblox Studio import.
- Exports a `.vehicle-fitment.json` config for future in-game fitment tooling.

## Boundary

This tool prepares assets for Roblox. It does not create `.rbxm` files. Roblox Studio still performs the final `Import 3D` step that turns GLB/FBX data into Roblox MeshParts.

## Recommended BMW Test File

```text
IMPORTAR_NO_ROBLOX\BMW_M4CSL_BODY_READY_COLORED.glb
```
