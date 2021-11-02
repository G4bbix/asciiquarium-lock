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
if [ "$(command -v xrandr)" ]; then

  # Calculate scaled offsets
  ORIGINAL_RES="$(xrandr | grep -w connected | grep -oE '[0-9]{4}x[0-9]{4}' | head -n -1)"
  SCALING="$(grep -m 1 "<scale>" ~/.config/monitors.xml  | grep -oE '[0-9]')"
  OFFSETS="+0+0"
  PREV_X=0
  while read -r RES ; do
    X=$((PREV_X + $(echo "$RES" | cut -d x -f1) / SCALING))
    PREV_X="$X"
    OFFSETS="${OFFSETS};+${X}+0"
  done <<< "$ORIGINAL_RES"

  IFS=";"
  for o in $OFFSETS; do
     xfce4-terminal --geometry 0x0$o --fullscreen --hide-menubar \
      --hide-scrollbar --hide-borders -e asciiquarium &
  done
else
  xterm -fullscreen -e asciiquarium &
fi

#Lock screen and kill all the child processes on unlock
xtrlock && pkill -f asciiquarium
