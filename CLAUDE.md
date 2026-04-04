# CLAUDE.md

## Git Flow — Mandatory for All Agents

### Branch strategy
- `main`        — production only, protected, no direct commits
- `develop`     — integration branch, all features merge here first
- `feature/*`   — one branch per task, branched from develop
- `fix/*`       — bug fixes raised by tester or security reviewer
- `release/*`   — cut from develop when releasing, merged to main + develop
- `hotfix/*`    — cut from main for production incidents only

### Branch naming
feature/TASK-{N}-{short-slug}       # e.g. feature/TASK-3-order-repository
fix/TASK-{N}-{bug-slug}             # e.g. fix/TASK-3-null-order-id
hotfix/{incident-slug}              # e.g. hotfix/dlq-consumer-crash

### Commit message format (Conventional Commits)
<type>(<scope>): <short description>
feat(orders): add OrderRepository with create and list methods
fix(payments): handle None amount in charge calculation
test(orders): add edge cases for empty cart
docs(orders): add README and local setup guide
chore(deps): update requests to 2.31.0 (CVE-2023-32681)
refactor(domain): extract price calculation to pure function

Types: `feat`, `fix`, `test`, `docs`, `chore`, `refactor`, `ci`, `perf`

### Pull Request rules
- Every feature/* and fix/* branch requires a PR into develop
- PR title = commit message format
- PR must pass CI (tests + linting) before merge
- Squash merge into develop to keep history clean
- Delete branch after merge

### Protected branches
- `main` and `develop` — no direct pushes, ever
- Merging to main requires PR from a release/* or hotfix/* branch