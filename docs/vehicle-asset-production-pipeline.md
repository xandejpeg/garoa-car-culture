# Vehicle Asset Production Pipeline

This is the correct production flow for putting a real car mesh on an A-Chassis vehicle.

## What can be automated

- Downloading/remeshing source assets from Meshy.
- Preparing a Roblox-friendly FBX through Blender.
- Removing visual wheel meshes from the body export.
- Copying the prepared FBX path for Studio import.
- Registering final `.rbxm`/`.rbxmx` assets for Rojo once Studio saves them.

## What must happen in Roblox Studio

Roblox Studio's `Import 3D` step is not exposed through Rojo. Import the prepared FBX in Studio, inspect the result, then save the imported model as `.rbxm`/`.rbxmx`.

## BMW M4 CSL Flow

1. Install Blender.
2. Run:

```powershell
.\tools\prepare-bmw-meshy-for-roblox.ps1
```

If Meshy delivered a gray model and API retexture is not available yet, generate a local material fallback:

```powershell
.\tools\prepare-bmw-meshy-for-roblox.ps1 -ApplyPrototypeMaterials
```

3. In Roblox Studio, use `Import` and select the generated GLB first. GLB usually preserves Meshy materials better than FBX:

```text
IMPORTAR_NO_ROBLOX\BMW_M4CSL_BODY_READY_FOR_ROBLOX.glb
```

Use the generated FBX only if Roblox Studio refuses the GLB.

If the source model is gray, it needs Meshy Retexture. Remesh does not generate paint or texture.

```powershell
.\tools\meshy-retexture.ps1 -InputTaskId "019de201-0490-716e-9323-2c8b386ff5b9" -Name "bmw-m4csl-textured" -EnablePbr -Wait
```

This consumes Meshy credits. The generated textured GLB/FBX is saved under:

```text
assets\meshy-output\bmw-m4csl-textured
```

If the car points sideways after import, rerun the preparation with an explicit rotation:

```powershell
.\tools\prepare-bmw-meshy-for-roblox.ps1 -RotationZDegrees 90
.\tools\prepare-bmw-meshy-for-roblox.ps1 -RotationZDegrees -90
.\tools\prepare-bmw-meshy-for-roblox.ps1 -RotationZDegrees 180
```

4. Mount and adjust the mesh on `Workspace.TestCar` in Studio.
5. Save the final assembled car as `.rbxm` or `.rbxmx`.
6. Register it:

```powershell
.\tools\register-vehicle-asset.ps1 -SourceModelPath "PATH_TO_FINAL_CAR.rbxm" -Name "BMW_M4CSL_Final"
```

7. Update the Rojo vehicle mapping to use the final asset as the production car template.

## Rule

Do not rely on runtime scripts to guess scale, rotation, or wheel placement for production vehicles. The final car template should already be aligned and welded before the game clones it.
