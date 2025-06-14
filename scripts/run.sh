#!/bin/bash

echo "🚀 Starting 42 School development environment..."

# Check if the image exists
if [[ "$(docker images -q 42-docker-enviroment_dev 2> /dev/null)" == "" ]]; then
    echo "❌ Docker image not found. Run ./scripts/build.sh first"
    exit 1
fi

# Check if there are changes in Dockerfile or docker-compose.yml
if [ Dockerfile -nt .docker-built ] || [ docker-compose.yml -nt .docker-built ]; then
    echo "🔄 Changes detected, rebuilding environment..."
    ./scripts/build.sh
fi

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo "🐳 Launching Ubuntu 22.04 environment (42 Madrid compatible)..."
echo "📁 Your files are mounted at: /home/student/workspace"
echo "🛠️  Available tools: gcc, gdb, valgrind, norminette, 42header"
echo ""
echo "💡 Useful commands inside:"
echo "   norm *.c           - Check norminette on C files"
echo "   gcc42 -o prog file.c - Compile with 42 flags"
echo "   gdb ./prog         - Debug with GDB"
echo "   valgrind-full ./prog - Memory check with Valgrind"
echo "   42header           - Open vim with header (F1 to insert)"
echo ""
echo "🚪 Type 'exit' to leave the environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Run the development container
docker-compose run --rm dev

echo ""
echo "👋 Exited 42 development environment"
