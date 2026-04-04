#!/bin/bash
set -e

echo "Setting up development environment..."

# Install uv package manager
echo "Installing uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH for the rest of this script
export PATH="$HOME/.local/bin:$PATH"

# Persist PATH in zsh config for interactive sessions
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# Install Claude Code via npm (Node.js provided by devcontainer feature)
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# Install project dependencies
echo "Installing project dependencies..."
if [ -f "pyproject.toml" ]; then
    uv sync --dev
fi

# Verify installations
echo "Verifying installations..."
python3 --version
uv --version
claude --version

echo "Development environment setup complete!"
echo ""
echo "Available tools:"
echo "  - Python 3.12: python3"
echo "  - uv package manager: uv"
echo "  - Claude Code: claude"
echo ""
echo "To get started:"
echo "  1. Use 'uv add <package>' to install Python packages"
echo "  2. Use 'claude' to start an interactive Claude Code session"
