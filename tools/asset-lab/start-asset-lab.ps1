param(
    [int]$Port = 5177
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$server = Join-Path $root "server.mjs"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is required to run the Meshy-enabled Asset Lab."
}

if (-not $env:MESHY_API_KEY) {
    Write-Host "MESHY_API_KEY is not set. Paste it now to use Meshy features." -ForegroundColor Yellow
    Write-Host "Leave empty to open the Asset Lab without Meshy API calls."
    $secureKey = Read-Host "Meshy API key" -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
    try {
        $plainKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }

    if (-not [string]::IsNullOrWhiteSpace($plainKey)) {
        $env:MESHY_API_KEY = $plainKey
    }
}

$env:ASSET_LAB_PORT = [string]$Port
$url = "http://localhost:$Port/"

Write-Host "Garoa Asset Lab starting at $url" -ForegroundColor Green
Write-Host "API key loaded for this terminal only: $([bool]$env:MESHY_API_KEY)"
Start-Process $url

node --no-warnings $server
