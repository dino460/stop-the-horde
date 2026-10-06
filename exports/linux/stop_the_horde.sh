#!/bin/sh
printf '\033c\033]0;%s\a' stop the horde
base_path="$(dirname "$(realpath "$0")")"
"$base_path/stop_the_horde.x86_64" "$@"
