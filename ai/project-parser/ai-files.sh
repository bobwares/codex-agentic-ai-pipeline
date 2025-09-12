#!/usr/bin/env bash
# ai-append.sh - Version 1.4
# Concatenate AI workspace files into ./ai/project-parser/output/ai-files.md

set -euo pipefail

# Directories relative to ./ai/project-parser
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
AI_DIR="$BASE_DIR/.."
PROJECT_ROOT="$(cd "$AI_DIR/.." && pwd -P)"
OUTPUT_DIR="$BASE_DIR/output"
OUTPUT_FILE="$OUTPUT_DIR/ai-files.md"

echo "BASE_DIR=$BASE_DIR"
echo "AI_DIR=$AI_DIR"
echo "PROJECT_ROOT=$PROJECT_ROOT"
echo "OUTPUT_DIR=$OUTPUT_DIR"
echo "OUTPUT_FILE=$OUTPUT_FILE"

mkdir -p "$OUTPUT_DIR"

{
  echo "# AI Workspace Files"
  echo
  echo "_Generated on: $(date -u +"%Y-%m-%dT%H:%M:%SZ")_"
  echo
} > "$OUTPUT_FILE"

EXCLUDE_DIRS=(
  "$AI_DIR/.git"
  "$AI_DIR/.idea"
  "$AI_DIR/node_modules"
  "$AI_DIR/dist"
  "$AI_DIR/build"
  "$AI_DIR/output"
  "$AI_DIR/.cache"
  "$AI_DIR/__pycache__"
  "$AI_DIR/.mypy_cache"
  "$AI_DIR/.pytest_cache"
  "$AI_DIR/.venv"
  "$AI_DIR/project-parser"
  "$AI_DIR/vibe"
)

INCLUDE_GLOBS=(
  "*.md" "*.mdx"
  "*.prompt" "*.prompt.md"
  "*.yaml" "*.yml"
  "*.json" "*.jsonc"
  "*.csv" "*.tsv"
  "*.txt"
  "*.http"
  "*.sh"
  "*.py"
)

BINARY_GLOBS=(
  "*.png" "*.jpg" "*.jpeg" "*.gif" "*.webp"
  "*.pdf" "*.zip" "*.tar" "*.tar.gz" "*.tgz" "*.rar"
  "*.woff" "*.woff2" "*.ttf"
)

lang_for() {
  local f="$1"
  local base
  base="$(basename "$f")"
  local ext="${base##*.}"
  if [[ "$base" == *.prompt.md ]]; then echo "markdown"; return; fi
  case "$ext" in
    md|mdx)     echo "markdown" ;;
    yaml|yml)   echo "yaml" ;;
    json|jsonc) echo "json" ;;
    csv|tsv)    echo "csv" ;;
    txt)        echo "text" ;;
    http)       echo "http" ;;
    sh)         echo "bash" ;;
    py)         echo "python" ;;
    prompt)     echo "text" ;;
    *)          echo "text" ;;
  esac
}

# Build exclude, include, and binary expressions safely
EXCLUDE_EXPR=()
for d in "${EXCLUDE_DIRS[@]}"; do
  EXCLUDE_EXPR+=( -path "$d" -prune -o )
done

INCLUDE_EXPR=()
for g in "${INCLUDE_GLOBS[@]}"; do
  INCLUDE_EXPR+=( -iname "$g" -o )
done
unset 'INCLUDE_EXPR[${#INCLUDE_EXPR[@]}-1]' # remove trailing -o

BINARY_EXPR=()
for g in "${BINARY_GLOBS[@]}"; do
  BINARY_EXPR+=( -iname "$g" -o )
done
unset 'BINARY_EXPR[${#BINARY_EXPR[@]}-1]' # remove trailing -o

find "$AI_DIR" \
  \( "${EXCLUDE_EXPR[@]}" -false \) -o \
  -type f \
  \( "${INCLUDE_EXPR[@]}" \) \
  ! \( "${BINARY_EXPR[@]}" \) \
  -print0 |
sort -z | while IFS= read -r -d '' file; do
  rel="./${file#"$PROJECT_ROOT/"}"
  lang=$(lang_for "$file")

  printf 'Processing: %s\n' "$rel" 1>&2

  {
    echo "## File: $rel"
    echo
    echo "\`\`\`$lang"
    cat "$file"
    echo
    echo "\`\`\`"
    echo
  } >> "$OUTPUT_FILE"
done

# Then explicitly add AGENTS.md from project root if it exists
AGENTS_FILE="$PROJECT_ROOT/AGENTS.md"
if [[ -f "$AGENTS_FILE" ]]; then
  rel="project_root/AGENTS.md"
  lang="markdown"
  printf 'Processing: %s\n' "$rel" 1>&2
  {
    echo "## File: $rel"
    echo
    echo "\`\`\`$lang"
    cat "$AGENTS_FILE"
    echo
    echo "\`\`\`"
    echo
  } >> "$OUTPUT_FILE"
fi

# Cross-platform sed -i
sedi() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Post-process output paths:
# Replace ".//Users/bobware/projects/0-codex-starters/java-spring-boot-codex-starter/" with "project_root/"
sedi 's#\.//Users/bobware/projects/0-codex-starters/java-spring-boot-codex-starter/#project_root/#g' "$OUTPUT_FILE"

echo "Wrote $(wc -l < "$OUTPUT_FILE") lines to $OUTPUT_FILE"
