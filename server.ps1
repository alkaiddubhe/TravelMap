$port = 8000
$root = $PSScriptRoot

Write-Host "Root directory: $root" -ForegroundColor Green
Write-Host "Listening on port: $port" -ForegroundColor Green
Write-Host ""
Write-Host "Server started. Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$port/"
Write-Host "Adding prefix: $prefix" -ForegroundColor Cyan

try {
    $listener.Prefixes.Add($prefix)
    $listener.Start()
    Write-Host "Listener started successfully" -ForegroundColor Green
}
catch {
    Write-Host "ERROR starting listener: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Full error: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $localPath = $request.Url.LocalPath
        if ($localPath -eq '/') { $localPath = '/index.html' }

        $filePath = Join-Path $root $localPath.TrimStart('/')

        Write-Host "$(Get-Date -Format 'HH:mm:ss') - $($request.HttpMethod) $localPath"

        if (Test-Path $filePath -PathType Leaf) {
            $content = [System.IO.File]::ReadAllBytes($filePath)

            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = switch ($ext) {
                '.html' { 'text/html; charset=utf-8' }
                '.js'   { 'application/javascript; charset=utf-8' }
                '.json' { 'application/json; charset=utf-8' }
                '.css'  { 'text/css; charset=utf-8' }
                '.png'  { 'image/png' }
                '.jpg'  { 'image/jpeg' }
                '.svg'  { 'image/svg+xml' }
                default { 'application/octet-stream' }
            }

            $response.ContentType = $contentType
            $response.ContentLength64 = $content.Length
            $response.StatusCode = 200
            $response.OutputStream.Write($content, 0, $content.Length)
        }
        else {
            $response.StatusCode = 404
            $message = [System.Text.Encoding]::UTF8.GetBytes("404 - File Not Found: $localPath")
            $response.OutputStream.Write($message, 0, $message.Length)
        }

        $response.Close()
    }
    catch {
        Write-Host "Request error: $_" -ForegroundColor Red
    }
}

$listener.Stop()
$listener.Close()
