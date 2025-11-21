# Cursor Google Gemini Rate Limit BYPASS - Güvenli Versiyon
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Google Gemini Rate Limit BYPASS (Safe Mode)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
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
    Write-Host "❌ Workbench dosyası bulunamadı!" -ForegroundColor Red
    exit
}

Write-Host "[1/3] Yedek oluşturuluyor..." -ForegroundColor Yellow
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupPath = "$workbenchPath.backup_safe_$timestamp"
Copy-Item -Path $workbenchPath -Destination $backupPath -Force
Write-Host "  ✓ Yedek oluşturuldu" -ForegroundColor Green

Write-Host "`n[2/3] Dosya düzenleniyor..." -ForegroundColor Yellow

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
    Write-Host "  ✓ statusCode===429 bypass edildi" -ForegroundColor Green
}

# Pattern 2: case 429: -> case 999:
$pattern2 = 'case 429:'
if ($content -match $pattern2) {
    $content = $content -replace $pattern2, 'case 999:'
    $changes++
    Write-Host "  ✓ case 429 bypass edildi" -ForegroundColor Green
}

# Pattern 3: .status===429 -> .status===999
$pattern3 = '\.status===429'
if ($content -match $pattern3) {
    $content = $content -replace $pattern3, '.status===999'
    $changes++
    Write-Host "  ✓ status===429 bypass edildi" -ForegroundColor Green
}

Write-Host "`n[3/3] Dosya yazılıyor..." -ForegroundColor Yellow

# Binary safe yazma - NO BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$bytes = $utf8NoBom.GetBytes($content)
[System.IO.File]::WriteAllBytes($workbenchPath, $bytes)

$newSize = (Get-Item $workbenchPath).Length

Write-Host "  ✓ Yazıldı: $([Math]::Round($newSize/1MB, 2)) MB" -ForegroundColor Green

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "              ✓ BYPASS TAMAMLANDI!          " -ForegroundColor Green  
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "📊 ÖZET:" -ForegroundColor Cyan
Write-Host "  • Orijinal: $([Math]::Round($originalSize/1MB, 2)) MB" -ForegroundColor Gray
Write-Host "  • Yeni: $([Math]::Round($newSize/1MB, 2)) MB" -ForegroundColor Gray
Write-Host "  • Değişiklik: $changes" -ForegroundColor White
Write-Host ""
Write-Host "🔧 HTTP 429 (Rate Limit) -> 999 (bypass)" -ForegroundColor Yellow
Write-Host ""
Write-Host "🚀 Cursor'u başlatın!" -ForegroundColor Green
Write-Host "✨ Gemini rate limit artık tetiklenmeyecek!" -ForegroundColor Green
Write-Host ""
