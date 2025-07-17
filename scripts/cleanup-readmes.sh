#!/bin/bash

# Don't remove main README.md
find . -type f -name "README.md" ! -path "./README.md" -exec rm {} \;
echo "Removed auto-generated README.md files from subdirectories"

# Keep only the essential README files
KEEP_READMES=(
    "./docs/README.md"
    "./infrastructure/README.md"
    "./infrastructure/security/README.md"
    "./scripts/README.md"
    "./terraform/README.md"
    "./monitoring/README.md"
)

# Restore essential READMEs
for readme in "${KEEP_READMES[@]}"; do
    if [ ! -f "$readme" ]; then
        git checkout "$readme" 2>/dev/null || echo "Warning: Could not restore $readme"
    fi
done
