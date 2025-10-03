#!/usr/bin/env bash
# =============================================================================
# File: setup_repo.sh
# Author: Bobwares
# Version: 0.1.0
# Date: 2025-10-02
# Description: Sets up the Codex agentic AI pipeline within the current
#              workspace by cloning the codex-agentic-ai-pipeline repository,
#              creating symlinks, copying AI utilities, and installing
#              dependencies for the UI and API projects.
# =============================================================================
# - Copies the codex-agentic-ai-pipeline repo into the Codex workspace.
# - Creates a symbolic link in the project root of the target project to the AGENTS.md in the codex-agentic-ai-pipeline
# =============================================================================

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
