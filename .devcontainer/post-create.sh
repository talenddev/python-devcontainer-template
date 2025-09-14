#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Update package lists
sudo apt-get update

# Install uv package manager
echo "📦 Installing uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# Add uv to PATH for current session
export PATH="$HOME/.local/bin:$PATH"

# Install Claude Code
echo "🤖 Installing Claude Code..."
# First, install Node.js if not present (Claude Code is distributed as npm package)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Claude Code globally
sudo npm install -g @anthropic-ai/claude-code

# Verify installations
echo "✅ Verifying installations..."
python3 --version
uv --version
claude --version

# Create a sample Python project structure
echo "📁 Creating sample project structure..."
mkdir -p /workspaces/sample-project
cd /workspaces/sample-project

# Initialize a Python project with uv
uv init --name sample-project --python 3.12

# Install some common development packages
uv add --dev pytest black flake8 isort mypy

echo "🎉 Development environment setup complete!"
echo ""
echo "Available tools:"
echo "  - Python 3.12: python3"
echo "  - UV package manager: uv"
echo "  - Claude Code: claude-code"
echo ""
echo "To get started:"
echo "  1. Use 'uv add <package>' to install Python packages"
echo "  2. Use 'claude-code' to interact with Claude for coding tasks"
echo "  3. Your project is initialized in /workspaces/sample-project"