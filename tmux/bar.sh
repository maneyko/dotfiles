#!/bin/bash

TEXT_COLOR=19

date_status() {
  text="#[fg=colour$TEXT_COLOR]#(date +'%a %b %d %Y')"
  tmux set -g status-right "$text" || break
}

if test $(uname) = 'Darwin'
then
  while test $TMUX
  do
    tunes="$($HOME/.mac/tunes.scpt)"
    if test -n "$tunes"
    then
      text="#[fg=colour$TEXT_COLOR]$tunes"
      tmux set -g status-right "$text" || break
    else
      date_status
    fi
    sleep 10
  done &  # Whole loop is background process - updates every 10 seconds
else
  date_status
fi
exit 0
