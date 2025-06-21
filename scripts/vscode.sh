#!/bin/bash

# Quick start script for VSCode Dev Container
# Opens the project directly in VSCode with Dev Container

set -e

echo "🚀 Starting 42 School environment in VSCode..."

# Check if in correct directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Please run this script from the 42-docker-environment directory"
    exit 1
fi

# Check if VSCode is available
if ! command -v code &> /dev/null; then
    echo "❌ VSCode not found. Please install VSCode first."
    echo "   Run: ./scripts/setup-vscode.sh"
    exit 1
fi

# Check if Dev Containers extension is installed
if ! code --list-extensions | grep -q "ms-vscode-remote.remote-containers"; then
    echo "📦 Installing Dev Containers extension..."
    code --install-extension ms-vscode-remote.remote-containers
fi

# Open in VSCode with Dev Container
echo "📂 Opening project in VSCode Dev Container..."
code .

echo ""
echo "✅ VSCode should now prompt you to 'Reopen in Container'"
echo "💡 If not, use Ctrl+Shift+P and search for 'Dev Containers: Reopen in Container'"
echo ""
echo "🎯 Once inside the container, you'll have:"
echo "   • Ubuntu 22.04 (same as 42 Madrid)"
echo "   • GCC, GDB, Valgrind, Make"
echo "   • Norminette v3"
echo "   • 42 Header (F1 to insert)"
echo "   • Full C/C++ IntelliSense"
echo "   • Integrated debugging"
