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

eval `dircolors -b ~/dotfiles/bash/dircolors`

# screenfetch on first login
if [ $(tput cols) -ge 70 ] && [ $(tput lines) -ge 19 ] && \
   [ $(tty) = "/dev/ttys001" ] && \
   [ -f /usr/local/bin/screenfetch.out ]; then
    cat /usr/local/bin/screenfetch.out
fi
