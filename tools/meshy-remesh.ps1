param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Name,

    [int]$TargetPolycount = 9000,

    [ValidateSet("triangle", "quad")]
    [string]$Topology = "triangle",

    [string[]]$TargetFormats = @("glb", "fbx"),

    [switch]$AutoSize,

    [double]$ResizeHeight = 0,

    [ValidateSet("bottom", "center")]
    [string]$OriginAt = "bottom",

    [switch]$Wait,

    [int]$PollSeconds = 15
)

$ErrorActionPreference = "Stop"

if (-not $env:MESHY_API_KEY) {
    throw "MESHY_API_KEY is not set. Configure it with: setx MESHY_API_KEY <your-key>"
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$safeName = ($Name -replace '[^a-zA-Z0-9_-]', '-')
if ([string]::IsNullOrWhiteSpace($safeName)) {
    throw "Name must contain at least one letter or number."
}

$outputDir = Join-Path $repoRoot ("assets\meshy-output\" + $safeName)
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

function Get-ModelUrlInput {
    param([string]$InputSource)

    if ($InputSource -match '^https?://') {
        return $InputSource
    }

    if (-not (Test-Path $InputSource)) {
        throw "Source not found: $InputSource"
    }

    $resolved = (Resolve-Path $InputSource).Path
    $extension = [System.IO.Path]::GetExtension($resolved).ToLowerInvariant()
    if (@(".glb", ".gltf", ".obj", ".fbx", ".stl") -notcontains $extension) {
        throw "Meshy remesh supports .glb, .gltf, .obj, .fbx, .stl or a direct public URL. Convert .blend/.zip first with tools/import-vehicle-source.ps1 or Blender."
    }

    $bytes = [System.IO.File]::ReadAllBytes($resolved)
    $base64 = [Convert]::ToBase64String($bytes)
    return "data:application/octet-stream;base64,$base64"
}

function Invoke-MeshyApi {
    param(
        [string]$Method,
        [string]$Path,
        [object]$Body = $null
    )

    $headers = @{
        Authorization = "Bearer $env:MESHY_API_KEY"
    }

    $uri = "https://api.meshy.ai$Path"

    if ($Body) {
        $json = $Body | ConvertTo-Json -Depth 8
        return Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -ContentType "application/json" -Body $json
    }

    return Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers
}

$body = @{
    model_url = Get-ModelUrlInput $Source
    target_formats = $TargetFormats
    topology = $Topology
    target_polycount = $TargetPolycount
    origin_at = $OriginAt
}

if ($AutoSize) {
    $body.auto_size = $true
} elseif ($ResizeHeight -gt 0) {
    $body.resize_height = $ResizeHeight
}

Write-Host "Submitting Meshy remesh task for $safeName..."
$createResponse = Invoke-MeshyApi -Method "Post" -Path "/openapi/v1/remesh" -Body $body
$taskId = $createResponse.result

if (-not $taskId) {
    throw "Meshy did not return a task id."
}

Set-Content -Path (Join-Path $outputDir "task-id.txt") -Value $taskId -Encoding UTF8
Write-Host "Meshy task created: $taskId"

if (-not $Wait) {
    Write-Host "Run later to check/download:"
    Write-Host "  .\tools\meshy-remesh-status.ps1 -TaskId $taskId -Name $safeName -Download"
    exit 0
}

while ($true) {
    $task = Invoke-MeshyApi -Method "Get" -Path "/openapi/v1/remesh/$taskId"
    Write-Host ("Status: {0} {1}%" -f $task.status, $task.progress)

    if ($task.status -eq "SUCCEEDED") {
        break
    }

    if ($task.status -eq "FAILED") {
        $message = "Meshy task failed."
        if ($task.task_error -and $task.task_error.message) {
            $message = $message + " " + $task.task_error.message
        }
        throw $message
    }

    Start-Sleep -Seconds $PollSeconds
}

foreach ($format in $TargetFormats) {
    $url = $task.model_urls.$format
    if (-not $url) {
        continue
    }

    $targetPath = Join-Path $outputDir ($safeName + "." + $format)
    Write-Host "Downloading $format..."
    Invoke-WebRequest -Uri $url -OutFile $targetPath
}

Write-Host "Meshy remesh complete:" -ForegroundColor Green
Write-Host "  Output: assets/meshy-output/$safeName"
Write-Host "  Next: import the FBX/GLB into Roblox Studio, save as .rbxm/.rbxmx, then register with tools/register-vehicle-asset.ps1"