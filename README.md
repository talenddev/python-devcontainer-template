# Python Development Container Template

A ready-to-use VS Code dev container template with Python 3.12, uv package manager, and Claude Code.

## 🚀 Quick Start

1. **Use this template:**
   - Click "Use this template" → "Create a new repository"
   - Or clone: `git clone https://github.com/talenddev/python-devcontainer-template.git`

2. **Open in VS Code:**
   - Open the project in VS Code
   - When prompted, click "Reopen in Container"
   - Wait for the container to build (first time takes a few minutes)

## 🛠️ What's Included

- **Python 3.12** - Latest stable Python
- **uv** - Fast Python package manager
- **Claude Code** - AI coding assistant
- **VS Code Extensions:**
  - Python extension pack
  - Black formatter
  - Flake8 linter
  - Jupyter support
  - GitHub Copilot (if you have access)

## 📝 Usage

### Package Management with uv
```bash
# Add a dependency
uv add requests

# Add a dev dependency
uv add --dev pytest

# Install all dependencies
uv sync

# Run Python with uv
uv run python your_script.py
```

### Claude Code
```bash
# Start interactive session
claude-code

# Get help with a specific file
claude-code --file src/main.py
```

You ──▶ @agent-python-architect       "design the system"
            │  ARCHITECTURE BRIEF + docker-compose.yml
            ▼
You ──▶ @agent-python-tech-lead       "implement the brief"
            │
            │  ┌─── loops until all tasks green ───┐
            │  │  @agent-python-developer (builds)  │
            │  │  @agent-python-tester   (audits)   │
            │  └────────────────────────────────────┘
            │  PROGRESS.md: all tasks complete ✅
            ▼
    @agent-python-security-reviewer   (gate 1)
            │
            ├── 🔴 BLOCKED → fix → re-review
            └── 🟢 APPROVED
                    ▼
    @agent-python-docs-writer         (gate 2) ← NEW
            │
            │  produces:
            │  ├── services/*/README.md
            │  ├── docs/local-setup.md
            │  ├── docs/api/*.md
            │  ├── docs/adr/ADR-*.md
            │  ├── docs/runbooks/*.md
            │  └── CHANGELOG.md
            │
            │  HANDOFF REPORT
            ▼
    @agent-python-devops               "promote to AWS"
            │
            │  Terraform + CI/CD + CloudWatch alarms
            ▼
            🚀 Production

## 🔧 Customization

Edit `.devcontainer/post-create.sh` to:
- Add more system packages
- Install additional Python packages
- Configure your development environment

## 📁 Project Structure

- `src/` - Your Python source code
- `.devcontainer/` - Dev container configuration
- `pyproject.toml` - Python project configuration
