# Cursor Rate Limit Temizleme Scripti
Write-Host "Cursor Rate Limit Temizleyici" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Cursor'un kapali olup olmadigini kontrol et
$cursorProcess = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
if ($cursorProcess) {
    Write-Host "`nUYARI: Cursor çalışıyor!" -ForegroundColor Yellow
    Write-Host "Bu scripti çalıştırmadan önce Cursor'u kapatmanız gerekiyor." -ForegroundColor Yellow
    $response = Read-Host "`nCursor'u şimdi kapatıp devam etmek ister misiniz? (E/H)"
    if ($response -eq 'E' -or $response -eq 'e') {
        Write-Host "Cursor kapatılıyor..." -ForegroundColor Yellow
        Stop-Process -Name "Cursor" -Force
        Start-Sleep -Seconds 3
    } else {
        Write-Host "Script iptal edildi." -ForegroundColor Red
        exit
    }
}

$backupDir = "$env:USERPROFILE\cursor_rate_limit_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# State database'i temizle
$stateDb = "$env:APPDATA\Cursor\User\globalStorage\state.vscdb"
if (Test-Path $stateDb) {
    Write-Host "`n[1/3] State database yedekleniyor..." -ForegroundColor Yellow
    Copy-Item -Path $stateDb -Destination "$backupDir\state.vscdb.backup" -Force
    Remove-Item -Path $stateDb -Force
    Write-Host "State database temizlendi!" -ForegroundColor Green
}

# Cache'leri temizle
$cacheDir = "$env:APPDATA\Cursor\Cache"
if (Test-Path $cacheDir) {
    Write-Host "`n[2/3] Cache dosyaları temizleniyor..." -ForegroundColor Yellow
    Remove-Item -Path $cacheDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Cache temizlendi!" -ForegroundColor Green
}

# Code Cache'leri temizle
$codeCacheDir = "$env:APPDATA\Cursor\Code Cache"
if (Test-Path $codeCacheDir) {
    Write-Host "`n[3/3] Code Cache temizleniyor..." -ForegroundColor Yellow
    Remove-Item -Path "$codeCacheDir" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Code Cache temizlendi!" -ForegroundColor Green
}

Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "Tamamlandı!" -ForegroundColor Green
Write-Host "`nYedek dosyalar: $backupDir" -ForegroundColor Cyan
Write-Host "`nCursor'u yeniden başlatabilirsiniz." -ForegroundColor Yellow
Write-Host "Rate limit hatası düzelmiş olmalı." -ForegroundColor Green
