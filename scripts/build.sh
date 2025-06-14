#!/bin/bash

set -e

echo "🐳 Building 42 School development environment..."

# Check if .env file exists, if not create from example
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your 42 credentials before continuing"
    echo "   Edit USER42 and MAIL42 with your 42 login and campus email"
    read -p "Press Enter after editing .env file..."
fi

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Set defaults if not provided
USER42=${USER42:-student}
MAIL42=${MAIL42:-student@student.42madrid.com}

echo "👤 Building for user: $USER42"
echo "📧 Email: $MAIL42"

# Build the Docker image
docker-compose build --build-arg USER42="$USER42" --build-arg MAIL42="$MAIL42"

if [ $? -eq 0 ]; then
    echo "✅ Environment built successfully!"
    echo "💡 Configuration:"
    echo "   User: $USER42"
    echo "   Email: $MAIL42"
    echo ""
    echo "🚀 Ready to use! Run: ./scripts/run.sh"
    
    # Create marker file to track build time
    touch .docker-built
else
    echo "❌ Error building the environment"
    exit 1
fi
