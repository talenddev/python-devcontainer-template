TASK-4: Anthropic Claude provider implementation (chat + stream, no tool calls)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT
  What exists: src/aiproxy/providers/anthropic.py as empty stub, full domain types and
    Provider protocol from TASK-2 and TASK-3.
  What this task enables: TASK-6 (integration round-trip), TASK-7 (tool-call support for Anthropic).

DEPENDS ON
  TASK-3

OBJECTIVE
  Implement AnthropicProvider satisfying the Provider protocol: AnthropicSettings (pydantic-settings),
  chat() and stream() using httpx, message translation between neutral types and Anthropic wire format,
  and HTTP error mapping to the error taxonomy. All tests use respx mocks — no live API calls.

ACCEPTANCE CRITERIA
  - [ ] AnthropicSettings: api_key (SecretStr), base_url, api_version, timeout_s with env_prefix="ANTHROPIC_"
  - [ ] AnthropicProvider.__init__ accepts **kwargs forwarded to AnthropicSettings
  - [ ] AnthropicProvider.name == "anthropic"
  - [ ] chat() builds Anthropic messages API payload from ChatRequest:
        - system field mapped from ChatRequest.system
        - user/assistant messages with TextPart → {type: text, text: ...}
        - ToolUsePart → {type: tool_use, id, name, input}
        - ToolResultPart → {type: tool_result, tool_use_id, content}
        - ToolSpec list → tools field in payload
        - temperature, max_tokens, stop_sequences forwarded when set
  - [ ] chat() parses Anthropic response into ChatResponse:
        - content blocks: text → TextPart, tool_use → ToolUsePart
        - finish_reason: "end_turn"→"stop", "max_tokens"→"length", "tool_use"→"tool_use"
        - usage.input_tokens and usage.output_tokens mapped to Usage
        - raw set to full response dict
  - [ ] stream() uses SSE (text/event-stream) and emits neutral StreamEvents:
        - content_block_delta/text_delta → TextDelta
        - content_block_delta/input_json_delta → ToolCallDelta
        - message_delta with stop_reason → StreamEnd
  - [ ] HTTP 401 → AuthenticationError, 429 → RateLimitError, timeout → TimeoutError_,
        other 4xx/5xx → ProviderError with status code
  - [ ] AnthropicProvider registered in registry on import: register("anthropic", ...)
  - [ ] aclose() closes the underlying httpx.AsyncClient
  - [ ] tests/unit/providers/test_anthropic.py: uses respx to mock POST /v1/messages:
        - test_chat_text_response: single TextPart in response
        - test_chat_maps_finish_reason_stop
        - test_chat_maps_finish_reason_length
        - test_chat_authentication_error (401 → AuthenticationError)
        - test_chat_rate_limit_error (429 → RateLimitError)
        - test_stream_text_deltas: SSE stream yields TextDelta events then StreamEnd
  - [ ] `uv run pytest tests/unit/providers/test_anthropic.py -v` exits 0
  - [ ] `uv run mypy src/aiproxy/providers/anthropic.py` exits 0
  - [ ] Coverage >= 90% on anthropic.py

FILES TO CREATE OR MODIFY
  - src/aiproxy/providers/anthropic.py      ← implement
  - tests/unit/providers/__init__.py        ← new
  - tests/unit/providers/test_anthropic.py  ← new

CONSTRAINTS
  - Use httpx.AsyncClient directly (not the anthropic SDK) — keep deps minimal
  - Use respx for all HTTP mocking in tests; no live API calls
  - Anthropic API version header: "anthropic-version": settings.api_version
  - x-api-key header from settings.api_key.get_secret_value()
  - SSE parsing: iterate response lines, parse "data: {...}" lines as JSON
  - Tool calls (ToolUsePart, ToolResultPart) in chat() must be translatable but
    tool-call-specific TESTS are deferred to TASK-7
  - uv add anthropic-related deps if needed; prefer raw httpx over the anthropic SDK

OUT OF SCOPE FOR THIS TASK
  - Live integration tests against api.anthropic.com
  - Tool-call-specific unit tests (covered in TASK-7)
  - Ollama provider (TASK-5)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GIT
  Branch: feature/TASK-4-anthropic-provider  (branch from develop)
  Commit when done:
    feat(anthropic): implement AnthropicProvider with chat and stream
  Open PR into: develop
