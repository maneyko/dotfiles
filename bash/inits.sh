#!/bin/bash
# initializations
# ======================================================================

# give C-s and C-q to readline   # [-] disables it
stty -ixon
# disable C-d to quit session
set -o ignoreeof

export COLORS=$HOME/.config/color_setup/base16-custom.${BACKGROUND}.sh

if [[ -n "$TMUX" ]]; then
  source $COLORS
fi

eval `dircolors -b ~/.bash/dircolors`

if [ $(tput cols) -ge 68 ] && [ $(tput lines) -ge 20 ] && \
   [ $(tty | grep 001) ] && \
   [ $(os) = "mac" ]; then
    for i in {00..15}; do
      export c0$i="$(tput setaf $(expr $i + 0))"
    done
    export csgr="$(tput sgr0)"
    cat $HOME/.bin/mac_screenfetch.out
fi

