# Contributing

## Prerequisites

- VS Code with the Dev Containers extension
- Docker Desktop

Open the repo in VS Code and click **Reopen in Container** when prompted. The container installs all tools automatically.

## Branch strategy

```
main       — production, protected
develop    — integration branch, all features merge here
feature/*  — one branch per task, cut from develop
fix/*      — bug fixes, cut from develop
```

Never commit directly to `main` or `develop`.

## Workflow

```bash
# 1. Start from develop
git checkout develop && git pull origin develop

# 2. Create a branch
git checkout -b feature/TASK-{N}-{short-slug}

# 3. Make changes, then run checks locally before pushing
uv run pytest --cov=src tests/
uv run ruff check src/
uv run ruff format src/
uv run mypy src/

# 4. Commit using Conventional Commits
git commit -m "feat(scope): short description"

# 5. Push and open a PR into develop
git push -u origin feature/TASK-{N}-{short-slug}
```

## Commit message format

```
<type>(<scope>): <short description>

feat(orders): add OrderRepository with create and list methods
fix(payments): handle None amount in charge calculation
test(orders): add edge cases for empty cart
docs(api): document authentication endpoints
chore(deps): update ruff to 0.5.0
```

Types: `feat`, `fix`, `test`, `docs`, `chore`, `refactor`, `ci`, `perf`

## Running tests

```bash
# All tests with coverage
uv run pytest --cov=src --cov-report=term-missing tests/

# Single file
uv run pytest tests/test_foo.py -v

# Stop on first failure
uv run pytest -x
```

Coverage must stay at or above 90%.

## Code style

Formatting and linting are handled by `ruff` (replaces black, flake8, isort):

```bash
uv run ruff format src/    # format
uv run ruff check src/     # lint
uv run mypy src/           # type check
```

These run automatically on save inside the dev container.
