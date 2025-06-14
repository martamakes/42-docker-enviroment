#!/bin/bash

echo "🧹 Cleaning Docker cache and rebuilding environment..."

# Stop any running containers
docker-compose down 2>/dev/null || true

# Remove any existing images
docker rmi 42-docker-enviroment_dev 2>/dev/null || true
docker rmi 42-docker-enviroment_test 2>/dev/null || true

# Clean Docker cache
docker system prune -f

echo "✅ Cache cleaned, rebuilding..."

# Rebuild without cache
docker-compose build --no-cache

echo "🎉 Rebuild complete!"
