#!/bin/bash

# 42 School Docker Environment - Complete Installation Script
set -e

echo "🎯 42 School Docker Environment Installer"
echo "=========================================="
echo ""

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

# Check if running on macOS, Linux, or Windows
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

print_info "Detected OS: $MACHINE"

# Step 1: Check Docker installation
echo ""
echo "🔍 Checking Docker installation..."

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed"
    echo ""
    echo "Please install Docker first:"
    case $MACHINE in
        Mac)
            echo "  • Download Docker Desktop from: https://www.docker.com/products/docker-desktop"
            echo "  • Or use Homebrew: brew install --cask docker"
            ;;
        Linux)
            echo "  • Run: curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh"
            echo "  • Add user to docker group: sudo usermod -aG docker \$USER"
            echo "  • Log out and back in for group changes to take effect"
            ;;
        *)
            echo "  • Download Docker Desktop from: https://www.docker.com/products/docker-desktop"
            ;;
    esac
    exit 1
else
    print_status "Docker is installed"
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running"
    case $MACHINE in
        Mac|Cygwin|MinGw)
            echo "Please start Docker Desktop application"
            ;;
        Linux)
            echo "Please start Docker service: sudo systemctl start docker"
            ;;
    esac
    exit 1
else
    print_status "Docker is running"
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_warning "docker-compose not found, checking for docker compose plugin..."
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not available"
        echo "Please install Docker Compose"
        exit 1
    else
        print_status "Docker Compose plugin is available"
        # Create alias for docker-compose
        alias docker-compose='docker compose'
    fi
else
    print_status "Docker Compose is installed"
fi

# Step 2: Campus and user configuration
echo ""
echo "👤 42 School Configuration"
echo "------------------------"

# Get user login
while true; do
    read -p "Enter your 42 login (e.g., mgarcia): " USER42
    if [[ -n "$USER42" && "$USER42" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; then
        break
    else
        print_error "Invalid login format. Please use only letters and numbers, starting with a letter."
    fi
done

# Campus selection
echo ""
echo "Select your 42 campus:"
echo "1) Madrid (student.42madrid.com)"
echo "2) Barcelona (student.42barcelona.com)" 
echo "3) France (student.42.fr)"
echo "4) Other (manual entry)"

while true; do
    read -p "Choose option (1-4): " campus_choice
    case $campus_choice in
        1)
            MAIL42="$USER42@student.42madrid.com"
            break
            ;;
        2)
            MAIL42="$USER42@student.42barcelona.com"
            break
            ;;
        3)
            MAIL42="$USER42@student.42.fr"
            break
            ;;
        4)
            read -p "Enter your full 42 email: " MAIL42
            break
            ;;
        *)
            print_error "Invalid option. Please choose 1-4."
            ;;
    esac
done

# Step 3: Create .env file
echo ""
print_info "Creating configuration file..."

cat > .env << EOF
# 42 School Configuration
USER42=$USER42
MAIL42=$MAIL42

# Generated on $(date)
EOF

print_status "Configuration saved to .env"
echo "  User: $USER42"
echo "  Email: $MAIL42"

# Step 4: Build the environment
echo ""
echo "🔨 Building 42 development environment..."
echo "This may take a few minutes on first run..."

chmod +x scripts/*.sh

if ./scripts/build.sh; then
    print_status "Environment built successfully"
else
    print_error "Failed to build environment"
    exit 1
fi

# Step 5: Run tests
echo ""
echo "🧪 Running environment tests..."

if ./scripts/test.sh; then
    print_status "All tests passed"
else
    print_warning "Some tests failed, but environment may still be usable"
fi

# Step 6: Final instructions
echo ""
echo "🎉 Installation Complete!"
echo "========================="
echo ""
echo "Your 42 School development environment is ready!"
echo ""
echo "📖 Quick Start Commands:"
echo "  ./scripts/run.sh          - Start development environment"
echo "  ./scripts/test.sh         - Run environment tests"
echo "  ./scripts/build.sh        - Rebuild environment (if needed)"
echo ""
echo "🐳 Inside the Container:"
echo "  norm *.c                  - Check norminette on files"
echo "  gcc42 -o prog file.c      - Compile with 42 flags"
echo "  gdb ./prog                - Debug with GDB"
echo "  valgrind-full ./prog      - Memory check"
echo "  42header                  - Open vim with header (F1 to insert)"
echo ""
echo "💻 VS Code Integration:"
echo "  1. Install 'Remote - Containers' extension"
echo "  2. Open this folder in VS Code: code ."
echo "  3. Click 'Reopen in Container' when prompted"
echo ""
echo "🔗 Useful Links:"
echo "  • Documentation: README.md"
echo "  • 42 Intranet: https://intra.42.fr"
echo "  • Norminette Guide: Check README.md"
echo ""
print_status "Ready to code! Run ./scripts/run.sh to start"
