#!/usr/bin/env bash
set -euo pipefail

if command -v zsh >/dev/null 2>&1; then
    exec zsh -i
fi

exec "${SHELL:-/bin/bash}" -l
