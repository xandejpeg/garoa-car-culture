param(
    [Parameter(Mandatory = $true)]
    [string]$SourceModelPath,

    [Parameter(Mandatory = $true)]
    [string]$Name
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$vehiclesDir = Join-Path $repoRoot "assets\vehicles"

if (-not (Test-Path $SourceModelPath)) {
    throw "Source model not found: $SourceModelPath"
}

$extension = [System.IO.Path]::GetExtension($SourceModelPath).ToLowerInvariant()
$supportedExtensions = @(".rbxm", ".rbxmx")

if ($supportedExtensions -notcontains $extension) {
    Write-Host "This project can only register Roblox model files for Rojo: .rbxm or .rbxmx" -ForegroundColor Yellow
    Write-Host "For $extension files, import the model in Roblox Studio first, then right-click the model and Save to File as .rbxm or .rbxmx." -ForegroundColor Yellow
    exit 2
}

$safeName = ($Name -replace '[^a-zA-Z0-9_-]', '-')
if ([string]::IsNullOrWhiteSpace($safeName)) {
    throw "Name must contain at least one letter or number."
}

New-Item -ItemType Directory -Force -Path $vehiclesDir | Out-Null

$targetPath = Join-Path $vehiclesDir ($safeName + $extension)
Copy-Item -Path $SourceModelPath -Destination $targetPath -Force

Write-Host "Vehicle asset registered:" -ForegroundColor Green
Write-Host "  File: assets/vehicles/$safeName$extension"
Write-Host "  Rojo path: ReplicatedStorage.VehicleAssets.$safeName"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Run: rojo serve"
Write-Host "  2. Connect Roblox Studio with the Rojo plugin"
Write-Host "  3. Check ReplicatedStorage > VehicleAssets > $safeName"
Write-Host "  4. To make it drivable, mount this body onto the A-Chassis TestCar template."