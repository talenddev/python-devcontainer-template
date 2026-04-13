#!/bin/bash
# Syncs agent file from .claude/agents/ to .opencode/agents/
# Preserves YAML headers (model/tools) and updates agent references

set -e

CLAUDE_FILE="${1}"
OPENCODE_FILE="${2}"

if [[ ! -f "$CLAUDE_FILE" ]]; then
    echo "Error: $CLAUDE_FILE not found"
    echo "Usage: $0 [claude_file] [opencode_file]"
    exit 1
fi

if [[ ! -f "$OPENCODE_FILE" ]]; then
    echo "Error: $OPENCODE_FILE not found"
    echo "Usage: $0 [claude_file] [opencode_file]"
    exit 1
fi

echo "Extracting YAML header from $OPENCODE_FILE..."
YAML_HEADER_OPENCODE=$(sed -n '1,/^---$/p' "$OPENCODE_FILE")
echo "Extracting YAML header from $CLAUDE_FILE..."
YAML_HEADER_CLAUDE=$(sed -n '1,/^---$/p' "$CLAUDE_FILE")

echo "Extracting body content from $CLAUDE_FILE..."
YAML_LINES=$(echo "$YAML_HEADER_CLAUDE" | wc -l)
BODY_CONTENT=$(tail -n +$((YAML_LINES + 1)) "$CLAUDE_FILE")

echo "Creating temporary merged file..."
TEMP_FILE=$(mktemp)

echo "$YAML_HEADER_OPENCODE" > "$TEMP_FILE"
# echo "" >> "$TEMP_FILE"
echo "$BODY_CONTENT" | sed 's/@agent-python-\([a-z-]*\)/@python-\1/g' >> "$TEMP_FILE"

echo "Writing synced content to $OPENCODE_FILE..."
mv "$TEMP_FILE" "$OPENCODE_FILE"

echo "Sync complete!"
echo ""
echo "Files:"
echo "  Source: $CLAUDE_FILE"
echo "  Target: $OPENCODE_FILE"
