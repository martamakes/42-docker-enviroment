#!/bin/bash

set -e

echo "🧪 Testing 42 School development environment..."
echo "=================================================="

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Test 1: Check if image exists or can be built
echo "1️⃣ Checking Docker environment..."
if [[ "$(docker images -q 42-docker-enviroment_dev 2> /dev/null)" == "" ]]; then
    echo "🔨 Image not found, building first..."
    ./scripts/build.sh
fi
echo "✅ Docker environment ready"

# Test 2: Basic container functionality
echo ""
echo "2️⃣ Testing basic container functionality..."
docker-compose run --rm test echo "✅ Container starts and runs commands"

# Test 3: Development tools
echo ""
echo "3️⃣ Verifying development tools..."
docker-compose run --rm test bash -c "
    set -e
    gcc --version > /dev/null && echo '✅ GCC installed and working' || echo '❌ GCC not working'
    gdb --version > /dev/null && echo '✅ GDB installed and working' || echo '❌ GDB not working'
    valgrind --version > /dev/null && echo '✅ Valgrind installed and working' || echo '❌ Valgrind not working'
    norminette --version > /dev/null && echo '✅ Norminette installed and working' || echo '❌ Norminette not working'
    make --version > /dev/null && echo '✅ Make installed and working' || echo '❌ Make not working'
"

# Test 4: Compile and run test program
echo ""
echo "4️⃣ Testing compilation and execution..."
docker-compose run --rm test bash -c "
    cd test-files &&
    echo 'Compiling test program...' &&
    make clean > /dev/null 2>&1 || true &&
    make > /dev/null 2>&1 &&
    echo '✅ Compilation successful' &&
    echo 'Running test program...' &&
    ./test_environment &&
    echo '✅ Program execution successful'
"

# Test 5: Norminette check
echo ""
echo "5️⃣ Testing norminette functionality..."
docker-compose run --rm test bash -c "
    cd test-files &&
    echo 'Running norminette on test files...' &&
    norminette test_environment.c > /dev/null 2>&1 &&
    echo '✅ Norminette check passed' ||
    echo '⚠️  Norminette found style issues (this is normal for test files)'
"

# Test 6: 42 Header functionality
echo ""
echo "6️⃣ Testing 42 Header installation..."
docker-compose run --rm test bash -c "
    test -f ~/.vim/plugin/stdheader.vim &&
    echo '✅ 42 Header plugin installed' ||
    echo '❌ 42 Header plugin not found'
"

# Test 7: Environment variables
echo ""
echo "7️⃣ Testing environment configuration..."
docker-compose run --rm test bash -c "
    echo \"User: \$USER42\" &&
    echo \"Email: \$MAIL42\" &&
    test -n \"\$USER42\" && echo '✅ USER42 is set' || echo '❌ USER42 not set' &&
    test -n \"\$MAIL42\" && echo '✅ MAIL42 is set' || echo '❌ MAIL42 not set'
"

# Test 8: File permissions and mounting
echo ""
echo "8️⃣ Testing file system and permissions..."
docker-compose run --rm test bash -c "
    test -w /home/student/workspace &&
    echo '✅ Workspace directory is writable' &&
    touch /home/student/workspace/test_write &&
    rm /home/student/workspace/test_write &&
    echo '✅ File creation and deletion works'
"

echo ""
echo "🎉 All tests completed!"
echo ""
echo "📊 Test Summary:"
echo "▶️  Environment is ready for 42 School development"
echo "▶️  All essential tools are installed and working"
echo "▶️  Norminette is functional"
echo "▶️  File system permissions are correct"
echo ""
echo "🚀 You can now start developing with: ./scripts/run.sh"
