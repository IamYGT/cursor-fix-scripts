[CmdletBinding()]
param(
    [switch]$ApplyAll
)

# Cursor Fix Scripts - explicit bundle runner

if (-not $ApplyAll) {
    Write-Warning "Bu betik üç yerel değişikliği art arda uygular ve varsayılan olarak çalışmaz."
    Write-Host "Önce README.md içindeki sınırları okuyun ve yalnız gerekli tek betiği çalıştırın." -ForegroundColor Yellow
    Write-Host "Tümünü bilinçli olarak çalıştırmak için: .\install.ps1 -ApplyAll" -ForegroundColor Yellow
    return
}

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    Cursor Fix Scripts - Explicit Bundle Runner" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Cursor kontrolü
$cursorProcess = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
if ($cursorProcess) {
    Write-Host "⚠️  Cursor çalışıyor! Kapatılıyor..." -ForegroundColor Yellow
    Stop-Process -Name "Cursor" -Force
    Start-Sleep -Seconds 3
}

Write-Host "Üç yerel değişiklik açık onayla uygulanıyor..." -ForegroundColor Yellow
Write-Host ""

# Script 1: top_k fix
Write-Host "[1/3] top_k hatası düzeltiliyor..." -ForegroundColor Yellow
& "$PSScriptRoot\fix_cursor_top_k.ps1"
Write-Host ""

# Script 2: HTTP 429 bypass
Write-Host "[2/3] Yerel HTTP 429 işleyici yaması uygulanıyor..." -ForegroundColor Yellow
& "$PSScriptRoot\bypass_gemini_safe.ps1"
Write-Host ""

# Script 3: Cache temizle
Write-Host "[3/3] Cache temizleniyor..." -ForegroundColor Yellow
& "$PSScriptRoot\fix_cursor_rate_limit.ps1"
Write-Host ""

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "             YEREL İŞLEMLER TAMAMLANDI" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Üç betik çalıştırıldı; sonuçları ve Cursor açılışını ayrıca doğrulayın." -ForegroundColor Yellow
Write-Host ""
Write-Host "📝 Yapılanlar:" -ForegroundColor Yellow
Write-Host "  ✅ Google Gemini top_k hatası düzeltildi" -ForegroundColor White
Write-Host "  ✅ Yerel HTTP 429 işleyici deseni değiştirildi" -ForegroundColor White
Write-Host "  ✅ State database ve cache temizlendi" -ForegroundColor White
Write-Host ""
Write-Host "Sağlayıcı kotası veya sunucu tarafı hız sınırı değiştirilmedi." -ForegroundColor Yellow
Write-Host "Cursor'u başlatın ve yerel sonucu doğrulayın." -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Sorun mu var? GitHub'da issue açın:" -ForegroundColor Gray
Write-Host "   https://github.com/IamYGT/cursor-fix-scripts/issues" -ForegroundColor Gray
Write-Host ""
