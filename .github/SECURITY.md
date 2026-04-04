# Security Policy

## Reporting a vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Report vulnerabilities privately via [GitHub Security Advisories](../../security/advisories/new). Include:

- A description of the vulnerability and its potential impact
- Steps to reproduce
- Affected versions or components
- Any suggested fix, if you have one

You will receive an acknowledgement within 48 hours and a resolution or status update within 7 days.

## Scope

In scope:
- Secrets or credentials exposed through this template
- Devcontainer configuration that could compromise host security
- CI/CD pipeline vulnerabilities (secret exfiltration, supply chain)
- Agent configurations that could enable unintended destructive actions

Out of scope:
- Vulnerabilities in upstream tools (uv, ruff, Claude Code) — report those to their respective projects
- Issues that require physical access to the developer's machine
