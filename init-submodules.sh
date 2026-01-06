#!/bin/bash
set -e

echo "🔧 Initializing PusjWorkspace submodules..."

# Check if .gitmodules exists
if [ ! -f .gitmodules ]; then
    echo "❌ Error: .gitmodules not found!"
    echo "Please copy .gitmodules.example to .gitmodules and update URLs"
    exit 1
fi

# Initialize and update submodules
echo "📦 Cloning submodules..."
git submodule update --init --recursive

echo "✅ Submodules initialized successfully!"
echo ""
echo "Submodules:"
echo "  - PusjCore: $(git config --file .gitmodules --get submodule.PusjCore.url)"
echo "  - PusjNext: $(git config --file .gitmodules --get submodule.PusjNext.url)"
echo "  - MasterDocs: $(git config --file .gitmodules --get submodule.MasterDocs.url)"

