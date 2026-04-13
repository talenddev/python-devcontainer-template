#!/bin/bash
# Syncs all agent files from .claude/agents/ to .opencode/agents/
# Preserves .opencode YAML headers and updates agent references

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_AGENTS_DIR="${2:-"$PWD/.claude/agents"}"
OPENCODE_AGENTS_DIR="${3:-"$PWD/.opencode/agents"}"

if [[ ! -d "$CLAUDE_AGENTS_DIR" ]]; then
    echo "Error: $CLAUDE_AGENTS_DIR not found"
    exit 1
fi

if [[ ! -d "$OPENCODE_AGENTS_DIR" ]]; then
    echo "Error: $OPENCODE_AGENTS_DIR not found"
    mkdir -p "$OPENCODE_AGENTS_DIR"
fi

echo "Syncing agents from $CLAUDE_AGENTS_DIR to $OPENCODE_AGENTS_DIR..."
echo ""

SYNCED=0
for CLAUDE_FILE in "$CLAUDE_AGENTS_DIR"/*.md; do
    [[ -f "$CLAUDE_FILE" ]] || continue
    
    BASENAME=$(basename "$CLAUDE_FILE")
    OPENCODE_FILE="$OPENCODE_AGENTS_DIR/$BASENAME"
    
    echo "Processing: $BASENAME"
    
    if [[ -f "$OPENCODE_FILE" ]]; then
        "$SCRIPT_DIR/sync-agent.sh" "$CLAUDE_FILE" "$OPENCODE_FILE" 2>&1 | sed 's/^/  /'
    else
        echo "  New file - copying from $CLAUDE_FILE..."
        TEMP_FILE=$(mktemp)
        
        cp "$CLAUDE_FILE" "$TEMP_FILE"
        sed -i 's/@agent-python-\([a-z-]*\)/@python-\1/g' "$TEMP_FILE"
        
        cp "$TEMP_FILE" "$OPENCODE_FILE"
        rm "$TEMP_FILE"
        
        echo "  Created $OPENCODE_FILE"
    fi
    
    SYNCED=$((SYNCED + 1))
    echo ""
done

echo "Sync complete! $SYNCED agent(s) processed."
