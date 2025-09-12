#!/usr/bin/env bash
# setup_repo.sh
# Copies the java-spring-boot-codex-starter repo into the Codex workspace.

set -euo pipefail

AI_REPO_URL="https://github.com/bobwares/codex-agentic-ai-pipeline"
AI_REPO_DIR="../codex-agentic-ai-pipeline"


# If directory already exists, skip clone
if [ -d "$AI_REPO_DIR/.git" ]; then
  echo "Repository already cloned in $AI_REPO_DIR. Skipping..."
else
  echo "Cloning $AI_REPO_URL into $AI_REPO_DIR..."
  git clone "$AI_REPO_URL" "$AI_REPO_DIR"
fi
echo "Repository is ready in $AI_REPO_DIR."

# Symlink AGENTS.md into workspace root
ln -sf "$AI_REPO_DIR/AGENTS.md" AGENTS.md
echo "Symlink created: AGENTS.md -> $AI_REPO_DIR/AGENTS.md"



# Copy ./ai/project-parser into workspace root ./ai
mkdir -p ai
cp -R "$AI_REPO_DIR/ai/project-parser" ./ai/
echo "Copied: $AI_REPO_DIR/ai/project-parser -> ./ai/project-parser"

# Verify copy
echo
echo "Workspace AI contents:"
ls -1 ./ai | sed 's/^/  - /'