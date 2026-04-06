# Security Policy

## Reporting a Vulnerability

If you discover a security issue, please report it privately via [GitHub Security Advisories](../../security/advisories/new).

Do not open a public issue for security vulnerabilities.

## Scope

claude-memory is a bootstrap installer for Claude Code configuration. The primary security concern is accidental exposure of personal data in memory files or credentials in config.

**Reminders:**
- Memory seed files (`memory-seed/`) are gitignored by default
- `global/settings.json` may contain hook paths — verify no secrets before pushing
- Never commit files containing API keys, tokens, or sensitive personal information
- Review your `.gitignore` before pushing to a public repository
- Run `./verify.sh` to check repo integrity before publishing
