#!/usr/bin/env bash

set -euo pipefail

mode="${1:-region}"
output_dir="$HOME/Pictures/Screenshots"
output_file="$output_dir/$(date '+%Y%m%d-%H%M%S').png"

mkdir -p "$output_dir"

satty_cmd=(satty --filename - --fullscreen current-screen --floating-hack --early-exit --output-filename "$output_file")

case "$mode" in
region)
  region="$(slurp -c '#ff0000ff')" || exit 0
  grim -g "$region" -t ppm - | "${satty_cmd[@]}"
  ;;
full)
  grim -t ppm - | "${satty_cmd[@]}"
  ;;
window)
  geometry="$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
  if [[ -z "$geometry" || "$geometry" == "null,null nullxnull" ]]; then
    exit 1
  fi
  grim -g "$geometry" -t ppm - | "${satty_cmd[@]}"
  ;;
*)
  exit 1
  ;;
esac
