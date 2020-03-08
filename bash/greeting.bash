#!/bin/bash

# First TTY Greeting
# ------------------

if test -n "$INTERACTIVE" -a "$(tty | perl -ne 'print if /00[1-3]/')"; then
  if test $(uname) = 'Darwin' \
    -a $COLUMNS -ge 70 \
    -a $LINES   -ge 20; then
    $HOME/.dotfiles/mac/mac_screenfetch
    if test -n "$TMUX"; then
      if test $COLUMNS -ge 181 \
        -a    $LINES   -ge 48; then
        tmux split-window -h
      fi
    fi
  fi
fi
