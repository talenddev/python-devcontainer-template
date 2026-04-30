TASK-5: Ollama provider implementation (chat + stream, no tool calls)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT
  What exists: src/aiproxy/providers/ollama.py as empty stub, full domain types and
    Provider protocol from TASK-2 and TASK-3.
  What this task enables: TASK-6 (integration round-trip), TASK-7 (tool-call support for Ollama).

DEPENDS ON
  TASK-3

OBJECTIVE
  Implement OllamaProvider satisfying the Provider protocol: OllamaSettings (pydantic-settings),
  chat() and stream() using httpx against the Ollama /api/chat endpoint (OpenAI-compatible
  with NDJSON streaming), message translation to/from neutral types, and HTTP error mapping.
  All tests use respx mocks.

ACCEPTANCE CRITERIA
  - [ ] OllamaSettings: base_url (default "http://localhost:11434"), timeout_s (default 120.0)
        with env_prefix="OLLAMA_"
  - [ ] OllamaProvider.__init__ accepts **kwargs forwarded to OllamaSettings
  - [ ] OllamaProvider.name == "ollama"
  - [ ] chat() posts to {base_url}/api/chat with stream=false:
        - ChatRequest.system folded into a {"role": "system", "content": "..."} message prepended
        - user/assistant messages with TextPart content → {role, content: str}
        - ToolSpec list → tools field (OpenAI JSON Schema format)
        - ToolUsePart in assistant message → tool_calls array element
        - ToolResultPart in user message → tool role message with tool_call_id
        - temperature, num_predict (from max_tokens), stop forwarded when set
  - [ ] chat() parses Ollama /api/chat response into ChatResponse:
        - message.content → [TextPart(text)] when present
        - message.tool_calls → [ToolUsePart(...)] when present
        - done_reason: "stop"→"stop", "length"→"length", "tool_calls"→"tool_use"
        - prompt_eval_count / eval_count → Usage
        - raw set to full response dict
  - [ ] stream() posts with stream=true, iterates NDJSON lines, emits neutral StreamEvents:
        - non-done line with message.content delta → TextDelta
        - final line with done=true → StreamEnd
  - [ ] HTTP 404 → ProviderError, timeout → TimeoutError_, other errors → ProviderError
  - [ ] OllamaProvider registered in registry on import: register("ollama", ...)
  - [ ] aclose() closes the underlying httpx.AsyncClient
  - [ ] tests/unit/providers/test_ollama.py: uses respx to mock POST /api/chat:
        - test_chat_text_response: single TextPart in response
        - test_chat_system_message_prepended: verifies system folded into messages list
        - test_chat_finish_reason_stop
        - test_chat_timeout_error (httpx.TimeoutException → TimeoutError_)
        - test_stream_text_deltas: NDJSON stream yields TextDelta events then StreamEnd
  - [ ] `uv run pytest tests/unit/providers/test_ollama.py -v` exits 0
  - [ ] `uv run mypy src/aiproxy/providers/ollama.py` exits 0
  - [ ] Coverage >= 90% on ollama.py

FILES TO CREATE OR MODIFY
  - src/aiproxy/providers/ollama.py         ← implement
  - tests/unit/providers/test_ollama.py     ← new

CONSTRAINTS
  - Use httpx.AsyncClient directly; no ollama SDK
  - Use respx for all HTTP mocking; no live Ollama calls in unit tests
  - NDJSON streaming: each line is a JSON object; stream until done=true
  - Ollama has no authentication — no API key handling needed
  - Tool calls in chat() must be translatable but tool-call-specific TESTS are TASK-7
  - Usage fields may be 0 if Ollama omits them — handle gracefully (default to 0)

OUT OF SCOPE FOR THIS TASK
  - Live integration tests (tests/integration/test_ollama_live.py — belongs to TASK-6)
  - Tool-call-specific unit tests (covered in TASK-7)
  - Anthropic provider (TASK-4)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GIT
  Branch: feature/TASK-5-ollama-provider  (branch from develop)
  Commit when done:
    feat(ollama): implement OllamaProvider with chat and stream
  Open PR into: develop
