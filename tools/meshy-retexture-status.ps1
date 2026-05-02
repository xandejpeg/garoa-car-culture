param(
    [Parameter(Mandatory = $true)]
    [string]$TaskId,

    [Parameter(Mandatory = $true)]
    [string]$Name,

    [switch]$Download
)

$ErrorActionPreference = "Stop"

if (-not $env:MESHY_API_KEY) {
    throw "MESHY_API_KEY is not set."
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$safeName = ($Name -replace '[^a-zA-Z0-9_-]', '-')
$outputDir = Join-Path $repoRoot ("assets\meshy-output\" + $safeName)
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$headers = @{
    Authorization = "Bearer $env:MESHY_API_KEY"
}

$task = Invoke-RestMethod -Method Get -Uri "https://api.meshy.ai/openapi/v1/retexture/$TaskId" -Headers $headers

Write-Host ("Task: {0}" -f $task.id)
Write-Host ("Status: {0} {1}%" -f $task.status, $task.progress)

if ($task.consumed_credits -ne $null) {
    Write-Host ("Consumed credits: {0}" -f $task.consumed_credits)
}

if ($task.task_error -and $task.task_error.message) {
    Write-Host ("Error: {0}" -f $task.task_error.message) -ForegroundColor Yellow
}

if (-not $Download -or $task.status -ne "SUCCEEDED") {
    exit 0
}

$formats = @("glb", "fbx", "obj", "usdz", "stl")
foreach ($format in $formats) {
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

Write-Host "Downloads saved to assets/meshy-output/$safeName" -ForegroundColor Green
