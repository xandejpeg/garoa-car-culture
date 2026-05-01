param(
    [string]$Project = "default.project.json",
    [int]$Port = 34873
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$localRojo = Join-Path $repoRoot ".tools\rojo\rojo.exe"
$rojoCommand = Get-Command rojo -ErrorAction SilentlyContinue

if (Test-Path $localRojo) {
    $rojo = $localRojo
} elseif ($rojoCommand) {
    $rojo = $rojoCommand.Source
} else {
    throw "Rojo was not found. Install it locally in .tools\rojo\rojo.exe or add rojo to PATH."
}

$projectPath = Join-Path $repoRoot $Project
if (-not (Test-Path $projectPath)) {
    throw "Rojo project file not found: $projectPath"
}

Write-Host "Starting Rojo server..." -ForegroundColor Green
Write-Host "  Project: $Project"
Write-Host "  Port: $Port"
Write-Host "  Studio: Plugins > Rojo > Connect > localhost:$Port"

& $rojo serve $projectPath --port $Port