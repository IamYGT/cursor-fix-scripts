# Cursor Fix Scripts - Hızlı Kurulum
# Tüm sorunları tek seferde çöz!

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    Cursor Fix Scripts - Hızlı Kurulum v1.1.0" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Cursor kontrolü
$cursorProcess = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
if ($cursorProcess) {
    Write-Host "⚠️  Cursor çalışıyor! Kapatılıyor..." -ForegroundColor Yellow
    Stop-Process -Name "Cursor" -Force
    Start-Sleep -Seconds 3
}

Write-Host "🚀 Tüm düzeltmeler uygulanıyor..." -ForegroundColor Green
Write-Host ""

# Script 1: top_k fix
Write-Host "[1/3] top_k hatası düzeltiliyor..." -ForegroundColor Yellow
& "$PSScriptRoot\fix_cursor_top_k.ps1"
Write-Host ""

# Script 2: HTTP 429 bypass
Write-Host "[2/3] HTTP 429 bypass uygulanıyor..." -ForegroundColor Yellow
& "$PSScriptRoot\bypass_gemini_safe.ps1"
Write-Host ""

# Script 3: Cache temizle
Write-Host "[3/3] Cache temizleniyor..." -ForegroundColor Yellow
& "$PSScriptRoot\fix_cursor_rate_limit.ps1"
Write-Host ""

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "            ✨ KURULUM TAMAMLANDI! ✨" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 Tüm düzeltmeler başarıyla uygulandı!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Yapılanlar:" -ForegroundColor Yellow
Write-Host "  ✅ Google Gemini top_k hatası düzeltildi" -ForegroundColor White
Write-Host "  ✅ HTTP 429 rate limit bypass edildi" -ForegroundColor White
Write-Host "  ✅ State database ve cache temizlendi" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Cursor'u başlatın ve test edin!" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Sorun mu var? GitHub'da issue açın:" -ForegroundColor Gray
Write-Host "   https://github.com/YOUR_USERNAME/cursor-fix-scripts/issues" -ForegroundColor Gray
Write-Host ""
