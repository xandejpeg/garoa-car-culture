param(
    [string]$SourcePath = "assets\meshy-output\bmw-m4csl\bmw-m4csl.glb",
    [string]$BlenderPath = "blender",
    [double]$TargetLengthStuds = 13.0,
    [double]$RotationZDegrees = 0,
    [ValidateSet("glb", "fbx", "both")]
    [string]$OutputFormat = "both",
    [switch]$ApplyPrototypeMaterials,
    [switch]$KeepWheels
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = if ([System.IO.Path]::IsPathRooted($SourcePath)) { $SourcePath } else { Join-Path $repoRoot $SourcePath }

if (-not (Test-Path $source)) {
    throw "Source model not found: $source"
}

$blenderCommand = Get-Command $BlenderPath -ErrorAction SilentlyContinue
if (-not $blenderCommand) {
    throw "Blender not found. Install Blender or pass -BlenderPath 'C:\Path\To\blender.exe'."
}

$outputDir = Join-Path $repoRoot "IMPORTAR_NO_ROBLOX"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$outputGlbPath = Join-Path $outputDir "BMW_M4CSL_BODY_READY_FOR_ROBLOX.glb"
$outputFbxPath = Join-Path $outputDir "BMW_M4CSL_BODY_READY_FOR_ROBLOX.fbx"
$scriptPath = Join-Path $outputDir "prepare-bmw-m4csl-for-roblox.py"

$keepWheelsLiteral = if ($KeepWheels) { "True" } else { "False" }
$applyPrototypeMaterialsLiteral = if ($ApplyPrototypeMaterials) { "True" } else { "False" }
$exportGlbLiteral = if ($OutputFormat -eq "glb" -or $OutputFormat -eq "both") { "True" } else { "False" }
$exportFbxLiteral = if ($OutputFormat -eq "fbx" -or $OutputFormat -eq "both") { "True" } else { "False" }

$python = @"
import bpy
import math
import os
import sys

source_path = r'''$source'''
output_glb_path = r'''$outputGlbPath'''
output_fbx_path = r'''$outputFbxPath'''
target_length_studs = float($TargetLengthStuds)
rotation_z_degrees = float($RotationZDegrees)
keep_wheels = $keepWheelsLiteral
apply_prototype_materials = $applyPrototypeMaterialsLiteral
export_glb = $exportGlbLiteral
export_fbx = $exportFbxLiteral

def reset_scene():
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete()

def import_source(path):
    ext = os.path.splitext(path)[1].lower()
    if ext == '.fbx':
        bpy.ops.import_scene.fbx(filepath=path)
    elif ext in ('.glb', '.gltf'):
        bpy.ops.import_scene.gltf(filepath=path)
    elif ext == '.obj':
        bpy.ops.wm.obj_import(filepath=path)
    else:
        raise RuntimeError(f'Unsupported source extension: {ext}')

def is_wheel_object(obj):
    name = obj.name.lower()
    tokens = ('wheel', 'tire', 'tyre', 'rim')
    if any(token in name for token in tokens):
        return True

    parent = obj.parent
    while parent:
        parent_name = parent.name.lower()
        if any(token in parent_name for token in tokens):
            return True
        parent = parent.parent

    return False

def apply_bmw_prototype_materials():
    for mat in bpy.data.materials:
        mat.use_nodes = True
        lower = mat.name.lower()
        if 'stroke' in lower or 'dot' in lower or 'glass' in lower or 'window' in lower:
            base = (0.015, 0.018, 0.02, 1.0)
            metallic = 0.0
            roughness = 0.35
        else:
            base = (0.92, 0.9, 0.86, 1.0)
            metallic = 0.0
            roughness = 0.28

        mat.diffuse_color = base
        if mat.node_tree:
            bsdf = mat.node_tree.nodes.get('Principled BSDF')
            if bsdf:
                bsdf.inputs['Base Color'].default_value = base
                bsdf.inputs['Metallic'].default_value = metallic
                bsdf.inputs['Roughness'].default_value = roughness

reset_scene()
import_source(source_path)

mesh_objects = [obj for obj in bpy.context.scene.objects if obj.type == 'MESH']
if not mesh_objects:
    raise RuntimeError('No mesh objects found in source model')

if not keep_wheels:
    for obj in list(mesh_objects):
        if is_wheel_object(obj):
            bpy.data.objects.remove(obj, do_unlink=True)
    mesh_objects = [obj for obj in bpy.context.scene.objects if obj.type == 'MESH']

if apply_prototype_materials:
    apply_bmw_prototype_materials()

for obj in mesh_objects:
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.select_set(False)

root = bpy.data.objects.new('BMW_M4CSL_RobloxRoot', None)
bpy.context.collection.objects.link(root)

for obj in mesh_objects:
    obj.parent = root

bpy.context.view_layer.objects.active = root
root.rotation_euler[2] = math.radians(rotation_z_degrees)
bpy.ops.object.select_all(action='DESELECT')
for obj in mesh_objects:
    obj.select_set(True)
bpy.context.view_layer.objects.active = mesh_objects[0]
bpy.ops.object.transform_apply(location=False, rotation=True, scale=False)

min_x = min((obj.bound_box[i][0] * obj.scale.x + obj.location.x) for obj in mesh_objects for i in range(8))
max_x = max((obj.bound_box[i][0] * obj.scale.x + obj.location.x) for obj in mesh_objects for i in range(8))
min_y = min((obj.bound_box[i][1] * obj.scale.y + obj.location.y) for obj in mesh_objects for i in range(8))
max_y = max((obj.bound_box[i][1] * obj.scale.y + obj.location.y) for obj in mesh_objects for i in range(8))
min_z = min((obj.bound_box[i][2] * obj.scale.z + obj.location.z) for obj in mesh_objects for i in range(8))
max_z = max((obj.bound_box[i][2] * obj.scale.z + obj.location.z) for obj in mesh_objects for i in range(8))

length = max(max_x - min_x, max_y - min_y)
if length > 0:
    scale = target_length_studs / length
    for obj in mesh_objects:
        obj.scale *= scale

for obj in mesh_objects:
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)
    obj.select_set(False)

bpy.ops.object.select_all(action='DESELECT')
for obj in mesh_objects:
    obj.select_set(True)

if export_glb:
    bpy.ops.export_scene.gltf(
        filepath=output_glb_path,
        export_format='GLB',
        use_selection=True,
        export_apply=True,
        export_yup=True,
    )
    print('Prepared BMW GLB for Roblox:', output_glb_path)

if export_fbx:
    bpy.ops.export_scene.fbx(
        filepath=output_fbx_path,
        use_selection=True,
        apply_unit_scale=True,
        bake_space_transform=False,
        path_mode='COPY',
        embed_textures=True,
    )
    print('Prepared BMW FBX for Roblox:', output_fbx_path)

print('Removed wheel meshes:', not keep_wheels)
print('Rotation Z degrees:', rotation_z_degrees)
print('Applied BMW prototype materials:', apply_prototype_materials)
"@

Set-Content -Path $scriptPath -Value $python -Encoding UTF8

& $blenderCommand.Source --background --python $scriptPath
if ($LASTEXITCODE -ne 0) {
    throw "Blender failed while preparing BMW model."
}

$preferredOutput = if ($OutputFormat -eq "fbx") { $outputFbxPath } else { $outputGlbPath }
Set-Clipboard -Value $preferredOutput
Write-Host "Prepared Roblox import files:" -ForegroundColor Green
if (Test-Path $outputGlbPath) { Write-Host "  GLB: $outputGlbPath" }
if (Test-Path $outputFbxPath) { Write-Host "  FBX: $outputFbxPath" }
Write-Host "Preferred path copied to clipboard: $preferredOutput"
Write-Host "Import the GLB first in Roblox Studio; use FBX only if GLB import fails."
