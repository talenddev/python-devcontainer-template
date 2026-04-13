# Python Development Template for Claude/Opencode

## 🚀 Quick Start

1. **Use this template:**
   - Click "Use this template" → "Create a new repository"

2. **Create the `develop` branch** (required by the Git flow):
   ```bash
   git checkout -b develop
   git push -u origin develop
   ```

3. **Install tools**:
   ```bash
   echo "Installing uv package manager..."
   curl -LsSf https://astral.sh/uv/install.sh | sh
   # Add uv to PATH for the rest of this script
   export PATH="$HOME/.local/bin:$PATH"
   # Persist PATH in zsh config for interactive sessions
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

   pip install graphifyy
   graphify install

   # Install Claude Code via npm (Node.js provided by devcontainer feature)
   echo "Installing Claude Code..."
   npm install -g @anthropic-ai/claude-code

   graphify claude install

   # Install OpenCode
   curl -fsSL https://opencode.ai/install | bash
   graphify opencode install
   ```


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
claude

# Ask Claude about a specific file
claude "explain src/main.py"
```


### Open Code
```bash
# Start interactive session
opencode
```


## Agent team

| Agent | Role | Triggers on |
|---|---|---|
| `python-architect` | System design, service boundaries, local/AWS mapping | "design", "architect", "how should I structure" |
| `python-tech-lead` | Orchestrates the full build loop, coordinates all agents | "build this", "implement the brief", "run the team" |
| `python-developer` | Writes Python code (uv, FastAPI, SQLAlchemy, SQS) | assigned by tech-lead |
| `python-reviewer` | Code quality gate — KISS/YAGNI, boundary violations, type safety | "review this code", assigned by tech-lead after developer |
| `python-migrator` | Writes and verifies Alembic migrations, zero-downtime patterns | "add migration", "schema change", assigned by tech-lead |
| `python-tester` | Audits coverage (≥ 90%), raises bug reports | assigned by tech-lead after reviewer |
| `python-security-reviewer` | Security gate before docs or AWS promotion | "security review", "before we deploy" |
| `python-docs-writer` | README, API reference, ADRs, runbooks, local-setup guide | "write docs", invoked by tech-lead after security passes |
| `python-devops` | Terraform, ECS, RDS, SQS, CI/CD, monitoring | "deploy", "terraform", "promote to prod" |
| `python-release-manager` | Cuts releases, bumps versions, tags, manages hotfixes | "release", "ship this", "hotfix", "cut a release" |
| `python-data-scientist` | EDA, feature engineering, model training, evaluation, export | "train a model", "predict", "classify", "EDA", "machine learning" |

## Code flow

```
You ──▶ python-architect              "design the system"
            │
            │  produces:
            │  ├── ARCHITECTURE BRIEF  ──────────────────────▶ python-tech-lead
            │  ├── docker-compose.yml  (local infra skeleton)
            │  ├── INFRA BRIEF         ──────────────────────▶ python-devops
            │  └── DOCS BRIEF          ──────────────────────▶ python-docs-writer
            ▼
You ──▶ python-tech-lead              "implement the brief"
            │
            │  ┌─── per task (in order) ────────────────────────┐
            │  │  1. python-developer   builds                   │
            │  │  2. python-migrator    schema changes (if any)  │
            │  │  3. python-reviewer    code quality gate        │
            │  │  4. python-tester      coverage ≥ 90%           │
            │  │  5. fix loop           max 3 iterations         │
            │  │  6. merge checklist    PR → CI → squash         │
            │  └────────────────────────────────────────────────┘
            │
            │  PROGRESS.md: all tasks complete ✅
            ▼
    python-security-reviewer          (gate 1)
            │
            ├── 🔴 critical/high → fix/* branch → re-review (max 2x)
            └── 🟢 clean (medium/low logged as debt)
                    ▼
    python-docs-writer                (gate 2)
            │
            │  produces:
            │  ├── services/*/README.md
            │  ├── docs/local-setup.md
            │  ├── docs/api/*.md
            │  ├── docs/adr/ADR-*.md
            │  └── docs/runbooks/*.md
            ▼
    python-devops                     "promote to AWS"
            │
            │  Terraform + ECS + RDS + SQS + CI/CD + CloudWatch
            ▼
            🚀 Production
            │
            ▼
    python-release-manager            "ship it"
            │
            │  cut release/* → bump version → CHANGELOG
            │  → PR to main → tag → back-merge to develop
            ▼
            🏷️  v{X.Y.Z} tagged on main
```
