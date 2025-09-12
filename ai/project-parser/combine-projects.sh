#!/usr/bin/env bash
set -euo pipefail

# where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# projects folder is one level up
ROOT_DIR="${SCRIPT_DIR}/../projects"
OUTPUT_DIR="${SCRIPT_DIR}/output"
OUTPUT_FILE="${OUTPUT_DIR}/ai-projects.md"

if [ ! -d "$ROOT_DIR" ]; then
  echo "Error: projects directory not found at $ROOT_DIR" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

{
  echo "# Projects"
  echo ""
} > "$OUTPUT_FILE"

shopt -s nullglob
projects_found=0

for project_path in "$ROOT_DIR"/*; do
  [ -d "$project_path" ] || continue
  projects_found=1
  project_name=$(basename "$project_path")

  {
    echo "## $project_name"
    echo ""
  } >> "$OUTPUT_FILE"

  # job.json
  if [ -f "$project_path/job.json" ]; then
    {
      echo "### job.json"
      echo '```json'
      cat "$project_path/job.json"
      echo ""           # ensure newline before closing fence
      echo '```'
      echo ""
    } >> "$OUTPUT_FILE"
  fi

  # other sections
  for section in inputs prompt-templates output history; do
    section_dir="$project_path/$section"
    [ -d "$section_dir" ] || continue

    {
      echo "### $section"
      echo ""
    } >> "$OUTPUT_FILE"

    if [ "$section" = "history" ]; then
      # pick latest history subdir or fallback
      latest_subdir=$(
        (ls -1dt "$section_dir"/*/ 2>/dev/null || true) | head -n1
      )
      if [ -z "$latest_subdir" ]; then
        latest_subdir="$section_dir"
      fi
      runlog="$latest_subdir/run.log"

      if [ -f "$runlog" ]; then
        rel="${runlog#"$project_path/"}"
        {
          echo "#### $rel"
          echo '```'
          cat "$runlog"
          echo ""
          echo '```'
          echo ""
        } >> "$OUTPUT_FILE"
      else
        {
          echo "_No run.log found in latest history directory_"
          echo ""
        } >> "$OUTPUT_FILE"
      fi

    else
      # include every file
      find "$section_dir" -type f | sort | while read -r file; do
        rel="${file#"$project_path/"}"
        {
          echo "#### $rel"
          echo '```'
          cat "$file"
          echo ""           # ensure newline before closing fence
          echo '```'
          echo ""
        } >> "$OUTPUT_FILE"
      done
    fi
  done
done

if [ "$projects_found" -eq 0 ]; then
  echo "Warning: no projects found in $ROOT_DIR" >&2
fi
