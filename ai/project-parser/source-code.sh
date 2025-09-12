#!/bin/bash
# source-code.sh - Version 2.4
# Outputs project source files to ./output/source-code.md, excluding common build, env, and cache dirs.

set -e

OUTPUT_DIR="./output"
SOURCE_OUTPUT_FILE="$OUTPUT_DIR/source-code.md"
ROOT_DIR=".."

mkdir -p "$OUTPUT_DIR"

echo "# Source Code" > "$SOURCE_OUTPUT_FILE"
echo "" >> "$SOURCE_OUTPUT_FILE"

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
  "**/.pytest_cache"

)

# Build prune expression
PRUNE_EXPR=""
for dir in "${EXCLUDE_DIRS[@]}"; do
    PRUNE_EXPR="$PRUNE_EXPR -path \"$dir\" -prune -o"
done

# Use eval to apply prune rules
eval "find \"$ROOT_DIR\" $PRUNE_EXPR -type f \( \
    -iname \"*.ts\" -o -iname \"*.tsx\" -o -iname \"*.js\" -o -iname \"*.py\" -o -iname \"*.java\" \
  \) ! -iname \"*test.java\" -print" | sort | while read -r file; do

    RELATIVE_PATH="./${file#../}"
    EXT="${file##*.}"

    case "$EXT" in
      py)     LANG="python" ;;
      js)     LANG="javascript" ;;
      ts|tsx) LANG="typescript" ;;
      java)   LANG="java" ;;
      *)      LANG="text" ;;
    esac

    echo "Processing: $RELATIVE_PATH"
    echo "## File: $RELATIVE_PATH" >> "$SOURCE_OUTPUT_FILE"
    echo "\`\`\`$LANG" >> "$SOURCE_OUTPUT_FILE"
    cat "$file" >> "$SOURCE_OUTPUT_FILE"
    echo "\`\`\`" >> "$SOURCE_OUTPUT_FILE"
    echo "" >> "$SOURCE_OUTPUT_FILE"
done
