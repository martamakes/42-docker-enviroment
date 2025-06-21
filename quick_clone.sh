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
