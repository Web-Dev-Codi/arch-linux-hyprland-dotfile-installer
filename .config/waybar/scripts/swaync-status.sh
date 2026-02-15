#!/usr/bin/env bash
count=0
dnd="false"
inhibited="false"

if command -v swaync-client &>/dev/null; then
  count=$(timeout 1 swaync-client -c -sw 2>/dev/null) || count=0
  dnd=$(timeout 1 swaync-client -D -sw 2>/dev/null) || dnd="false"
  inhibited=$(timeout 1 swaync-client -I -sw 2>/dev/null) || inhibited="false"
fi

[[ "$count" =~ ^[0-9]+$ ]] || count=0

if [[ "$dnd" == "true" ]]; then
  if [[ "$inhibited" == "true" ]]; then
    if (( count > 0 )); then class="dnd-inhibited-notification"; else class="dnd-inhibited-none"; fi
  else
    if (( count > 0 )); then class="dnd-notification"; else class="dnd-none"; fi
  fi
else
  if [[ "$inhibited" == "true" ]]; then
    if (( count > 0 )); then class="inhibited-notification"; else class="inhibited-none"; fi
  else
    if (( count > 0 )); then class="notification"; else class="none"; fi
  fi
fi

printf '{"class":"%s","text":"%s"}\n' "$class" "$count"
