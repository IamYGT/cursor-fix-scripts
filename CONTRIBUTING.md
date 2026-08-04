# Contributing

Contributions should make the scripts more reproducible, scoped, and honest about what they can change. They must not claim to bypass provider-side quotas, billing, authentication, or rate limits.

## Development setup

Use PowerShell 7 on Windows and install the pinned test dependency:

```powershell
Install-Module Pester -RequiredVersion 6.0.1 -Scope CurrentUser
Invoke-Pester -Path tests -CI -Output Detailed
```

The tests redirect `LOCALAPPDATA`, `APPDATA`, and `USERPROFILE` into Pester's disposable `TestDrive`. They mock Cursor process discovery and must never stop a real process or touch a real Cursor profile, cache, database, or workbench file.

## Pull-request contract

- Describe the exact local symptom and affected script.
- Add or update an isolated test for every behavior change.
- Prove the missing-file, missing-pattern, backup, mutation, and containment paths that apply.
- Keep provider-side errors distinct from local state or handler behavior.
- Do not include API keys, tokens, profile databases, logs containing prompts, proprietary workbench files, or unredacted personal paths.
- Run `Invoke-Pester -Path tests -CI -Output Detailed` before opening the pull request.

## Compatibility reports

Include the Cursor version and channel, Windows version, script name, expected path, whether the target pattern existed, backup result, and result after restarting Cursor. Mark untested combinations explicitly; a single successful report is not a general compatibility guarantee.

Use [Issues](https://github.com/IamYGT/cursor-fix-scripts/issues) for reproducible defects and [Discussions](https://github.com/IamYGT/cursor-fix-scripts/discussions) for questions or compatibility reports. Follow [SECURITY.md](SECURITY.md) for private vulnerability reports.
