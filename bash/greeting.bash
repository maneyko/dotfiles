#!/bin/bash

# First TTY Greeting
# ------------------

if test -n "$INTERACTIVE" -a "$(tty | grep 001)"
then  # Check if enough room to have first terminal instance greeting
  if test $(uname) = 'Darwin' \
    -a $COLUMNS -ge 70 \
    -a $LINES   -ge 20
  then
    python -m this
    if test -n "$TMUX"
    then
      if test $COLUMNS -ge 181 \
        -a    $LINES   -ge 48
      then  # Full screen on macOS
        tmux split-window -h
      fi
    fi
  fi
fi
