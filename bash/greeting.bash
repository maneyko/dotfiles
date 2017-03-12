# First TTY Greeting
# ------------------

if test -n "$INTERACTIVE" -a "$(tty | grep 001)"
then  # Check if enough room to have first terminal instance greeting
  if test -n "$MACOS" \
    && test $COLUMNS -ge 70 \
    && test $LINES -ge 20
  then
    python -m this
    if test -n "$TMUX"
    then
      if test $COLUMNS -ge 181 \
        && test $LINES -ge 48
      then  # Full screen on macOS
        tmux split-window -h
      fi
    fi
  fi
fi