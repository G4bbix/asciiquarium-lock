#!/bin/bash

# Dependency checks
if [ ! "$(command -v asciiquarium)" ]; then
  echo "\"command not found: \"asciiquarium\"" >&2
  exit 1
fi
if [ ! "$(command -v xfce4-terminal)" ]; then
  echo "\"command not found: \"xfce4-terminal\"" >&2
  exit 1
fi
if [ ! "$(command -v xtrlock)" ]; then
  echo "\"command not found: \"xtrlock\"" >&2
  exit 1
fi

# Check for xrandr and run xterms

# Calculate scaled offsets
AMOUNT_SCREENS="$(xrandr | grep -wc connected)"

for (( INDEX=1; INDEX<AMOUNT_SCREENS + 1; INDEX++ )) ; do
  i3-msg 'workspace '"$INDEX"'; exec "xfce4-terminal --fullscreen --hide-menubar --hide-scrollbar --hide-borders -e asciiquarium"'
done

# Lock screen and kill all the child processes on unlock
xtrlock && pkill -f asciiquarium
