#!/bin/bash
# Quick clone script for your 42 projects

if [ -z "$1" ]; then
    echo "❌ Usage: $0 <repository-name>"
    echo "📖 Examples:"
    echo "   $0 philosophers"
    echo "   $0 libft"
    echo "   $0 ft_printf"
    echo ""
    echo "🔍 Available repositories:"
    if [ -f .env ] && grep -q GITHUB_USER .env; then
        GITHUB_USER=$(grep GITHUB_USER .env | cut -d'=' -f2)
        echo "   Check your repos at: https://github.com/$GITHUB_USER"
    fi
    exit 1
fi

REPO_NAME="$1"

# Check if Docker environment exists
if [[ "$(docker images -q 42-docker-enviroment-dev 2> /dev/null)" == "" ]]; then
    echo "❌ Docker environment not found. Run ./scripts/build.sh first"
    exit 1
fi

# Load configuration
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "❌ Configuration file .env not found. Run ./scripts/install.sh first"
    exit 1
fi

echo "🔄 Cloning $REPO_NAME from GitHub user: $GITHUB_USER"
echo ""

# Run container and clone
docker-compose run --rm dev bash -c "
    # Restore SSH keys if they exist
    if [ '$SETUP_SSH' = 'true' ] && [ -d /home/student/workspace/.ssh-backup ]; then
        echo '🔑 Restoring SSH keys...'
        mkdir -p ~/.ssh
        cp /home/student/workspace/.ssh-backup/* ~/.ssh/ 2>/dev/null || true
        chmod 600 ~/.ssh/id_ed25519 2>/dev/null || true
        chmod 644 ~/.ssh/id_ed25519.pub 2>/dev/null || true
        
        # Test SSH connection
        ssh -T git@github.com -o StrictHostKeyChecking=no 2>&1 | grep -q 'successfully authenticated' && echo '✅ SSH connection working'
    fi
    
    echo '📥 Cloning repository...'
    if [ '$SETUP_SSH' = 'true' ]; then
        git clone git@github.com:$GITHUB_USER/$REPO_NAME.git
    else
        echo '🔗 Using HTTPS - you may need to enter your GitHub credentials'
        git clone https://github.com/$GITHUB_USER/$REPO_NAME.git
    fi
    
    if [ -d $REPO_NAME ]; then
        echo ''
        echo '✅ Successfully cloned $REPO_NAME!'
        echo ''
        cd $REPO_NAME
        
        # Show repository info
        echo '📊 Repository Information:'
        echo \"  📁 Files: \$(ls -1 | wc -l) items\"
        if [ -f README.md ]; then
            echo '  📄 README.md found'
        fi
        if [ -f Makefile ]; then
            echo '  🔨 Makefile found'
        fi
        if ls *.c >/dev/null 2>&1; then
            echo \"  📝 C files: \$(ls -1 *.c | wc -l)\"
        fi
        if ls *.h >/dev/null 2>&1; then
            echo \"  📋 Header files: \$(ls -1 *.h | wc -l)\"
        fi
        
        echo ''
        echo '🚀 Next steps:'
        echo '  1. Start development environment: ./scripts/run.sh'
        echo '  2. Navigate to your project: cd $REPO_NAME'
        echo '  3. Compile: make'
        echo '  4. Check norminette: norm *.c'
        echo '  5. Debug if needed: gdb ./program'
        echo ''
    else
        echo ''
        echo '❌ Failed to clone repository $REPO_NAME'
        echo ''
        echo '🔍 Possible issues:'
        echo '  • Repository name is incorrect'
        echo '  • Repository is private and you lack access'
        echo '  • GitHub username is wrong'
        echo '  • Network/authentication issues'
        echo ''
        echo '🔧 Troubleshooting:'
        echo '  • Check repository exists: https://github.com/$GITHUB_USER/$REPO_NAME'
        echo '  • Verify GitHub username in .env file'
        if [ '$SETUP_SSH' = 'true' ]; then
            echo '  • Ensure SSH key is added to GitHub'
        else
            echo '  • Ensure you have a valid Personal Access Token'
        fi
        exit 1
    fi
"

echo ""
echo "📂 Repository cloned to your workspace!"
echo "🎯 Ready to start coding with 42 tools!"
