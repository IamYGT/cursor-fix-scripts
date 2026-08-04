Describe 'Cursor fix scripts' {
    BeforeAll {
        $repoRoot = Split-Path -Parent $PSScriptRoot
    }

    BeforeEach {
        $script:originalLocalAppData = $env:LOCALAPPDATA
        $script:originalAppData = $env:APPDATA
        $script:originalUserProfile = $env:USERPROFILE

        $fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $env:LOCALAPPDATA = Join-Path $fixtureRoot 'local'
        $env:APPDATA = Join-Path $fixtureRoot 'roaming'
        $env:USERPROFILE = Join-Path $fixtureRoot 'profile'

        New-Item -ItemType Directory -Path $env:LOCALAPPDATA, $env:APPDATA, $env:USERPROFILE -Force | Out-Null
        Mock Get-Process { $null } -ParameterFilter { $Name -eq 'Cursor' }
    }

    AfterEach {
        $env:LOCALAPPDATA = $script:originalLocalAppData
        $env:APPDATA = $script:originalAppData
        $env:USERPROFILE = $script:originalUserProfile
    }

    It 'parses every PowerShell entry point' {
        $parseErrors = foreach ($scriptFile in Get-ChildItem -LiteralPath $repoRoot -Filter '*.ps1' -File) {
            $tokens = $null
            $errors = $null
            [System.Management.Automation.Language.Parser]::ParseFile(
                $scriptFile.FullName,
                [ref]$tokens,
                [ref]$errors
            ) | Out-Null
            $errors
        }

        $parseErrors | Should -BeNullOrEmpty
    }

    It 'backs up and removes top_k only inside the fixture' {
        $workbenchPath = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js'
        New-Item -ItemType Directory -Path (Split-Path $workbenchPath) -Force | Out-Null
        $original = 'a={temperature:1,top_k:-1,top_p:0.9};b={top_k:2,temperature:1};c={top_k:3}'
        Set-Content -LiteralPath $workbenchPath -Value $original -NoNewline
        $sentinel = Join-Path $TestDrive 'outside.txt'
        Set-Content -LiteralPath $sentinel -Value 'untouched' -NoNewline

        & (Join-Path $repoRoot 'fix_cursor_top_k.ps1') *>&1 | Out-Null

        (Get-Content -LiteralPath $workbenchPath -Raw) | Should -Not -Match 'top_k'
        (Get-Content -LiteralPath "$workbenchPath.backup" -Raw) | Should -Be $original
        (Get-Content -LiteralPath $sentinel -Raw) | Should -Be 'untouched'
    }

    It 'does not back up or rewrite a workbench without a supported top_k pattern' {
        $workbenchPath = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js'
        New-Item -ItemType Directory -Path (Split-Path $workbenchPath) -Force | Out-Null
        $original = 'const generationConfig={temperature:1,top_p:0.9}'
        Set-Content -LiteralPath $workbenchPath -Value $original -NoNewline

        & (Join-Path $repoRoot 'fix_cursor_top_k.ps1') *>&1 | Out-Null

        (Get-Content -LiteralPath $workbenchPath -Raw) | Should -Be $original
        Test-Path -LiteralPath "$workbenchPath.backup" | Should -BeFalse
    }

    It 'fails without mutation when the top_k workbench path is missing' {
        { & (Join-Path $repoRoot 'fix_cursor_top_k.ps1') } | Should -Throw '*Workbench file not found*'
        @(Get-ChildItem -LiteralPath $env:LOCALAPPDATA -Recurse -File).Count | Should -Be 0
    }

    It 'backs up the local workbench before changing 429 handlers' {
        $workbenchPath = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js'
        New-Item -ItemType Directory -Path (Split-Path $workbenchPath) -Force | Out-Null
        $original = 'a.statusCode===429;case 429:;b.status===429'
        Set-Content -LiteralPath $workbenchPath -Value $original -NoNewline

        $output = & (Join-Path $repoRoot 'bypass_gemini_safe.ps1') *>&1 | Out-String

        (Get-Content -LiteralPath $workbenchPath -Raw) | Should -Be 'a.statusCode===999;case 999:;b.status===999'
        $backups = @(Get-ChildItem -LiteralPath (Split-Path $workbenchPath) -Filter 'workbench.desktop.main.js.backup_safe_*')
        $backups.Count | Should -Be 1
        (Get-Content -LiteralPath $backups[0].FullName -Raw) | Should -Be $original
        $output | Should -Not -Match 'Gemini rate limit artık tetiklenmeyecek|rate limit bypass edildi'
    }

    It 'does not back up or rewrite a workbench without a supported 429 pattern' {
        $workbenchPath = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js'
        New-Item -ItemType Directory -Path (Split-Path $workbenchPath) -Force | Out-Null
        $original = 'const status=500'
        Set-Content -LiteralPath $workbenchPath -Value $original -NoNewline

        & (Join-Path $repoRoot 'bypass_gemini_safe.ps1') *>&1 | Out-Null

        (Get-Content -LiteralPath $workbenchPath -Raw) | Should -Be $original
        @(Get-ChildItem -LiteralPath (Split-Path $workbenchPath) -Filter '*.backup_safe_*').Count | Should -Be 0
    }

    It 'fails without mutation when the 429 workbench path is missing' {
        { & (Join-Path $repoRoot 'bypass_gemini_safe.ps1') } | Should -Throw '*Workbench file not found*'
        @(Get-ChildItem -LiteralPath $env:LOCALAPPDATA -Recurse -File).Count | Should -Be 0
    }

    It 'backs up state and removes only fixture cache paths' {
        $stateDb = Join-Path $env:APPDATA 'Cursor\User\globalStorage\state.vscdb'
        $cacheDir = Join-Path $env:APPDATA 'Cursor\Cache'
        $codeCacheDir = Join-Path $env:APPDATA 'Cursor\Code Cache'
        New-Item -ItemType Directory -Path (Split-Path $stateDb), $cacheDir, $codeCacheDir -Force | Out-Null
        Set-Content -LiteralPath $stateDb -Value 'state' -NoNewline
        Set-Content -LiteralPath (Join-Path $cacheDir 'cache.bin') -Value 'cache' -NoNewline
        Set-Content -LiteralPath (Join-Path $codeCacheDir 'code.bin') -Value 'code' -NoNewline
        $sentinel = Join-Path $TestDrive 'outside.txt'
        Set-Content -LiteralPath $sentinel -Value 'untouched' -NoNewline

        $output = & (Join-Path $repoRoot 'fix_cursor_rate_limit.ps1') *>&1 | Out-String

        Test-Path -LiteralPath $stateDb | Should -BeFalse
        Test-Path -LiteralPath $cacheDir | Should -BeFalse
        Test-Path -LiteralPath $codeCacheDir | Should -BeFalse
        $backup = @(Get-ChildItem -LiteralPath $env:USERPROFILE -Directory -Filter 'cursor_rate_limit_backup_*')
        $backup.Count | Should -Be 1
        (Get-Content -LiteralPath (Join-Path $backup[0].FullName 'state.vscdb.backup') -Raw) | Should -Be 'state'
        (Get-Content -LiteralPath $sentinel -Raw) | Should -Be 'untouched'
        $output | Should -Not -Match 'Rate limit hatası düzelmiş olmalı'
    }

    It 'creates no backup when no local state or cache target exists' {
        & (Join-Path $repoRoot 'fix_cursor_rate_limit.ps1') *>&1 | Out-Null

        @(Get-ChildItem -LiteralPath $env:USERPROFILE -Directory -Filter 'cursor_rate_limit_backup_*').Count | Should -Be 0
        @(Get-ChildItem -LiteralPath $env:APPDATA -Recurse -File).Count | Should -Be 0
    }

    It 'does not run every mutation from install.ps1 without explicit opt-in' {
        $workbenchPath = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js'
        New-Item -ItemType Directory -Path (Split-Path $workbenchPath) -Force | Out-Null
        $original = 'a={top_k:3};b.status===429'
        Set-Content -LiteralPath $workbenchPath -Value $original -NoNewline

        & (Join-Path $repoRoot 'install.ps1') *>&1 | Out-Null

        (Get-Content -LiteralPath $workbenchPath -Raw) | Should -Be $original
        Test-Path -LiteralPath "$workbenchPath.backup" | Should -BeFalse
    }
}
