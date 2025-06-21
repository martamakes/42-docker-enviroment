#!/bin/bash

# VSCode setup script for 42 Docker Environment
# This script prepares the environment for VSCode Dev Containers

set -e

echo "🔧 Setting up VSCode Dev Container environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Check if VSCode is installed
if ! command -v code &> /dev/null; then
    echo -e "${YELLOW}⚠️  VSCode not found. Please install VSCode first:${NC}"
    echo -e "${BLUE}   🍎 macOS: https://code.visualstudio.com/download${NC}"
    echo -e "${BLUE}   🐧 Linux: sudo snap install code --classic${NC}"
    echo -e "${BLUE}   🪟 Windows: https://code.visualstudio.com/download${NC}"
    echo ""
    read -p "Press Enter when VSCode is installed..."
fi

# Check if Dev Containers extension is installed
echo -e "${BLUE}📦 Installing required VSCode extensions...${NC}"

# Install Dev Containers extension
code --install-extension ms-vscode-remote.remote-containers

# Install recommended extensions for C development
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension daltonmenezes.42-header
code --install-extension evilcat.norminette-42

echo -e "${GREEN}✅ VSCode extensions installed successfully!${NC}"

# Create or update .env file with VSCode-specific settings
if [ ! -f .env ]; then
    echo -e "${YELLOW}📝 Creating .env file...${NC}"
    cp .env.example .env
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker is running.${NC}"

# Build the container if not already built
if [ ! -f .docker-built ]; then
    echo -e "${BLUE}🔨 Building Docker container for the first time...${NC}"
    docker-compose build
    touch .docker-built
    echo -e "${GREEN}✅ Container built successfully!${NC}"
else
    echo -e "${GREEN}✅ Container already built.${NC}"
fi

echo ""
echo -e "${PURPLE}🚀 VSCode Dev Container setup complete!${NC}"
echo ""
echo -e "${GREEN}To start developing:${NC}"
echo -e "${BLUE}1. Open VSCode: ${NC}code ."
echo -e "${BLUE}2. Click 'Reopen in Container' when prompted${NC}"
echo -e "${BLUE}3. Or use Ctrl+Shift+P -> 'Dev Containers: Open Folder in Container'${NC}"
echo ""
echo -e "${GREEN}Features available in VSCode:${NC}"
echo -e "${BLUE}• 🎯 Full IntelliSense for C/C++${NC}"
echo -e "${BLUE}• 🐛 Integrated debugging with GDB${NC}"
echo -e "${BLUE}• 📝 42 Header insertion (F1)${NC}"
echo -e "${BLUE}• ✅ Norminette checking in real-time${NC}"
echo -e "${BLUE}• 🔨 Build tasks (Ctrl+Shift+P -> Tasks)${NC}"
echo -e "${BLUE}• 🧪 Valgrind integration${NC}"
echo ""
echo -e "${YELLOW}💡 Tip: All your files are automatically synced between host and container!${NC}"
