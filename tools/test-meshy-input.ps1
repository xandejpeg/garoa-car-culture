param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$resolvedPath = if ([System.IO.Path]::IsPathRooted($Path)) { $Path } else { Join-Path $repoRoot $Path }

if (-not (Test-Path $resolvedPath)) {
    throw "File not found: $resolvedPath"
}

$item = Get-Item $resolvedPath
$extension = $item.Extension.ToLowerInvariant()
$accepted = @(".glb", ".gltf", ".obj", ".fbx", ".stl")
$robloxOnly = @(".rbxm", ".rbxmx", ".rbxl", ".rbxlx")

Write-Host "File: $($item.FullName)"
Write-Host "Extension: $extension"
Write-Host ("Size: {0} MB" -f ([math]::Round($item.Length / 1MB, 2)))

if ($robloxOnly -contains $extension) {
    Write-Host "Result: NOT ACCEPTED BY MESHY" -ForegroundColor Red
    Write-Host "Reason: this is a Roblox Studio file. Meshy needs a raw 3D model, not .rbxm/.rbxlx."
    exit 2
}

if ($accepted -notcontains $extension) {
    Write-Host "Result: NOT ACCEPTED BY MESHY" -ForegroundColor Red
    Write-Host "Reason: Meshy Retexture accepts .glb, .gltf, .obj, .fbx, or .stl."
    exit 2
}

if ($extension -eq ".glb") {
    $bytes = [System.IO.File]::ReadAllBytes($item.FullName)
    $magic = [System.Text.Encoding]::ASCII.GetString($bytes, 0, [Math]::Min(4, $bytes.Length))
    if ($magic -ne "glTF") {
        Write-Host "Result: SUSPICIOUS GLB" -ForegroundColor Yellow
        Write-Host "Reason: .glb files should start with the glTF header. Re-export it from Blender or Asset Lab."
        exit 1
    }
}

if ($item.Length -gt 25MB) {
    Write-Host "Warning: large local files can be slow as base64 data URI. A public URL may work better." -ForegroundColor Yellow
}

Write-Host "Result: OK FOR MESHY RETEXTURE" -ForegroundColor Green
Write-Host "Example:"
Write-Host ("  .\tools\meshy-retexture.ps1 -Source `"{0}`" -Name `"my-textured-car`" -EnablePbr -Wait" -f $Path)

if (-not $env:MESHY_API_KEY) {
    Write-Host "Note: MESHY_API_KEY is not set in this terminal." -ForegroundColor Yellow
}