#!/bin/bash
# initializations
# ======================================================================

# give C-s and C-q to readline   # [-] disables it
stty -ixon
# disable C-d to quit session
set -o ignoreeof
# posix mode
# set -o posix
shopt -s extglob

export COLORS=$HOME/.config/colors/custom/base16-custom.$BACKGROUND.sh

if test "$TMUX"; then
  source $COLORS
fi

eval `dircolors -b ~/.bash/dircolors 2>/dev/null`

if test "$TERM"; then
  if test `tput cols` -ge 70 -a `tput lines` -ge 20 -a \
          "`tty | grep 001`" -a `uname -s` = "Darwin" 2>/dev/null; then
      cat $HOME/.bin/mac_screenfetch.out
    if test $TMUX; then
      if test `tput cols` -eq 181 -a `tput lines` -eq 48; then
        tmux split-window -h
      fi # full screen
    fi
  fi # first login on mac
fi

