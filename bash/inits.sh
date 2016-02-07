#!/bin/bash
# initializations
# ======================================================================

# give C-s and C-q to readline   # [-] disables it
stty -ixon
# disable C-d to quit session
set -o ignoreeof

export COLORS=$HOME/.config/color_setup/base16-custom.$BACKGROUND.sh

if test $TMUX; then
  source $COLORS
fi

eval `dircolors -b ~/.bash/dircolors`

if test `tput cols` -ge 68 -a `tput lines` -ge 20 -a \
        "`tty | grep 001`" -a `os` = "mac"; then
    for i in {00..15}; do
      export c0$i="`tput setaf $(expr $i + 0)`"
    done
    export csgr="`tput sgr0`"
    cat $HOME/.bin/mac_screenfetch.out
fi

