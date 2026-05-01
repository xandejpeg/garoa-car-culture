param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$Name,

    [int]$TargetTriangles = 9000,

    [string]$BlenderPath = "blender"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$safeName = ($Name -replace '[^a-zA-Z0-9_-]', '-')

if ([string]::IsNullOrWhiteSpace($safeName)) {
    throw "Name must contain at least one letter or number."
}

$vehicleSourceDir = Join-Path $repoRoot ("assets\vehicle-source\" + $safeName)
$vehiclesDir = Join-Path $repoRoot "assets\vehicles"
New-Item -ItemType Directory -Force -Path $vehicleSourceDir | Out-Null
New-Item -ItemType Directory -Force -Path $vehiclesDir | Out-Null

function Resolve-SourceFile {
    param([string]$InputPath)

    if ($InputPath -match '^https?://') {
        $fileName = [System.IO.Path]::GetFileName(([System.Uri]$InputPath).AbsolutePath)
        if ([string]::IsNullOrWhiteSpace($fileName)) {
            throw "URL must point directly to a file, for example .zip, .fbx, .glb, .obj, .blend, .rbxm, or .rbxmx. Sketchfab page URLs need manual download/login first."
        }

        $downloadPath = Join-Path $vehicleSourceDir $fileName
        Write-Host "Downloading source file..."
        Invoke-WebRequest -Uri $InputPath -OutFile $downloadPath
        return $downloadPath
    }

    if (-not (Test-Path $InputPath)) {
        throw "Source file not found: $InputPath"
    }

    return (Resolve-Path $InputPath).Path
}

$sourceFile = Resolve-SourceFile $SourcePath
$extension = [System.IO.Path]::GetExtension($sourceFile).ToLowerInvariant()

if (@(".rbxm", ".rbxmx") -contains $extension) {
    & (Join-Path $PSScriptRoot "register-vehicle-asset.ps1") -SourceModelPath $sourceFile -Name $safeName
    exit $LASTEXITCODE
}

if ($extension -eq ".zip") {
    $extractDir = Join-Path $vehicleSourceDir "extracted"
    if (Test-Path $extractDir) {
        Remove-Item -Recurse -Force $extractDir
    }
    New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
    Expand-Archive -Path $sourceFile -DestinationPath $extractDir -Force

    $candidate = Get-ChildItem -Path $extractDir -Recurse -File |
        Where-Object { @(".blend", ".fbx", ".glb", ".gltf", ".obj") -contains $_.Extension.ToLowerInvariant() } |
        Select-Object -First 1

    if (-not $candidate) {
        throw "No supported 3D source found inside zip. Expected .blend, .fbx, .glb, .gltf, or .obj."
    }

    $sourceFile = $candidate.FullName
    $extension = $candidate.Extension.ToLowerInvariant()
}

if (@(".blend", ".fbx", ".glb", ".gltf", ".obj") -notcontains $extension) {
    throw "Unsupported source format: $extension. Use .blend, .fbx, .glb, .gltf, .obj, .zip, .rbxm, or .rbxmx."
}

$sourceCopy = Join-Path $vehicleSourceDir ([System.IO.Path]::GetFileName($sourceFile))
if ($sourceFile -ne $sourceCopy) {
    Copy-Item -Path $sourceFile -Destination $sourceCopy -Force
}

$exportPath = Join-Path $vehicleSourceDir ($safeName + ".roblox.fbx")
$blenderScript = Join-Path $vehicleSourceDir "prepare-for-roblox.py"

$python = @'
import bpy
import os
import sys

source_path = sys.argv[sys.argv.index("--source") + 1]
export_path = sys.argv[sys.argv.index("--export") + 1]
target_triangles = int(sys.argv[sys.argv.index("--target-triangles") + 1])

extension = os.path.splitext(source_path)[1].lower()

if extension == ".blend":
    bpy.ops.wm.open_mainfile(filepath=source_path)
else:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete()
    if extension == ".fbx":
        bpy.ops.import_scene.fbx(filepath=source_path)
    elif extension in (".glb", ".gltf"):
        bpy.ops.import_scene.gltf(filepath=source_path)
    elif extension == ".obj":
        bpy.ops.wm.obj_import(filepath=source_path)
    else:
        raise RuntimeError(f"Unsupported extension: {extension}")

mesh_objects = [obj for obj in bpy.context.scene.objects if obj.type == "MESH"]
if not mesh_objects:
    raise RuntimeError("No mesh objects found in source model")

for obj in mesh_objects:
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)

total_triangles = 0
for obj in mesh_objects:
    mesh = obj.data
    for polygon in mesh.polygons:
        total_triangles += max(1, len(polygon.vertices) - 2)

ratio = 1.0
if total_triangles > target_triangles:
    ratio = max(0.02, target_triangles / float(total_triangles))

if ratio < 1.0:
    for obj in mesh_objects:
        bpy.context.view_layer.objects.active = obj
        obj.select_set(True)
        modifier = obj.modifiers.new(name="Garoa_Roblox_Decimate", type="DECIMATE")
        modifier.ratio = ratio
        bpy.ops.object.modifier_apply(modifier=modifier.name)
        obj.select_set(False)

for obj in bpy.context.scene.objects:
    obj.select_set(obj.type == "MESH")

bpy.ops.export_scene.fbx(
    filepath=export_path,
    use_selection=True,
    global_scale=0.01,
    apply_unit_scale=True,
    bake_space_transform=False,
    path_mode="COPY",
    embed_textures=True,
)

print(f"Prepared FBX for Roblox: {export_path}")
print(f"Original triangles estimate: {total_triangles}")
print(f"Decimate ratio used: {ratio:.4f}")
'@

Set-Content -Path $blenderScript -Value $python -Encoding UTF8

Write-Host "Preparing vehicle source with Blender..."
& $BlenderPath --background --python $blenderScript -- --source $sourceCopy --export $exportPath --target-triangles $TargetTriangles

if ($LASTEXITCODE -ne 0) {
    throw "Blender conversion failed. Check Blender installation or pass -BlenderPath with the full blender.exe path."
}

Write-Host ""
Write-Host "Terminal automation complete:" -ForegroundColor Green
Write-Host "  Source folder: assets/vehicle-source/$safeName"
Write-Host "  Roblox-ready FBX: assets/vehicle-source/$safeName/$safeName.roblox.fbx"
Write-Host ""
Write-Host "Roblox boundary: FBX/GLB cannot become MeshParts through Rojo alone."
Write-Host "Next step in Studio: Home > Import 3D > import the FBX, then right-click model > Save to File as .rbxm/.rbxmx."
Write-Host "After that run:"
Write-Host "  .\tools\register-vehicle-asset.ps1 -SourceModelPath `"PATH_TO_EXPORTED_MODEL.rbxm`" -Name `"$safeName`""