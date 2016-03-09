#!/bin/bash

if test `uname -s` = "Darwin"; then
  while test "$TMUX"
  do
    if test "`~/.mac/tunes.scpt`"; then
      if test "`~/.mac/tunes.scpt | grep 'missing value'`"; then
        tmux set -g status-right \
          "#[fg=colour19]#(~/.mac/tunes.scpt | sed 's/ -.*//')" || break
      elif test "`~/.mac/tunes.scpt | wc -c`" -gt 42; then
        tmux set -g status-right \
          "#[fg=colour19]#(~/.mac/tunes.scpt | \
          sed 's/([^()]*)//g' | sed 's/\[[^][]*\]//g' | \
          sed 's/  */ /gp' | sed 's/ /  /')" || break
      else
        tmux set -g status-right \
          "#[fg=colour19]#(~/.mac/tunes.scpt)" || break
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
