#!/bin/sh

if test `uname -s` = "Darwin"; then
  while test "$TMUX"
  do
    if test "`~/.tmux/tunes.scpt`"; then
      if test "`~/.tmux/tunes.scpt | grep 'missing value'`"; then
        tmux set -g status-right \
          "#[fg=colour19]#(~/.tmux/tunes.scpt | sed 's/ -.*//')" || break
      elif test "`~/.tmux/tunes.scpt | wc -c`" -gt 42; then
        tmux set -g status-right \
          "#[fg=colour19]#(~/.tmux/tunes.scpt | \
          sed -e 's/([^()]*)//g' | sed -e 's/\[[^][]*\]//g' | \
          sed -n 's/  */ /gp' | sed -r 's/ /  /')" || break
      else
        tmux set -g status-right \
          "#[fg=colour19]#(~/.tmux/tunes.scpt)" || break
      fi
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
