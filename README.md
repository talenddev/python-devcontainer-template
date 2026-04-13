# Python Development Template for Claude/Opencode

## 🗺️ Team Overview

This template provides a coordinated AI agent team for Python development workflows:
- **System design & architecture** — Define service boundaries, docker-compose, and infrastructure skeletons
- **Build orchestration** — Manage the multi-agent development loop from design to production
- **Code quality gates** — Review, test, and verify before deployment
- **DevOps automation** — Terraform, ECS, CI/CD pipelines
- **Release management** — Versioning, changelogs, hotfix handling

```
You ──▶ python-architect              "design the system"
            │
            │  produces:
            │  ├── ARCHITECTURE BRIEF  ─────▶ python-tech-lead
            │  ├── docker-compose.yml
            │  ├── INFRA BRIEF             ─▶ devops
            │  └── DOCS BRIEF              ─▶ docs-writer
            ▼
python-tech-lead                      "implement the brief"
            │
            │  orchestrates the full development loop:
            │  1. python-developer       builds code
            │  2. python-migrator        schema changes (if any)
            │  3. python-reviewer        code quality gate
            │  4. python-tester          coverage ≥ 90%
            │  5. fix loop (max 3 iters)
            │  6. merge checklist
            ▼
python-security-reviewer             (security gate)
            │
            ├── 🔴 critical/high  → fix/* branch → re-review (max 2x)
            └── 🟢 clean          → proceed
            ▼
docs-writer                          (documentation gate)
            │
            │  generates:
            │  ├── services/*/README.md
            │  ├── docs/local-setup.md
            │  ├── docs/api/*.md
            │  ├── docs/adr/ADR-*.md
            │  └── docs/runbooks/*.md
            ▼
devops                               (infrastructure)
            │
            Terraform + ECS + RDS + SQS + CI/CD + CloudWatch
            ▼
release-manager                      (shipping)
            │
            cut release/* → bump version → CHANGELOG
            → PR to main → tag → back-merge to develop
```

---

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
   export PATH="$HOME/.local/bin:$PATH"
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

   pip install graphifyy
   graphify install

   # Install Claude Code via npm (Node.js provided by devcontainer feature)
   npm install -g @anthropic-ai/claude-code

   graphify claude install

   # Install OpenCode
   curl -fsSL https://opencode.ai/install | bash
   graphify opencode install
   ```

---

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

---

## 🤖 Agent Team

### python-architect
**System Design & Architecture**

Designs the initial system structure, defines service boundaries, and creates infrastructure scaffolding.

| Trigger | What it produces |
|---|---|
| `"design"` | System architecture document |
| `"architect"` | Service boundary definitions |
| `"how should I structure"` | Directory structure recommendations |
| `"microservice"` | Service decomposition plan |
| `"define infra"` | Infrastructure brief for devops |
| `"docker-compose"` | Local development skeleton |

**Usage Example:**
```bash
# Design a new orders microservice
claude "design an orders microservice for handling checkout"

# Or trigger the agent
claude /graphify "create order service"
```

---

### python-tech-lead
**Build Orchestration**

Manages the full development loop, delegating tasks to developer, tester, reviewer, and migrator agents.

| Trigger | What it does |
|---|---|
| `"build this"` | Starts full implementation loop |
| `"implement the brief"` | Executes architect's design |
| `"run the team"` | Orchestrates all agents |
| `"start the project"` | Initial development cycle |
| `"coordinate the team"` | Multi-agent coordination |

**Usage Example:**
```bash
# After architect produces a design
claude "implement the brief from architecture doc"

```

---

### python-developer
**Code Implementation**

Writes Python code using uv, FastAPI, SQLAlchemy, and SQS. Handles all coding tasks assigned by the tech-lead.

| Trigger | What it does |
|---|---|
| assigned by tech-lead | Implements code tasks |

**Usage Example:**
```bash
# The developer runs automatically when tech-lead assigns tasks
# Manual invocation:
claude "create the Order model with create and list methods"
```

---

### python-reviewer
**Code Quality Review**

Reviews code for KISS/YAGNI adherence, type safety, and architectural boundary violations. Runs before testing.

| Trigger | What it does |
|---|---|
| `"review this code"` | Reviews code quality |
| `"check code quality"` | Validates design and patterns |
| assigned by tech-lead | Automated code review |

**Usage Example:**
```bash
# After developer completes implementation
claude "review this code before testing"

# Or manually trigger
claude /review "src/orders/models.py"
```

---

### python-migrator
**Database Migration**

Writes and verifies Alembic migrations, handles zero-downtime patterns for schema changes.

| Trigger | What it does |
|---|---|
| `"add migration"` | Creates new migration |
| `"schema change"` | Schema modification migration |
| `"new model"` | Model-based migration |
| `"backfill"` | Data backfill migration |
| assigned by tech-lead | Automated migration task |

**Usage Example:**
```bash
# Create migration for new model
claude "add migration for new OrderStatus enum"

# Create backfill migration
claude "backfill existing orders with new status enum"
```

---

### python-tester
**Testing & Coverage**

Audits test coverage (target ≥ 90%), raises bug reports, runs test suites.

| Trigger | What it does |
|---|---|
| assigned by tech-lead | Runs test suite |
| `"add tests"` | Creates test cases |
| `"check coverage"` | Coverage audit |
| `"why is this test failing"` | Debug failing tests |

**Usage Example:**
```bash
# After code review passes
claude "run tests and check coverage"

# Or manually
claude "add edge cases for empty cart"
```

---

### python-security-reviewer
**Security Gate**

Security review before documentation or AWS promotion. Checks vulnerabilities, secrets, and permissions.

| Trigger | What it does |
|---|---|
| `"security review"` | Security audit |
| `"security audit"` | Vulnerability scan |
| `"before we deploy"` | Pre-deployment security check |
| `"check secrets"` | Secret validation |
| `"OWASP"` | OWASP checklist |
| assigned by tech-lead | Automated security gate |

**Usage Example:**
```bash
# Before documentation or AWS promotion
claude "security review before deploying"

# Check for vulnerabilities
claude "scan for CVE-2023-32681 in dependencies"
```

---

### docs-writer
**Documentation**

Generates README files, API docs, ADRs, runbooks, and local setup guides.

| Trigger | What it produces |
|---|---|
| `"write docs"` | Documentation generation |
| `"document this"` | Contextual documentation |
| `"create README"` | Service README |
| `"write a runbook"` | Operational runbook |
| `"ADR"` | Architecture decision record |
| assigned by tech-lead | Auto docs after security passes |

**Usage Example:**
```bash
# Write service documentation
claude "write docs for the orders service"

# Generate local setup guide
claude "write docs/local-setup.md"
```

---

### devops
**Infrastructure & DevOps**

Handles Terraform, ECS, RDS, SQS, CI/CD pipelines, Docker containers, and AWS promotion.

| Trigger | What it does |
|---|---|
| `"deploy"` | Deployment preparation |
| `"terraform"` | Terraform operations |
| `"promote to prod"` | AWS promotion |
| `"ci/cd"` | Pipeline configuration |
| `"dockerise"` | Containerization |
| `"ECS"` | ECS service definition |
| `"RDS"` | Database setup |
| `"SQS"` | Message queue configuration |

**Usage Example:**
```bash
# Deploy to AWS
claude "deploy the orders service to production"

# Terraform state operations
claude "apply terraform for rds endpoint"
```

---

### release-manager
**Release Management**

Cuts release branches, bumps versions, generates changelogs, merges to main, tags releases, handles hotfixes.

| Trigger | What it does |
|---|---|
| `"release"` | Cutting release branch |
| `"ship this"` | Prepares release |
| `"tag a version"` | Version tagging |
| `"hotfix"` | Hotfix branch creation |
| `"cut a release"` | Release pipeline |
| `"bump version"` | Semantic version bump |
| `"prepare release"` | Release preparation |

**Usage Example:**
```bash
# Cut a release branch
claude "prepare release v0.5.0"

# Handle a production hotfix
claude "hotfix for customer-facing checkout bug"
```

---

### python-data-scientist
**Data Science & ML**

Performs exploratory data analysis, feature engineering, model training, prediction, classification, and evaluation.

| Trigger | What it does |
|---|---|
| `"train a model"` | Model training |
| `"predict"` | Model prediction |
| `"classify"` | Classification task |
| `"forecast"` | Time series forecasting |
| `"EDA"` | Exploratory data analysis |
| `"feature engineering"` | Feature creation |
| `"evaluate model"` | Model evaluation |

**Usage Example:**
```bash
# Train a model
claude "train a model to predict order defaults"

# Run EDA on customer data
claude "EDA on customer churn dataset"
```

---

## 🛠️ OpenCode Tools

The following OpenCode agent tools are available:

| Tool | Description |
|---|---|
| `mcp__claude_ai_Excalidraw__create_view` | Create hand-drawn diagrams |
| `mcp__claude_ai_Excalidraw__export_to_excalidraw` | Export diagrams to excalidraw.com |
| `mcp__claude_ai_Gmail__authenticate` | Authenticate Gmail access |
| `mcp__claude_ai_Google_Calendar__authenticate` | Authenticate Google Calendar |
| `mcp__claude_ai_Google_Calendar__complete_authentication` | Complete calendar OAuth |

---

## 📂 Git Flow

### Branch Strategy
- `main` — Production only, protected, no direct commits
- `develop` — Integration branch, all features merge here
- `feature/*` — One branch per task, from develop
- `fix/*` — Bug fixes from tester or security reviewer
- `release/*` — Cut from develop when releasing, merged to main + develop
- `hotfix/*` — Cut from main for prod incidents only

### Branch Naming
- `feature/TASK-{N}-{short-slug}` — e.g., `feature/TASK-3-order-repository`
- `fix/TASK-{N}-{bug-slug}` — e.g., `fix/TASK-3-null-order-id`
- `hotfix/{incident-slug}` — e.g., `hotfix/dlq-consumer-crash`

### Commit Message Format
```
<type>(<scope>): <short description>
```

**Types:** `feat`, `fix`, `test`, `docs`, `chore`, `refactor`, `ci`, `perf`

### Pull Request Rules
- `feature/*` and `fix/*` require PR into develop
- PR title = commit message format
- Pass CI (tests + linting) before merge
- Squash merge into develop
- Delete branch after merge

### Protected Branches
- `main` and `develop` — No direct pushes, ever
- Merge to main requires PR from `release/*` or `hotfix/*` branch

---

## 📊 Code Flow

```
You ──▶ python-architect              "design the system"
            │
            │  produces:
            │  ├── ARCHITECTURE BRIEF  ──────────────────────▶ python-tech-lead
            │  ├── docker-compose.yml  (local infra skeleton)
            │  ├── INFRA BRIEF         ──────────────────────▶ devops
            │  └── DOCS BRIEF          ──────────────────────▶ docs-writer
            ▼
python-tech-lead                      "implement the brief"
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
    docs-writer                       (gate 2)
            │
            │  produces:
            │  ├── services/*/README.md
            │  ├── docs/local-setup.md
            │  ├── docs/api/*.md
            │  ├── docs/adr/ADR-*.md
            │  └── docs/runbooks/*.md
            ▼
    devops                            (promotion)
            │
            │  Terraform + ECS + RDS + SQS + CI/CD + CloudWatch
            ▼
            🚀 Production
            │
            ▼
    release-manager                   (shipping)
            │
            │  cut release/* → bump version → CHANGELOG
            │  → PR to main → tag → back-merge to develop
            ▼
            🏷️  v{X.Y.Z} tagged on main
```
