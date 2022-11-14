#!/bin/bash

set -euo pipefail

# Dependency checks
if ! [ -f "/usr/local/bin/asciiquarium" ]; then
  echo "\"command not found: \"asciiquarium\"" >&2
  exit 1
fi
if [ ! "$(command -v alacritty)" ]; then
  echo "\"command not found: \"alacritty\"" >&2
  exit 1
fi
if [ ! "$(command -v xtrlock)" ]; then
  echo "\"command not found: \"xtrlock\"" >&2
  exit 1
fi

# get one space from each screen
WORKSPACES_TO_USE=""
WORKSPACES_SCREENS="$(i3-msg -t get_workspaces | jq -r 'keys[] as $k | "\(.[$k].output) \(.[$k].num)"')"
SCREENS="$(i3-msg -t get_workspaces | jq -r ".[].output" | sort -u)"
while read -r SCREEN ; do
  echo "$SCREEN"
  WORKSPACES_TO_USE="$(grep "$SCREEN" <<< "$WORKSPACES_SCREENS" | head -n 1 | cut -d " " -f2) $WORKSPACES_TO_USE"
done <<< "$SCREENS"

while read -r SPACE ; do
  echo "$SPACE"
  i3-msg 'workspace number '"$SPACE"''
  i3-msg layout tabbed
  alacritty -e /usr/local/bin/asciiquarium &
  sleep .2
  i3-msg fullscreen toggle
done <<< "$WORKSPACES_TO_USE"

# Lock screen and kill all the child processes on unlock
 xtrlock && pkill -f asciiquarium && \
   while read -r SPACE ; do 
     \ i3-msg 'workspace number '"$INDEX"'' ; i3-msg fullscreen toggle
   done <<< "$WORKSPACES_TO_USE"
