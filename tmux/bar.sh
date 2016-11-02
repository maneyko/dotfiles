#!/bin/bash

text_color=19

if test `uname -s` = 'Darwin'; then
  while test "$TMUX"
  do
    tunes="`$HOME/.mac/tunes.scpt`"
    if test $tunes; then
      if test "`$tunes | grep 'missing value'`"; then
        tmux set -g status-right \
          "#[fg=colour$text_color]#($tunes | sed 's/ -.*//')" || break
      elif test $tunes -gt 42; then
        # Ignore text inside brackets and parens
        tmux set -g status-right \
          "#[fg=colour$text_color]#($tunes \
            | sed 's/([^()]*)//g;
                   s/\[[^][]*\]//g;
                   s/  */ /gp;
                   s/ /  /'
          )" || break
      else
        tmux set -g status-right \
          "#[fg=colour$text_color]#($tunes)" || break
      fi
    else
      tmux set -g status-right \
        "#[fg=colour$text_color]#(date +'%a %b %d %Y')" || break
    fi
    sleep 10
  done &
else
  tmux set -g status-right \
    "#[fg=colour$text_color]#(date +'%a %b %d %Y')"
fi

exit 0
