#!/bin/bash
set -e

echo "🚀 Post-create script for PusjWorkspace..."

# Check if submodules are initialized
if [ ! -f .gitmodules ]; then
    echo "📋 Copying .gitmodules.example to .gitmodules"
    cp .gitmodules.example .gitmodules
fi

# Initialize submodules if not already done
if [ ! -d "PusjCore" ] || [ ! -d "PusjNext" ] || [ ! -d "MasterDocs" ]; then
    echo "📦 Initializing git submodules..."
    bash init-submodules.sh
fi

# Create .env if it doesn't exist
if [ ! -f .env ] && [ -f .env.example ]; then
    echo "📝 Creating .env from .env.example"
    cp .env.example .env
fi

# Make sure scripts are executable
chmod +x init-submodules.sh
chmod +x .devcontainer/post-create.sh

echo "✅ Post-create setup complete!"
echo ""
echo "To start services, run: make up"
echo "Or use: docker-compose -f docker-compose.dev.yml up -d"

