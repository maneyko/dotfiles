#!/bin/sh

if test `uname -s` = "Darwin"; then
  while true
  do
    if test "`osascript ~/.tmux/tunes.scpt`"; then
      tmux set -g status-right \
        "#[fg=colour19]#(osascript ~/.tmux/tunes.scpt)" || break
    else
      tmux set -g status-right \
        "#[fg=colour19]#(date +'%a %b %d %Y')" || break
    fi
    sleep 10
  done &
else
  tmux set -g status-right \
    "#[fg=colour19]#(date +'%a %b %d %Y')"
fi

exit 0
