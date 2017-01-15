#!/bin/bash

text_color=19

date_status() {
  tmux set -g status-right \
    "#[fg=colour$text_color]#(date +'%a %b %d %Y')" || break
}


if test `uname` = 'Darwin'
then

  while test $TMUX
  do

    tunes="$($HOME/.mac/tunes.scpt)"

    if test "$tunes"
    then
        tmux set -g status-right \
          "#[fg=colour$text_color]$tunes" || break
    else
      date_status
    fi

    sleep 10
  done &  # Whole loop is background process - updates every 10 seconds

else
  date_status
fi

exit 0
