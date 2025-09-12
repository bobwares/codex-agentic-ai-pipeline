#!/bin/bash
# iac-files.sh - Version 2.6
# Gathers all *.tf, *.sh, and Docker-related files from project root (..), excluding common build/env dirs and boilerplate tf files.
# Outputs file paths relative to project root, prefixed with './'

set -e

# Move to the script's directory (assumes script is in project-root/ai)
cd "$(dirname "$0")" || exit 1

# Define paths
OUTPUT_DIR="./output"
OUTPUT_FILE="$OUTPUT_DIR/iac-report.md"
ROOT_DIR=".."

# Create output directory if missing
mkdir -p "$OUTPUT_DIR"

echo "# Infrastructure-as-Code (IaC) Report" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# List of directories to exclude
EXCLUDE_DIRS=(
  "$ROOT_DIR/.git"
  "$ROOT_DIR/.venv"
  "$ROOT_DIR/__pycache__"
  "$ROOT_DIR/node_modules"
  "$ROOT_DIR/.mypy_cache"
  "$ROOT_DIR/.pytest_cache"
  "$ROOT_DIR/dist"
  "$ROOT_DIR/build"
  "$ROOT_DIR/output"
  "$ROOT_DIR/ai"
  "$ROOT_DIR/.tox"
  "$ROOT_DIR/.idea"
  "$ROOT_DIR/.github"
  "$ROOT_DIR/iac/.terraform"
)

# Build prune expression
PRUNE_EXPR=()
for dir in "${EXCLUDE_DIRS[@]}"; do
    PRUNE_EXPR+=( -path "$dir" -prune -o )
done

# Find matching files, applying directory exclusion and Terraform file filters
find "$ROOT_DIR" "${PRUNE_EXPR[@]}" -type f \( \
    -iname "*.tf" -o -iname "*.sh" -o -iname "Dockerfile" -o -iname "docker-compose*.yml" \
  \) ! -name "main.tf" ! -name "outputs.tf" ! -name "variables.tf" -print | sort | while IFS= read -r file; do

    RELATIVE_PATH="./${file#../}"

    echo "Processing: $RELATIVE_PATH"
    echo "## File: $RELATIVE_PATH" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    case "$file" in
        *.tf)                         LANG="hcl" ;;
        *.sh)                         LANG="bash" ;;
        *[Dd]ockerfile)               LANG="docker" ;;
        *docker-compose*.yml|*.yaml) LANG="yaml" ;;
        *)                            LANG="" ;;
    esac

    echo "\`\`\`$LANG" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo "\`\`\`" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "Compilation complete. Markdown file written to: $OUTPUT_FILE"
