# Security policy

## Supported status

This is an experimental, unsupported repository. It has no published supported-version matrix, security response-time commitment, or guaranteed remediation schedule. Treat local execution as your responsibility and keep independent backups.

## Report a vulnerability privately

Do **not** open a public issue for a suspected vulnerability, exposed credential, local file disclosure, or a reproducible bypass of a provider control.

1. Use GitHub's private vulnerability reporting for this repository if it is available.
2. If private reporting is unavailable, contact the repository owner through the [GitHub profile](https://github.com/IamYGT) and ask for a private reporting channel.
3. Include affected script name, Cursor/Windows version, minimal reproduction steps, and impact. Redact API keys, access tokens, personal paths, databases, logs, and proprietary application bundles.

Do not send a live exploit, secret, or copied `workbench.desktop.main.js` file in a public issue, pull request, discussion, or comment.

## Scope and safety boundaries

The scripts modify local Cursor state or installed workbench files. They do not and must not claim to bypass provider-side quotas, billing, authentication, rate limits, or other service controls. A provider-side limit must be handled through the provider's supported account, quota, billing, retry, or support path.

If a script causes data loss, corruption, unexpected process termination, a credential disclosure risk, or a local privilege issue, stop using it, preserve the relevant backup without publishing it, and report it privately as above.