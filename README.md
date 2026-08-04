# Cursor local-state and workbench scripts

[Turkce README](README.tr.md) | [Security policy](SECURITY.md) | [MIT License](LICENSE)

> **Status: experimental and unsupported.** The latest repository commit is dated 2025-11-22. This repository contains no CI, automated test suite, or Cursor-version compatibility matrix. Review every script and use it only on a disposable or backed-up local Cursor installation.

## What this repository is—and is not

These Windows PowerShell scripts operate only on local Cursor files and folders. They may help diagnose a stale local state or a version-specific `top_k` issue, but they do **not** change Gemini, Cursor, or any other provider account, billing plan, quota, or server-side rate limit.

A provider-side `429`, quota, or account limit cannot be bypassed by these scripts. Use the provider's supported quota, billing, retry, or support path instead. The workbench-editing scripts can alter how the local app handles a response; they cannot make an upstream service accept a request it has limited.

## File inventory

| File | Actual behavior | Main local effect |
| --- | --- | --- |
| `fix_cursor_rate_limit.ps1` | Backs up `state.vscdb`, deletes that database, and recursively deletes Cursor `Cache` and `Code Cache`. | Resets local workbench state/cache; cache contents are **not** backed up. |
| `fix_cursor_top_k.ps1` | Backs up then regex-edits Cursor's `workbench.desktop.main.js` to remove selected `top_k` properties. | Modifies an installed application bundle. The backup name is fixed and may be overwritten on a later run. |
| `bypass_gemini_safe.ps1` | Timestamp-backs up then replaces selected local `429` comparisons with `999` in the same workbench file. | Alters local error handling only; it does not bypass provider limits and may hide or change failures. |
| `install.ps1` | Force-stops Cursor, then runs all three scripts in sequence. | Not transactional; a failure in one child script does not restore earlier changes. |

`remove_gemini_rate_limit.ps1` is not in this repository. Older documentation that referenced it was incorrect.

## Before you run anything

1. Close Cursor and sync or export work you cannot lose.
2. Record your Cursor version and make an independent copy of the target file or profile directory.
3. Read the script you intend to run. These scripts use fixed Windows paths and have not been verified against current Cursor versions.
4. Expect Cursor updates to replace `workbench.desktop.main.js`; do not assume a previously matching pattern still exists.
5. Run only one script for a specific local symptom. Do not use `install.ps1` as a general repair command.

The scripts call `Stop-Process -Force` when Cursor is running. Save unsaved editor work first. They can modify or remove local state; they do not promise recovery, safety, or compatibility.

## Windows use

From a normal PowerShell window, clone or download this repository and inspect the selected file:

```powershell
git clone https://github.com/IamYGT/cursor-fix-scripts.git
cd cursor-fix-scripts
Get-Content .\fix_cursor_rate_limit.ps1
```

If your execution policy blocks a local script, limit the change to the current shell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Run **one** script only after the checks above:

```powershell
.\fix_cursor_rate_limit.ps1  # local state/cache cleanup
.\fix_cursor_top_k.ps1       # local workbench top_k patch
.\bypass_gemini_safe.ps1     # local 429-handling patch; not a quota bypass
```

`install.ps1` runs every script and is intentionally not recommended for routine use. It does not validate whether a pattern matched, whether Cursor starts afterward, or whether an upstream error is resolved.

## Backups and recovery

- `fix_cursor_rate_limit.ps1` creates `%USERPROFILE%\cursor_rate_limit_backup_<timestamp>` and backs up only `%APPDATA%\Cursor\User\globalStorage\state.vscdb` when present.
- `bypass_gemini_safe.ps1` creates a timestamped sibling backup such as `workbench.desktop.main.js.backup_safe_<timestamp>`.
- `fix_cursor_top_k.ps1` creates `workbench.desktop.main.js.backup`, overwriting that backup on a later run.
- No script backs up the `Cache` or `Code Cache` directories before deleting them.

To recover a workbench edit, close Cursor and copy the exact backup you selected over `workbench.desktop.main.js`. If no valid backup exists, repair or reinstall Cursor through its supported installer. Never copy a backup from a different Cursor version without reviewing it.

## Troubleshooting boundaries

- **Workbench file not found:** the script expects `%LOCALAPPDATA%\Programs\cursor\resources\app\out\vs\workbench\workbench.desktop.main.js`. Stop rather than changing an unknown installation blindly.
- **No reported changes:** a current Cursor build may not contain the script's literal patterns. That is not evidence that the script fixed anything.
- **Cursor fails after a workbench edit:** close Cursor, restore the backup, then use a supported Cursor repair/reinstall path.
- **`429` or quota continues:** restore any local patch if needed and resolve the account/provider-side limit through supported channels. Local cleanup cannot change server enforcement.

## Maintenance and support

This is a historical, experimental repository with no promised maintenance, compatibility, response time, or support channel. Reports and pull requests may be useful, but they are not a support contract. Please include the Cursor version, Windows version, exact script, a redacted error, and whether the target pattern was present. Do not include API keys, tokens, profile databases, or proprietary workbench files.

See [SECURITY.md](SECURITY.md) for vulnerability reporting. Contributions are described in [CONTRIBUTING.md](CONTRIBUTING.md).