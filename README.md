# 🚀 Cursor IDE Fix Scripts

[![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> **A collection of PowerShell scripts to fix annoying issues in Cursor IDE**

This repository contains tested and safe PowerShell scripts that automatically fix common problems encountered while using Cursor IDE.

---

## 📑 Table of Contents

- [Features](#-features)
- [Problems and Solutions](#-problems-and-solutions)
- [Installation](#-installation)
- [Usage](#-usage)
- [Script Details](#-script-details)
- [Security](#-security)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

- ✅ **Automatic Backup**: Creates automatic backups before each script runs
- ✅ **Safe Operation**: Checks if Cursor is closed
- ✅ **Detailed Logging**: Colorful and descriptive output at every step
- ✅ **Easy to Use**: Run with a single command
- ✅ **Reversible**: Easy restoration with backup files

---

## 🐛 Problems and Solutions

### 1️⃣ Google Gemini API `top_k` Error

**Problem:**
```
Error: top_k (-1) must not be set or must be a positive integer
```

**Cause:** Cursor sends invalid `top_k` parameter to Google Gemini API.

**Solution:** [`fix_cursor_top_k.ps1`](#1-fix_cursor_top_kps1)

---

### 2️⃣ User API Key Rate Limit Error

**Problem:**
```
User API Key Rate limit exceeded
```

**Cause:** Rate limit information accumulated in Cursor's state database.

**Solution:** [`fix_cursor_rate_limit.ps1`](#2-fix_cursor_rate_limitps1)

---

### 3️⃣ Gemini API Artificial Rate Limit

**Problem:** Cursor intentionally imposes rate limits on Gemini API, restricting usage.

**Cause:** Rate limit controls in Cursor's workbench file.

**Solution:** [`remove_gemini_rate_limit.ps1`](#3-remove_gemini_rate_limitps1)

---

### 4️⃣ Gemini HTTP 429 Rate Limit Error

**Problem:** Constantly receiving "429 Too Many Requests" error when using Gemini API.

**Cause:** Cursor catches HTTP 429 status code and throws rate limit error.

**Solution:** [`bypass_gemini_safe.ps1`](#4-bypass_gemini_safeps1)

---

## 📥 Installation

### Method 1: Clone with Git

```powershell
git clone https://github.com/IamYGT/cursor-fix-scripts.git
cd cursor-fix-scripts
```

### Method 2: Manual Download

1. Download the scripts from this repository
2. Save them to a folder of your choice
3. Open PowerShell **as Administrator**
4. Navigate to the script folder:

```powershell
cd C:\path\to\scripts
```

---

## 🎯 Usage

### ⚡ Quick Installation (RECOMMENDED)

**Fix all issues with one command:**

```powershell
# Open PowerShell as Administrator
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Apply all fixes in one line
.\install.ps1
```

This script:
- ✅ Fixes top_k error
- ✅ Bypasses HTTP 429
- ✅ Clears cache
- ✅ Automatically closes Cursor
- ✅ Shows each step

### 📋 Manual Installation

1. **Close Cursor IDE** (important!)
2. Open PowerShell **as Administrator**
3. Navigate to script folder
4. Run the desired script

```powershell
# Set execution policy (security)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Run the script you need
.\fix_cursor_top_k.ps1              # top_k error
.\bypass_gemini_safe.ps1            # Rate limit bypass (RECOMMENDED)
.\fix_cursor_rate_limit.ps1         # Clear cache
```

5. Restart Cursor

---

## 📜 Script Details

### 1. `fix_cursor_top_k.ps1`

**What it does:**
- Edits Cursor's `workbench.desktop.main.js` file
- Removes invalid `top_k` parameter from Google Gemini API calls
- Creates automatic backup

**Edited File:**
```
%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js
```

**Run:**
```powershell
.\fix_cursor_top_k.ps1
```

**Example Output:**
```
Creating backup...
Reading file...
Original file size: 27716300 bytes
Modified file size: 27716300 bytes
Writing modified file...
Done! Restart Cursor to apply changes.
Backup saved at: workbench.desktop.main.js.backup
```

**Patterns:**
- `{temperature:x,top_k:y,top_p:z}` → `{temperature:x,top_p:z}`
- `{top_k:x,temperature:y}` → `{temperature:y}`
- `{top_k:x}` → `{}`

---

### 2. `fix_cursor_rate_limit.ps1`

**What it does:**
- Clears Cursor's state database
- Deletes cache files
- Resets rate limit information

**Cleaned Files:**
```
%APPDATA%\Cursor\User\globalStorage\state.vscdb
%APPDATA%\Cursor\Cache\
%APPDATA%\Cursor\Code Cache\
```

**Run:**
```powershell
.\fix_cursor_rate_limit.ps1
```

**Example Output:**
```
Cursor Rate Limit Cleaner
================================

[1/3] Backing up state database...
State database cleared!

[2/3] Clearing cache files...
Cache cleared!

[3/3] Clearing Code Cache...
Code Cache cleared!

================================
Complete!

Backup files: C:\Users\YourName\cursor_rate_limit_backup_20251121_231325

You can restart Cursor now.
Rate limit error should be fixed.
```

**Features:**
- ✅ Checks if Cursor is running
- ✅ Offers automatic shutdown
- ✅ Creates timestamped backup folder

---

### 3. `bypass_gemini_safe.ps1`

**What it does:**
- Bypasses HTTP 429 checks in Cursor's workbench file
- Changes rate limit status code to one that will never trigger
- Uses binary-safe encoding (file doesn't corrupt)

**Edited File:**
```
%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js
```

**Run:**
```powershell
.\bypass_gemini_safe.ps1
```

**Example Output:**
```
═══════════════════════════════════════════════════
  Google Gemini Rate Limit BYPASS (Safe Mode)
═══════════════════════════════════════════════════

Closing Cursor...
[1/3] Creating backup...
  ✓ Backup created

[2/3] Editing file...
  Original: 26.43 MB
  ✓ statusCode===429 bypassed
  ✓ case 429 bypassed

[3/3] Writing file...
  ✓ Written: 26.43 MB

═══════════════════════════════════════════════════
              ✓ BYPASS COMPLETE!          
═══════════════════════════════════════════════════

📊 SUMMARY:
  • Original: 26.43 MB
  • New: 26.43 MB
  • Changes: 2

🔧 HTTP 429 (Rate Limit) -> 999 (bypass)

🚀 Start Cursor!
✨ Gemini rate limit won't trigger anymore!
```

**Patterns:**
```powershell
# Bypass HTTP 429 status code
.statusCode===429 → .statusCode===999
.status===429 → .status===999

# Bypass switch cases
case 429: → case 999:
```

**Features:**
- ✅ Binary-safe read/write (no encoding issues)
- ✅ Minimal changes (only 2-3 places)
- ✅ File size doesn't change
- ✅ Safest method

---

### 4. `install.ps1`

**What it does:**
- Runs all fix scripts in one go
- Automatically closes Cursor
- Shows progress for each step
- Most user-friendly option

**Run:**
```powershell
.\install.ps1
```

**Features:**
- ✅ Fixes all issues at once
- ✅ Automatic Cursor shutdown
- ✅ Progress indicators
- ✅ Error handling

---

## 🔒 Security

### Script Security

✅ **Open Source**: You can review all scripts  
✅ **Automatic Backup**: You can always restore  
✅ **Harmless Operations**: Only edits Cursor files  
✅ **Known Patterns**: Uses only safe regex

### Execution Policy

Before running scripts:

```powershell
# Allow for this session only (recommended)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Or for current user
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

### Restoring Backups

**Method 1: Manual Restore**

```powershell
# For workbench.desktop.main.js
Copy-Item -Path "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js.backup" `
          -Destination "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js" `
          -Force

# For State database
Copy-Item -Path "C:\Users\YourName\cursor_rate_limit_backup_YYYYMMDD_HHMMSS\state.vscdb.backup" `
          -Destination "$env:APPDATA\Cursor\User\globalStorage\state.vscdb" `
          -Force
```

**Method 2: Reinstall Cursor**

As a last resort, completely uninstall and reinstall Cursor.

---

## 🔧 Troubleshooting

### "Script not running"

**Solution:**
```powershell
# Check execution policy
Get-ExecutionPolicy

# Bypass
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
```

---

### "Workbench file not found"

**Solution:**
1. Make sure Cursor is installed
2. If installed to non-standard location, edit the script:

```powershell
# Change path in script
$workbenchPath = "C:\CustomPath\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js"
```

---

### "Problems returned after Cursor update"

**Cause:** Cursor update changes the workbench file.

**Solution:** Run the relevant script again.

---

### "Changes not applied"

**Checklist:**
1. ✅ Is Cursor completely closed?
2. ✅ Was PowerShell opened as administrator?
3. ✅ Did script complete successfully?
4. ✅ Was Cursor restarted?

---

### "File size increased too much"

**Cause:** Encoding issue - UTF-8 BOM added.

**Solution:** 
1. Restore backup
2. Use `bypass_gemini_safe.ps1` (binary-safe)

```powershell
# Restore from backup
$workbenchPath = "$env:LOCALAPPDATA\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js"
$backupPath = "$workbenchPath.backup"  # Latest backup
Copy-Item -Path $backupPath -Destination $workbenchPath -Force
```

---

### "Rate limit still continues"

**Solution Order:**
1. **Clean state database**: `fix_cursor_rate_limit.ps1`
2. **HTTP 429 bypass**: `bypass_gemini_safe.ps1`
3. **Completely close and reopen Cursor**
4. **Re-enter your Gemini API key**

**Combo Solution:**
```powershell
# 1. Clear cache and state
.\fix_cursor_rate_limit.ps1

# 2. HTTP 429 bypass
.\bypass_gemini_safe.ps1

# 3. Fix top_k error
.\fix_cursor_top_k.ps1

# 4. Open Cursor
```

---

## 🤝 Contributing

We welcome your contributions! Here's how you can contribute:

### 1. Report New Issue

Report new issues from [Issues](https://github.com/IamYGT/cursor-fix-scripts/issues) section.

**Template:**
```markdown
**Problem:**
[Write error message here]

**Cursor Version:**
[e.g., 0.42.3]

**Windows Version:**
[e.g., Windows 11 23H2]

**Steps:**
1. [Explain how you reproduced the problem]
```

### 2. Submit Pull Request

```bash
# Fork
git fork https://github.com/IamYGT/cursor-fix-scripts

# Create branch
git checkout -b feature/new-solution

# Commit changes
git commit -m "feat: solution added for new problem"

# Push
git push origin feature/new-solution

# Open pull request
```

### 3. Script Improvements

To improve existing scripts:
- Suggest better patterns
- Make performance optimizations
- Improve error handling

---

## 📊 Statistics

| Script | File Size | Line Count | Affected File |
|--------|-----------|------------|---------------|
| `install.ps1` | ~2.5 KB | 50 lines | Runs all scripts |
| `fix_cursor_top_k.ps1` | ~1.5 KB | 33 lines | workbench.desktop.main.js (~27 MB) |
| `fix_cursor_rate_limit.ps1` | ~2.4 KB | 54 lines | state.vscdb + Cache |
| `bypass_gemini_safe.ps1` | ~3.8 KB | 87 lines | workbench.desktop.main.js (~27 MB) |

---

## 🎓 Technical Details

### Regex Pattern Explanations

#### Pattern 1: `top_k` Removal
```powershell
',\s*top_k\s*:\s*[^,}]+'
```
- `,` : Starting with comma
- `\s*` : 0 or more spaces
- `top_k` : "top_k" text
- `\s*:\s*` : Colon with or without spaces
- `[^,}]+` : Any character except comma or }

#### Pattern 2: Rate Limit Control Disable
```powershell
'(if\s*\([^)]*rate.?limit[^)]*\))\s*{([^}]*throw[^}]*)}' → 'if(false){$2}'
```
- `if\s*\(` : "if" with opening parenthesis
- `[^)]*rate.?limit[^)]*` : Condition containing "rate limit"
- `{([^}]*throw[^}]*)}` : Block containing "throw"
- `if(false)` : Make condition always false

---

## 🌟 Popular Usage Scenarios

### Scenario 1: Initial Installation (Recommended)
```powershell
# Full protection package
.\fix_cursor_top_k.ps1              # Fix top_k error
.\bypass_gemini_safe.ps1            # HTTP 429 bypass
.\fix_cursor_rate_limit.ps1         # Clear cache
```

### Scenario 2: After Update
```powershell
# Re-run only workbench scripts
.\fix_cursor_top_k.ps1
.\bypass_gemini_safe.ps1
```

### Scenario 3: Rate Limit Problem Only
```powershell
# Two-step solution
.\fix_cursor_rate_limit.ps1         # Clear state database
.\bypass_gemini_safe.ps1            # HTTP 429 bypass
```

### Scenario 4: Not Using Gemini
```powershell
# Only basic fixes
.\fix_cursor_top_k.ps1
.\fix_cursor_rate_limit.ps1
```

---

## 📚 References

- [Cursor IDE Official Documentation](https://cursor.sh/docs)
- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [PowerShell Documentation](https://docs.microsoft.com/powershell)

---

## 🛠️ Requirements

- **Windows 10/11**: (Windows 8.1+ might work)
- **PowerShell 5.1+**: (Pre-installed by default)
- **Cursor IDE**: Any version
- **Administrator Rights**: To run scripts

---

## 🔄 Update History

### v1.1.0 (2025-11-21)
- 🎯 **NEW**: `bypass_gemini_safe.ps1` added (RECOMMENDED)
- ✅ HTTP 429 rate limit bypass - binary-safe
- ✅ Encoding issue fixed
- 📝 README updated (bypass script included)
- 🔧 Usage examples for all scenarios

### v1.0.0 (2025-11-21)
- ✨ Initial release
- ✅ `fix_cursor_top_k.ps1` added
- ✅ `fix_cursor_rate_limit.ps1` added
- ✅ `remove_gemini_rate_limit.ps1` added
- 📝 Detailed README prepared

---

## ❓ FAQ (Frequently Asked Questions)

### Are the scripts harmful?

**No.** All scripts are open source and reviewable. They only edit Cursor's configuration files and create automatic backups.

### Does Cursor update break the scripts?

**Yes, in some updates.** When Cursor is updated, the `workbench.desktop.main.js` file changes. In this case, running the scripts again is sufficient.

### Do the scripts work on other IDEs?

**No.** These scripts are specifically designed for Cursor IDE. They don't work on VS Code, VS Code forks, or other IDEs.

### Is there Linux/macOS support?

**Not currently.** These scripts are written for Windows PowerShell. However, bash versions can be easily adapted. If you want to contribute, send a pull request!

### Are the scripts licensed?

**MIT License.** You can freely use, modify, and distribute.

### Which script should I use?

**If you're using Gemini (RECOMMENDED):**
1. `bypass_gemini_safe.ps1` - HTTP 429 bypass (safest)
2. `fix_cursor_top_k.ps1` - Fix top_k error
3. `fix_cursor_rate_limit.ps1` - Clear cache

**If you only have top_k problem:**
- `fix_cursor_top_k.ps1`

**Rate limit but not using Gemini:**
- `fix_cursor_rate_limit.ps1` (clears state database)

### File size increased, what should I do?

**Problem:** Encoding error - UTF-8 BOM added.

**Solution:**
1. Restore backup
2. Use `bypass_gemini_safe.ps1` (binary-safe, file size doesn't change)
3. **DON'T USE** other scripts

---

## 💬 Support

Having problems? Need help?

- 🐛 **Bug Report**: [Issues](https://github.com/IamYGT/cursor-fix-scripts/issues)
- 💡 **Feature Request**: [Discussions](https://github.com/IamYGT/cursor-fix-scripts/discussions)
- 📧 **Email**: Open an issue on GitHub

---

## 🙏 Thanks

Thanks for using these scripts! If they helped you:

- ⭐ Star the repo
- 🔄 Share with friends
- 🐛 Report issues
- 🤝 Contribute

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ by developers, for developers**

[⬆ Back to Top](#-cursor-ide-fix-scripts)

</div>
