#!/bin/bash

# 42 School Docker Environment - Complete Installation Script with Git Setup
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
    read -p "Enter your 42 login (e.g., mvigara-): " USER42
    if [[ -n "$USER42" && "$USER42" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        break
    else
        print_error "Invalid login format. Please use letters, numbers, underscores, and hyphens, starting with a letter."
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

# Step 3: Git configuration
echo ""
echo "⚙️ Git Configuration"
echo "-------------------"

# Get GitHub username
read -p "Enter your GitHub username (for cloning repos): " GITHUB_USER

# Git name (default to 42 login)
read -p "Enter your Git name [default: $USER42]: " GIT_NAME
GIT_NAME=${GIT_NAME:-$USER42}

# Git email (default to 42 email)
read -p "Enter your Git email [default: $MAIL42]: " GIT_EMAIL
GIT_EMAIL=${GIT_EMAIL:-$MAIL42}

# SSH Key generation option
echo ""
echo "🔑 SSH Key Setup:"
echo "1) Generate new SSH key (recommended for frequent use)"
echo "2) I'll use HTTPS with Personal Access Token"
echo "3) I'll configure SSH manually later"

while true; do
    read -p "Choose option (1-3): " ssh_choice
    case $ssh_choice in
        1)
            SETUP_SSH="true"
            break
            ;;
        2|3)
            SETUP_SSH="false"
            break
            ;;
        *)
            print_error "Invalid option. Please choose 1-3."
            ;;
    esac
done

# Step 4: Create .env file
echo ""
print_info "Creating configuration file..."

cat > .env << EOF
# 42 School Configuration
USER42=$USER42
MAIL42=$MAIL42

# Git Configuration
GITHUB_USER=$GITHUB_USER
GIT_NAME=$GIT_NAME
GIT_EMAIL=$GIT_EMAIL
SETUP_SSH=$SETUP_SSH

# Generated on $(date)
EOF

print_status "Configuration saved to .env"
echo "  42 User: $USER42"
echo "  42 Email: $MAIL42"
echo "  GitHub: $GITHUB_USER"
echo "  Git Name: $GIT_NAME"
echo "  Git Email: $GIT_EMAIL"
echo "  SSH Setup: $SETUP_SSH"

# Step 5: Build the environment
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

# Step 6: Setup Git inside container
echo ""
echo "⚙️ Configuring Git inside container..."

if docker-compose run --rm dev bash -c "
    # Configure git
    git config --global user.name '$GIT_NAME'
    git config --global user.email '$GIT_EMAIL'
    
    # Setup SSH if requested
    if [ '$SETUP_SSH' = 'true' ]; then
        echo '🔑 Generating SSH key...'
        ssh-keygen -t ed25519 -C '$GIT_EMAIL' -f ~/.ssh/id_ed25519 -N ''
        
        echo ''
        echo '📋 Your SSH public key (copy this to GitHub):'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        cat ~/.ssh/id_ed25519.pub
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo ''
        echo 'To add this key to GitHub:'
        echo '1. Go to: https://github.com/settings/ssh/new'
        echo '2. Title: \"42 Docker Environment\"'
        echo '3. Paste the key above'
        echo '4. Click \"Add SSH key\"'
        echo ''
        
        # Save SSH key to host for persistence
        if [ ! -d /home/student/workspace/.ssh-backup ]; then
            mkdir -p /home/student/workspace/.ssh-backup
            cp ~/.ssh/id_ed25519* /home/student/workspace/.ssh-backup/
            echo '💾 SSH keys backed up to .ssh-backup/'
        fi
    else
        echo '🔗 HTTPS setup completed. You'\''ll need a Personal Access Token:'
        echo '1. Go to: https://github.com/settings/tokens'
        echo '2. Generate new token (classic)'
        echo '3. Select \"repo\" scope'
        echo '4. Use token as password when cloning'
    fi
    
    echo ''
    echo '✅ Git configuration completed!'
    git config --list | grep -E '(user.name|user.email)'
"; then
    print_status "Git configured successfully inside container"
else
    print_warning "Git configuration had some issues, but you can configure it manually later"
fi

# Step 7: Run tests
echo ""
echo "🧪 Running environment tests..."

if ./scripts/test.sh; then
    print_status "All tests passed"
else
    print_warning "Some tests failed, but environment may still be usable"
fi

# Step 8: Create helpful scripts
echo ""
print_info "Creating helpful scripts..."

# Create quick clone script
cat > quick_clone.sh << 'EOF'
#!/bin/bash
# Quick clone script for your projects

if [ -z "$1" ]; then
    echo "Usage: $0 <repository-name>"
    echo "Example: $0 philosophers"
    exit 1
fi

REPO_NAME="$1"

# Load configuration
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo "🔄 Cloning $REPO_NAME from $GITHUB_USER..."

# Run container and clone
docker-compose run --rm dev bash -c "
    if [ '$SETUP_SSH' = 'true' ]; then
        # Restore SSH keys if they exist
        if [ -d /home/student/workspace/.ssh-backup ]; then
            cp /home/student/workspace/.ssh-backup/* ~/.ssh/
            chmod 600 ~/.ssh/id_ed25519
            chmod 644 ~/.ssh/id_ed25519.pub
        fi
        git clone git@github.com:$GITHUB_USER/$REPO_NAME.git
    else
        git clone https://github.com/$GITHUB_USER/$REPO_NAME.git
    fi
    
    if [ -d $REPO_NAME ]; then
        echo '✅ Successfully cloned $REPO_NAME'
        echo '🚀 To start working:'
        echo '  ./scripts/run.sh'
        echo '  cd $REPO_NAME'
    else
        echo '❌ Failed to clone repository'
        echo 'Check your repository name and GitHub access'
    fi
"
EOF

chmod +x quick_clone.sh

print_status "Created quick_clone.sh script"

# Step 9: Final instructions
echo ""
echo "🎉 Installation Complete!"
echo "========================="
echo ""
echo "Your 42 School development environment is ready!"
echo ""
echo "📖 Quick Start Commands:"
echo "  ./scripts/run.sh          - Start development environment"
echo "  ./quick_clone.sh <repo>   - Quick clone your GitHub repos"
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
echo "🔄 To clone your existing projects:"
echo "  ./quick_clone.sh philosophers"
echo "  ./quick_clone.sh libft"
echo "  ./quick_clone.sh ft_printf"
echo ""
echo "💻 VS Code Integration:"
echo "  1. Install 'Remote - Containers' extension"
echo "  2. Open this folder in VS Code: code ."
echo "  3. Click 'Reopen in Container' when prompted"
echo ""

if [ "$SETUP_SSH" = "true" ]; then
    echo "🔑 SSH Key Generated!"
    echo "  Don't forget to add your SSH key to GitHub:"
    echo "  https://github.com/settings/ssh/new"
    echo ""
fi

echo "🔗 Useful Links:"
echo "  • Documentation: README.md"
echo "  • 42 Intranet: https://intra.42.fr"
echo "  • GitHub: https://github.com/$GITHUB_USER"
echo ""
print_status "Ready to code! Run ./scripts/run.sh to start"
