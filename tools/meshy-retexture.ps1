param(
    [string]$InputTaskId = "",

    [string]$Source = "",

    [Parameter(Mandatory = $true)]
    [string]$Name,

    [string]$TextStylePrompt = "realistic BMW M4 CSL coupe, alpine white paint, black carbon fiber roof and hood accents, dark tinted glass, black kidney grille, blue laser headlights, red taillights, subtle BMW M motorsport stripes, clean game asset texture, no baked lighting, no dirt",

    [ValidateSet("latest", "meshy-6", "meshy-5")]
    [string]$AiModel = "latest",

    [string[]]$TargetFormats = @("glb", "fbx"),

    [switch]$EnablePbr,

    [switch]$HdTexture,

    [switch]$Wait,

    [int]$PollSeconds = 20
)

$ErrorActionPreference = "Stop"

if (-not $env:MESHY_API_KEY) {
    throw "MESHY_API_KEY is not set. Configure it with: setx MESHY_API_KEY <your-key>"
}

if ([string]::IsNullOrWhiteSpace($InputTaskId) -and [string]::IsNullOrWhiteSpace($Source)) {
    throw "Provide either -InputTaskId from a completed Meshy task or -Source pointing to a model file/URL."
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

    $path = if ([System.IO.Path]::IsPathRooted($InputSource)) { $InputSource } else { Join-Path $repoRoot $InputSource }
    if (-not (Test-Path $path)) {
        throw "Source model not found: $path"
    }

    $resolved = (Resolve-Path $path).Path
    $extension = [System.IO.Path]::GetExtension($resolved).ToLowerInvariant()
    if (@(".glb", ".gltf", ".obj", ".fbx", ".stl") -notcontains $extension) {
        throw "Meshy retexture supports .glb, .gltf, .obj, .fbx, .stl or a direct public URL."
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
    text_style_prompt = $TextStylePrompt
    ai_model = $AiModel
    enable_original_uv = $true
    enable_pbr = [bool]$EnablePbr
    hd_texture = [bool]$HdTexture
    remove_lighting = $true
    target_formats = $TargetFormats
}

if (-not [string]::IsNullOrWhiteSpace($InputTaskId)) {
    $body.input_task_id = $InputTaskId
} else {
    $body.model_url = Get-ModelUrlInput $Source
}

Write-Host "Submitting Meshy retexture task for $safeName..."
Write-Host "Prompt: $TextStylePrompt"
$createResponse = Invoke-MeshyApi -Method "Post" -Path "/openapi/v1/retexture" -Body $body
$taskId = $createResponse.result

if (-not $taskId) {
    throw "Meshy did not return a retexture task id."
}

Set-Content -Path (Join-Path $outputDir "retexture-task-id.txt") -Value $taskId -Encoding UTF8
Set-Content -Path (Join-Path $outputDir "retexture-prompt.txt") -Value $TextStylePrompt -Encoding UTF8
Write-Host "Meshy retexture task created: $taskId"

if (-not $Wait) {
    Write-Host "Run later to check/download:"
    Write-Host "  .\tools\meshy-retexture-status.ps1 -TaskId $taskId -Name $safeName -Download"
    exit 0
}

while ($true) {
    $task = Invoke-MeshyApi -Method "Get" -Path "/openapi/v1/retexture/$taskId"
    Write-Host ("Status: {0} {1}%" -f $task.status, $task.progress)

    if ($task.status -eq "SUCCEEDED") {
        break
    }

    if ($task.status -eq "FAILED") {
        $message = "Meshy retexture task failed."
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

if ($task.thumbnail_url) {
    Invoke-WebRequest -Uri $task.thumbnail_url -OutFile (Join-Path $outputDir "preview.png")
}

if ($task.texture_urls) {
    $index = 0
    foreach ($textureSet in $task.texture_urls) {
        foreach ($property in @("base_color", "metallic", "normal", "roughness", "emission")) {
            $url = $textureSet.$property
            if ($url) {
                Invoke-WebRequest -Uri $url -OutFile (Join-Path $outputDir ("texture_{0}_{1}.png" -f $index, $property))
            }
        }
        $index += 1
    }
}

Write-Host "Meshy retexture complete:" -ForegroundColor Green
Write-Host "  Output: assets/meshy-output/$safeName"
