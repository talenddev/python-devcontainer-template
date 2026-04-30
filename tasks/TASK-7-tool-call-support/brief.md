TASK-7: Tool-call support — one tool-call test per provider
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT
  What exists: Both providers fully implemented with tool translation logic already in place
    (per TASK-4 and TASK-5 acceptance criteria). Integration wiring confirmed by TASK-6.
  What this task enables: First milestone complete.

DEPENDS ON
  TASK-6

OBJECTIVE
  Add unit tests verifying that a ChatRequest with a ToolSpec causes each provider to:
  (a) include the tool definition in its API payload, and (b) parse a tool_use/tool_calls
  response block into a ToolUsePart in ChatResponse.content. Fix any provider bugs
  discovered during these tests.

ACCEPTANCE CRITERIA
  - [ ] tests/unit/providers/test_anthropic.py gains:
        test_chat_tool_call_response: mock returns a tool_use content block; asserts
        ChatResponse.content contains a ToolUsePart with correct id, name, and arguments;
        finish_reason == "tool_use"
  - [ ] tests/unit/providers/test_anthropic.py gains:
        test_chat_sends_tool_spec: respx captures request body; asserts tools list is present
        with correct name, description, input_schema fields
  - [ ] tests/unit/providers/test_ollama.py gains:
        test_chat_tool_call_response: mock returns tool_calls in message; asserts
        ChatResponse.content contains a ToolUsePart; finish_reason == "tool_use"
  - [ ] tests/unit/providers/test_ollama.py gains:
        test_chat_sends_tool_spec: asserts tools array present in request body
  - [ ] All 4 new tests pass: `uv run pytest tests/unit/providers/ -v` exits 0
  - [ ] `uv run pytest tests/` exits 0 (full suite clean)
  - [ ] `uv run mypy src/aiproxy/providers/` exits 0
  - [ ] Coverage >= 90% on anthropic.py and ollama.py (combined with TASK-4/5 tests)

FILES TO CREATE OR MODIFY
  - tests/unit/providers/test_anthropic.py  ← add 2 new test functions
  - tests/unit/providers/test_ollama.py     ← add 2 new test functions
  - src/aiproxy/providers/anthropic.py      ← fix if tool-call bugs found
  - src/aiproxy/providers/ollama.py         ← fix if tool-call bugs found

CONSTRAINTS
  - Use respx for all HTTP mocking
  - ToolUsePart.arguments must be a dict (parsed from JSON), not a raw string
  - Anthropic: tool_use block uses "input" key (not "arguments") — translate to arguments
  - Ollama: tool_calls[].function.arguments is a dict — map to arguments
  - Do NOT change neutral type definitions in types.py

OUT OF SCOPE FOR THIS TASK
  - Multi-turn tool-result messages (ToolResultPart round-trip)
  - Stream-mode tool call accumulation
  - Any new providers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GIT
  Branch: feature/TASK-7-tool-call-support  (branch from develop)
  Commit when done:
    feat(tools): add tool-call tests and fix provider parsing for ToolUsePart
  Open PR into: develop
