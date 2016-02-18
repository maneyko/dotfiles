#!/bin/bash
# initializations
# ======================================================================

# give C-s and C-q to readline   # [-] disables it
stty -ixon
# disable C-d to quit session
set -o ignoreeof

export COLORS=$HOME/.config/colors/custom/base16-custom.$BACKGROUND.sh

if test "$TMUX"; then
  source $COLORS
fi

eval `dircolors -b ~/.bash/dircolors 2>/dev/null`

if test `tput cols` -ge 70 -a `tput lines` -ge 20 -a \
        "`tty | grep 001`" -a `uname -s` = "Darwin" 2>/dev/null; then
    cat $HOME/.bin/mac_screenfetch.out
fi

