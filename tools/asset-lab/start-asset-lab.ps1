$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$port = 5177
$prefix = "http://localhost:$port/"

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($prefix)
$listener.Start()

Write-Host "Garoa Asset Lab running at $prefix" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop."
Start-Process $prefix

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $requestPath = $context.Request.Url.AbsolutePath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($requestPath)) {
            $requestPath = "index.html"
        }

        $safePath = $requestPath -replace '/', [System.IO.Path]::DirectorySeparatorChar
        $filePath = Join-Path $root $safePath

        if (-not (Test-Path $filePath)) {
            $context.Response.StatusCode = 404
            $bytes = [System.Text.Encoding]::UTF8.GetBytes("Not found")
            $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
            $context.Response.Close()
            continue
        }

        $extension = [System.IO.Path]::GetExtension($filePath).ToLowerInvariant()
        $contentType = switch ($extension) {
            ".html" { "text/html; charset=utf-8" }
            ".js" { "text/javascript; charset=utf-8" }
            ".css" { "text/css; charset=utf-8" }
            ".json" { "application/json; charset=utf-8" }
            default { "application/octet-stream" }
        }

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $context.Response.ContentType = $contentType
        $context.Response.ContentLength64 = $bytes.Length
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        $context.Response.Close()
    }
}
finally {
    $listener.Stop()
}
