# Script to remove top_k parameter from Cursor's Google API calls
$workbenchPath = "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js"

Write-Host "Creating backup..." -ForegroundColor Yellow
Copy-Item -Path $workbenchPath -Destination "$workbenchPath.backup" -Force

Write-Host "Reading file..." -ForegroundColor Yellow
$content = Get-Content -Path $workbenchPath -Raw -Encoding UTF8

Write-Host "Original file size: $($content.Length) bytes" -ForegroundColor Cyan

# Pattern 1: Remove top_k from generationConfig objects
# This handles: {temperature:x,top_k:y,top_p:z} -> {temperature:x,top_p:z}
$pattern1 = ',\s*top_k\s*:\s*[^,}]+'
$content = $content -replace $pattern1, ''

# Pattern 2: Remove top_k if it's the first property
# This handles: {top_k:x,temperature:y} -> {temperature:y}
$pattern2 = '{\s*top_k\s*:\s*[^,}]+\s*,'
$content = $content -replace $pattern2, '{'

# Pattern 3: Remove top_k if it's the only property
# This handles: {top_k:x} -> {}
$pattern3 = '{\s*top_k\s*:\s*[^}]+\s*}'
$content = $content -replace $pattern3, '{}'

Write-Host "Modified file size: $($content.Length) bytes" -ForegroundColor Cyan
Write-Host "Writing modified file..." -ForegroundColor Yellow
Set-Content -Path $workbenchPath -Value $content -Encoding UTF8 -NoNewline

Write-Host "Done! Restart Cursor to apply changes." -ForegroundColor Green
Write-Host "Backup saved at: $workbenchPath.backup" -ForegroundColor Green
