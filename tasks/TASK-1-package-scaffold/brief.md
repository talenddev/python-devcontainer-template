TASK-1: Package scaffold — pyproject.toml, src layout, empty modules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT
  What exists: src/__init__.py (empty), pyproject.toml (project name "src", no aiproxy deps).
  What this task enables: All subsequent tasks import from `aiproxy.*`.

DEPENDS ON
  none

OBJECTIVE
  Reconfigure pyproject.toml for the `aiproxy` package, create the `src/aiproxy/` package
  tree with correct empty `__init__.py` files, add required runtime and dev dependencies,
  and ensure `uv run pytest` passes with zero collection errors on an empty suite.

ACCEPTANCE CRITERIA
  - [ ] pyproject.toml: project name is "aiproxy", version "0.1.0"
  - [ ] pyproject.toml: package source is src/aiproxy (hatchling src layout or equivalent)
  - [ ] pyproject.toml: runtime dependencies include httpx>=0.27, pydantic-settings>=2.3
  - [ ] pyproject.toml: dev dependencies include pytest, pytest-cov, pytest-asyncio, respx, ruff, mypy
  - [ ] src/aiproxy/__init__.py exists (may be empty or expose top-level symbols)
  - [ ] src/aiproxy/providers/__init__.py exists (empty)
  - [ ] src/aiproxy/types.py exists (empty stub — just a module-level docstring or pass)
  - [ ] src/aiproxy/streaming.py exists (empty stub)
  - [ ] src/aiproxy/provider.py exists (empty stub)
  - [ ] src/aiproxy/registry.py exists (empty stub)
  - [ ] src/aiproxy/errors.py exists (empty stub)
  - [ ] src/aiproxy/client.py exists (empty stub)
  - [ ] src/aiproxy/providers/anthropic.py exists (empty stub)
  - [ ] src/aiproxy/providers/ollama.py exists (empty stub)
  - [ ] `uv run python -c "import aiproxy"` exits 0
  - [ ] `uv run pytest --no-header -q` exits 0 (no tests yet, just no import errors)
  - [ ] `uv run ruff check src/` exits 0

FILES TO CREATE OR MODIFY
  - pyproject.toml                          ← modify
  - src/aiproxy/__init__.py                 ← new
  - src/aiproxy/types.py                    ← new (stub)
  - src/aiproxy/streaming.py                ← new (stub)
  - src/aiproxy/provider.py                 ← new (stub)
  - src/aiproxy/registry.py                 ← new (stub)
  - src/aiproxy/errors.py                   ← new (stub)
  - src/aiproxy/client.py                   ← new (stub)
  - src/aiproxy/providers/__init__.py       ← new
  - src/aiproxy/providers/anthropic.py      ← new (stub)
  - src/aiproxy/providers/ollama.py         ← new (stub)

CONSTRAINTS
  - Use uv for adding dependencies (uv add httpx "pydantic-settings>=2.3", etc.)
  - Keep stubs minimal — no real logic yet; logic arrives in TASK-2 and later
  - hatchling src layout: [tool.hatch.build.targets.wheel] packages = ["src/aiproxy"]
  - pytest-asyncio must be configured: asyncio_mode = "auto" in [tool.pytest.ini_options]
  - ruff target-version = "py312"
  - mypy strict = true must remain in pyproject.toml

OUT OF SCOPE FOR THIS TASK
  - Any actual implementation in the stub files
  - Test files (TASK-2+ will add tests)
  - docker-compose changes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GIT
  Branch: feature/TASK-1-package-scaffold  (branch from develop)
  Commit when done:
    feat(scaffold): configure aiproxy package layout and dependencies
  Open PR into: develop
