#!/bin/bash

# Function to create README.md
create_readme() {
    local dir=$1
    local name=$(basename "$dir")
    
    echo "# ${name^}" > "$dir/README.md"
    echo -e "\nThis directory contains ${name} related configurations and resources.\n" >> "$dir/README.md"
    echo "## Contents" >> "$dir/README.md"
    
    # Add directory-specific content
    case $name in
        "modules")
            echo -e "- Terraform modules for infrastructure components\n" >> "$dir/README.md"
            ;;
        "environments")
            echo -e "- Environment-specific Terraform configurations\n" >> "$dir/README.md"
            ;;
        "templates")
            echo -e "- Configuration templates for various components\n" >> "$dir/README.md"
            ;;
        *)
            echo -e "- Configuration files and resources\n" >> "$dir/README.md"
            ;;
    esac
}

# Find directories without README.md and create them
find . -type d -not -path '*/\.*' | while read -r dir; do
    if [ ! -f "$dir/README.md" ]; then
        create_readme "$dir"
        echo "Created README.md in: $dir"
    fi
done
