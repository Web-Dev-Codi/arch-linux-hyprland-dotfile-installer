#!/usr/bin/env bash
printf '\033]0;Floating Terminal\007'
exec "${SHELL:-/bin/bash}" -l
