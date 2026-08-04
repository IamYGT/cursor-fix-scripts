# Cursor local HTTP 429 handler patch
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Cursor Local HTTP 429 Handler Patch" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Bu betik sağlayıcı kotasını veya sunucu tarafı hız sınırını değiştirmez." -ForegroundColor Yellow
Write-Host "Yalnızca yerel Cursor hata işleme desenlerini değiştirir." -ForegroundColor Yellow
Write-Host ""

# Cursor'u kapat
$cursorProcess = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
if ($cursorProcess) {
    Write-Host "Cursor kapatılıyor..." -ForegroundColor Yellow
    Stop-Process -Name "Cursor" -Force
    Start-Sleep -Seconds 3
}

$workbenchPath = "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js"

if (-not (Test-Path $workbenchPath)) {
    throw "Workbench file not found: $workbenchPath"
}

Write-Host "[1/3] Dosya inceleniyor..." -ForegroundColor Yellow

# Binary safe okuma
$bytes = [System.IO.File]::ReadAllBytes($workbenchPath)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)
$originalSize = $content.Length
Write-Host "  Orijinal: $([Math]::Round($originalSize/1MB, 2)) MB" -ForegroundColor Gray

$changes = 0

# Pattern 1: statusCode===429 -> statusCode===999
$pattern1 = '\.statusCode===429'
if ($content -match $pattern1) {
    $content = $content -replace $pattern1, '.statusCode===999'
    $changes++
    Write-Host "  ✓ Yerel statusCode===429 deseni değiştirildi" -ForegroundColor Green
}

# Pattern 2: case 429: -> case 999:
$pattern2 = 'case 429:'
if ($content -match $pattern2) {
    $content = $content -replace $pattern2, 'case 999:'
    $changes++
    Write-Host "  ✓ Yerel case 429 deseni değiştirildi" -ForegroundColor Green
}

# Pattern 3: .status===429 -> .status===999
$pattern3 = '\.status===429'
if ($content -match $pattern3) {
    $content = $content -replace $pattern3, '.status===999'
    $changes++
    Write-Host "  ✓ Yerel status===429 deseni değiştirildi" -ForegroundColor Green
}

if ($changes -eq 0) {
    Write-Warning "Desteklenen yerel HTTP 429 deseni bulunamadı; hiçbir dosya değiştirilmedi."
    return
}

Write-Host "`n[2/3] Yedek oluşturuluyor..." -ForegroundColor Yellow
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupPath = "$workbenchPath.backup_safe_$timestamp"
Copy-Item -LiteralPath $workbenchPath -Destination $backupPath -Force
Write-Host "  ✓ Yedek oluşturuldu" -ForegroundColor Green

Write-Host "`n[3/3] Dosya yazılıyor..." -ForegroundColor Yellow

# Binary safe yazma - NO BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$bytes = $utf8NoBom.GetBytes($content)
[System.IO.File]::WriteAllBytes($workbenchPath, $bytes)

$newSize = (Get-Item $workbenchPath).Length

Write-Host "  ✓ Yazıldı: $([Math]::Round($newSize/1MB, 2)) MB" -ForegroundColor Green

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "          ✓ YEREL İŞLEYİCİ YAMASI TAMAMLANDI" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "📊 ÖZET:" -ForegroundColor Cyan
Write-Host "  • Orijinal: $([Math]::Round($originalSize/1MB, 2)) MB" -ForegroundColor Gray
Write-Host "  • Yeni: $([Math]::Round($newSize/1MB, 2)) MB" -ForegroundColor Gray
Write-Host "  • Değişiklik: $changes" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Yerel HTTP 429 karşılaştırmaları 999 olarak değiştirildi" -ForegroundColor Yellow
Write-Host ""
Write-Host "🚀 Cursor'u başlatın!" -ForegroundColor Green
Write-Host "Sağlayıcı kotası ve sunucu tarafı sınırlar değişmeden kalır." -ForegroundColor Yellow
Write-Host ""
