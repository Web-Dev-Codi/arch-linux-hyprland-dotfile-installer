#!/usr/bin/env bash
SCREENSAVER_FILE="${SCREENSAVER_FILE:-$HOME/.config/omarchy/branding/screensaver.txt}"
export SCREENSAVER_FILE
if [[ ! -f "$SCREENSAVER_FILE" ]]; then
  pidof hyprlock || hyprlock
  exit 0
fi
ghostty -e sh -c 'printf "\033]0;screensaver\007"; cat "$SCREENSAVER_FILE"; echo ""; read -n 1 -s -r; exit 0'
pidof hyprlock || hyprlock
