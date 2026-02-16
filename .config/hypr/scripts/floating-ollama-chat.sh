#!/usr/bin/env bash
printf '\033]0;Ollama Chat\007'
exec "$HOME/.local/bin/tmux-ollama-chat"
