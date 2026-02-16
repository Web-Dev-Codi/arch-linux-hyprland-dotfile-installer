#!/usr/bin/env bash
set -euo pipefail

if command -v zsh >/dev/null 2>&1; then
    exec zsh -ic "$HOME/.local/bin/tmux-ollama-chat"
fi

exec "$HOME/.local/bin/tmux-ollama-chat"
