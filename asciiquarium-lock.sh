#!/bin/bash

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

WORKSPACES="$(i3-msg -t get_workspaces)"
SCREENS_EXPR="$(jq -r ".[].output" <<< "$WORKSPACES" | sort -u | paste -sd \|)"
WORKSPA0CES_EACH_SCREEN="$(jq -r 'keys[] as $k | "\(.[$k].output) \(.[$k].num)"' <<< "$WORKSPACES" \
  | grep -E "^($SCREENS_EXPR)" | cut -d " " -f2)"

while read -r SPACE ; do
  i3-msg 'workspace number '"$SPACE"''
  i3-msg tabbed layout
  alacritty -e /usr/local/bin/asciiquarium &
  sleep .2
  i3-msg fullscreen toggle
done <<< "$WORKSPA0CES_EACH_SCREEN"

# Lock screen and kill all the child processes on unlock
 xtrlock && pkill -f asciiquarium && \
   while read -r SPACE ; do 
     \ i3-msg 'workspace number '"$INDEX"'' ; i3-msg fullscreen toggle
   done <<< "$WORKSPA0CES_EACH_SCREEN"
