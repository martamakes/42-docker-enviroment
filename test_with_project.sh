#!/bin/bash

# Script para probar el entorno Docker con un proyecto existente
# Usage: ./test_with_project.sh <project_path>

set -e

PROJECT_PATH="$1"

if [ -z "$PROJECT_PATH" ]; then
    echo "❌ Usage: $0 <project_path>"
    echo "   Example: $0 ../philosophers"
    exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Project directory not found: $PROJECT_PATH"
    exit 1
fi

echo "🧪 Testing 42 Docker Environment with existing project"
echo "======================================================="
echo "📁 Project: $PROJECT_PATH"
echo ""

# Get absolute path
PROJECT_ABS_PATH=$(cd "$PROJECT_PATH" && pwd)
PROJECT_NAME=$(basename "$PROJECT_ABS_PATH")

echo "🔍 Project details:"
echo "   Name: $PROJECT_NAME"
echo "   Path: $PROJECT_ABS_PATH"
echo ""

# Check if Docker environment is built
if [[ "$(docker images -q 42-docker-enviroment_dev 2> /dev/null)" == "" ]]; then
    echo "🔨 Docker environment not found, building first..."
    ./scripts/build.sh
fi

echo "📋 What we'll test:"
echo "1. Mount your project inside the container"
echo "2. Check if it compiles with 42 flags"
echo "3. Run norminette on your code"
echo "4. Test with Valgrind if executable exists"
echo ""

read -p "🚀 Ready to test? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Test cancelled"
    exit 0
fi

echo ""
echo "🐳 Starting Docker container with your project..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create a temporary docker-compose override for the project
cat > docker-compose.test.yml << EOF
version: '3.8'

services:
  dev:
    extends:
      file: docker-compose.yml
      service: dev
    volumes:
      - $PROJECT_ABS_PATH:/home/student/project
      - .:/home/student/workspace
    working_dir: /home/student/project
    container_name: 42-test-project
EOF

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Run the test
docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm dev bash -c "
echo '🎯 Testing project: $PROJECT_NAME'
echo '📁 Working directory: \$(pwd)'
echo '📋 Files in project:'
ls -la
echo ''

echo '1️⃣ Checking for Makefile...'
if [ -f Makefile ]; then
    echo '✅ Makefile found'
    echo ''
    
    echo '2️⃣ Attempting to compile...'
    if make; then
        echo '✅ Compilation successful!'
        
        # Check for executable
        if [ -f philo ]; then
            EXECUTABLE='philo'
        elif [ -f philosophers ]; then
            EXECUTABLE='philosophers'
        elif [ -f \$PROJECT_NAME ]; then
            EXECUTABLE=\$PROJECT_NAME
        else
            EXECUTABLE=''
        fi
        
        if [ -n \"\$EXECUTABLE\" ]; then
            echo \"✅ Executable found: \$EXECUTABLE\"
            echo ''
            
            echo '3️⃣ Testing execution with sample arguments...'
            echo 'Running: ./\$EXECUTABLE 4 800 200 200'
            timeout 10s ./\$EXECUTABLE 4 800 200 200 || echo '⏰ Test stopped after 10 seconds (normal for philosophers)'
            echo ''
            
            echo '4️⃣ Testing with Valgrind...'
            echo 'Running: valgrind --tool=helgrind ./\$EXECUTABLE 4 800 200 200'
            timeout 15s valgrind --tool=helgrind ./\$EXECUTABLE 4 800 200 200 || echo '⏰ Valgrind test stopped after 15 seconds'
        else
            echo '⚠️  No recognizable executable found'
        fi
    else
        echo '❌ Compilation failed'
        echo 'This might be normal if the project has specific requirements'
    fi
else
    echo '⚠️  No Makefile found'
fi

echo ''
echo '5️⃣ Running norminette on C files...'
if ls *.c >/dev/null 2>&1; then
    norminette *.c *.h 2>/dev/null || norminette *.c 2>/dev/null || echo 'No C files to check'
else
    echo 'No C files found in root directory'
    # Check subdirectories
    if find . -name '*.c' -type f | head -5; then
        echo 'Found C files in subdirectories, checking those...'
        find . -name '*.c' -type f -exec norminette {} \;
    fi
fi

echo ''
echo '6️⃣ Environment verification...'
echo \"GCC version: \$(gcc --version | head -1)\"
echo \"GDB version: \$(gdb --version | head -1)\"
echo \"Valgrind version: \$(valgrind --version)\"
echo \"Norminette version: \$(norminette --version)\"

echo ''
echo '🎉 Project test completed!'
echo 'You can now work on your project using:'
echo '  ./scripts/run.sh'
echo 'Then navigate to /home/student/project inside the container'
"

# Cleanup
rm -f docker-compose.test.yml

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Test completed!"
echo ""
echo "🚀 To continue working on your project:"
echo "   1. Run: ./scripts/run.sh"
echo "   2. Inside container: cd /home/student/project"
echo "   3. Or permanently mount it by editing docker-compose.yml"
echo ""
echo "💡 To permanently mount your project, add this to docker-compose.yml volumes:"
echo "   - $PROJECT_ABS_PATH:/home/student/project"
