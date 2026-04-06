# Security Policy

## Reporting a Vulnerability

If you discover a security issue, please report it privately via [GitHub Security Advisories](../../security/advisories/new).

Do not open a public issue for security vulnerabilities.

## Scope

claude-memory is a set of markdown templates and a shell script. The primary security concern is accidental exposure of personal data in memory files.

**Reminders:**
- Memory files (`MEMORIES.md`, `decisions.md`, `projects/`, `known-issues/`) are gitignored by default
- Never commit files containing secrets, API keys, or sensitive personal information
- Review your `.gitignore` before pushing to a public repository
