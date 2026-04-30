# task_viewer

A read-only internal web frontend that reads AI agent task directories from disk and displays their current stage, history, and brief in a browser. No database, no write operations — it scans the filesystem on every request.

## How to run

Prerequisites: Python 3.12+, [`uv`](https://docs.astral.sh/uv/)

```bash
cd task_viewer

# Install dependencies
uv sync

# Start the server (default: http://localhost:8080)
uv run uvicorn task_viewer.main:app --port 8080

# Point at a different tasks directory
TASK_VIEWER_TASKS_DIR=/path/to/tasks uv run uvicorn task_viewer.main:app --port 8080

# With hot-reload during development
uv run uvicorn task_viewer.main:app --port 8080 --reload
```

The UI is at `http://localhost:8080`. Auto-generated API schema is at `http://localhost:8080/docs`.

## Configuration

All settings use the `TASK_VIEWER_` prefix and can be set as environment variables or in a `.env` file in the working directory.

| Variable | Default | Description |
|---|---|---|
| `TASK_VIEWER_TASKS_DIR` | `tests/tasks` | Path to the directory containing task subdirectories |
| `TASK_VIEWER_PORT` | `8080` | Listening port (passed to uvicorn separately — see note below) |
| `TASK_VIEWER_POLL_INTERVAL_SECONDS` | `3` | How often the browser polls for updates, in seconds |

Note: `TASK_VIEWER_PORT` is read by `config.py` but uvicorn's port must be set via its own `--port` flag or via a process manager. The setting exists for reference in orchestration configs.

## API routes

| Method | Path | Response | Description |
|---|---|---|---|
| `GET` | `/` | HTML page | Task list — full page |
| `GET` | `/tasks/{task_id}` | HTML page | Task detail — full page |
| `GET` | `/api/tasks` | HTML fragment | HTMX: table rows, polled by the list page |
| `GET` | `/api/tasks/{task_id}` | HTML fragment | HTMX: detail body, polled by the detail page |
| `GET` | `/healthz` | `{"ok": true}` | Liveness probe |

`{task_id}` must match `TASK-{digits}-{lowercase-slug}` (e.g. `TASK-1-schema-and-errors`). Anything else returns `400`.

There are no `POST`, `PUT`, or `DELETE` routes. The service is structurally read-only.

## Task file format

Each task lives in its own subdirectory under `TASK_VIEWER_TASKS_DIR`. The directory name must follow the pattern `TASK-{N}-{slug}` (all lowercase slug).

```
TASK-1-schema-and-errors/
├── state.json       # required — machine-readable state
├── brief.md         # optional — markdown written by the tech lead
└── handoffs/        # optional — per-stage handoff files (not parsed)
```

### state.json

All fields except `branch` and `pr` are required.

```json
{
  "task_id": "TASK-1",
  "slug": "schema-and-errors",
  "stage": "done",
  "stage_history": [
    {
      "stage": "coding",
      "agent": "python-developer",
      "started": "2026-04-13T00:00:00Z",
      "ended": "2026-04-13T00:30:00Z",
      "result": "ok"
    }
  ],
  "fix_iterations": {
    "review": 0,
    "test": 0
  },
  "branch": "feature/TASK-1-schema-and-errors",
  "pr": "https://github.com/org/repo/pull/42",
  "depends_on": ["TASK-2"],
  "security_hints": ["handles JWT"],
  "blockers": []
}
```

Field reference:

| Field | Type | Values / constraints |
|---|---|---|
| `task_id` | string | `TASK-{N}` — e.g. `TASK-1` |
| `slug` | string | Lowercase alphanumeric and hyphens — e.g. `schema-and-errors` |
| `stage` | string | `pending`, `coding`, `migrating`, `reviewing`, `fixing_review`, `testing`, `fixing_test`, `merging`, `done`, `blocked` |
| `stage_history` | array | Ordered list of stage transitions (see below) |
| `fix_iterations.review` | integer | 0–2, count of review fix cycles |
| `fix_iterations.test` | integer | 0–3, count of test fix cycles |
| `branch` | string or null | Git branch name |
| `pr` | string or null | GitHub PR URL or `"merged"` |
| `depends_on` | string array | Task IDs that must be `done` before this task leaves `pending` |
| `security_hints` | string array | Free-text notes forwarded to the security reviewer agent |
| `blockers` | string array | Human-readable descriptions of what is blocking the task |

Each `stage_history` entry:

| Field | Type | Values |
|---|---|---|
| `stage` | string | Stage name |
| `agent` | string or null | Agent identifier |
| `started` | datetime or null | ISO 8601 |
| `ended` | datetime or null | ISO 8601 |
| `result` | string or null | `ok`, `blocked`, `bugs`, `skipped`, `error`, or `null` |

### brief.md

A markdown file written by the tech lead. No frontmatter — all structured data is in `state.json`.

The first line must follow this format for the title to be parsed correctly:

```
TASK-1: OutputRecord schema and RowError model
```

If `brief.md` is absent or the first line does not match that pattern, the title falls back to the slug converted to title case (`schema-and-errors` becomes `Schema And Errors`).

The full content of `brief.md` is rendered as HTML on the task detail page (fenced code blocks and tables are supported).

## Running tests

```bash
cd task_viewer

# All tests with coverage report
uv run pytest

# Unit tests only (no infrastructure needed)
uv run pytest tests/test_loader.py

# API tests only
uv run pytest tests/test_api.py

# Stop on first failure
uv run pytest -x
```

Coverage is measured against `src/task_viewer` and reported to the terminal automatically (configured in `pyproject.toml`).

## Design decisions

- **Polling over WebSockets.** The browser polls `/api/tasks` and `/api/tasks/{id}` every `TASK_VIEWER_POLL_INTERVAL_SECONDS` seconds via HTMX. This avoids maintaining persistent connections and keeps the server stateless. Acceptable latency for a dev tool where task state changes on the order of minutes.

- **Server-side markdown rendering.** `brief.md` is rendered to HTML on the server using the `markdown` library (fenced code and tables extensions enabled). No client-side JavaScript markdown parser is required.

- **Read-only enforcement by omission.** There are no write routes (`POST`/`PUT`/`DELETE`). FastAPI returns `405 Method Not Allowed` for any write attempt against an existing path. The loader never writes to disk.

- **Path traversal safety.** `load_task` resolves the requested path with `Path.resolve()` and checks that the result is a child of `tasks_dir` before reading anything. The task ID is also validated against `^TASK-\d+-[a-z0-9-]+$` at the HTTP layer, so path components like `../` are rejected with `400` before they reach the filesystem.

- **Graceful degradation on bad files.** Malformed or missing `state.json` files are skipped with a `WARNING` log line. A single broken task directory never causes a `500` or prevents other tasks from loading.

- **No database.** Task state lives entirely on disk. The viewer is stateless — it reads files fresh on every request. This means it always reflects the current state without any sync mechanism.
