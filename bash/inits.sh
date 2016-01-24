#!/bin/bash
# initializations
# ======================================================================
source ~/dotfiles/bash/functions.sh

# misc
# =====================================

# enable some readline shortcuts
stty -ixon
set -o ignoreeof


# terminal background
export BACKGROUND="dark"

if [ $(os) = "linux" ]; then
    export COLORS=~/.config/color_setup/base16-custom.${BACKGROUND}_LINUX.sh
else
    export COLORS=~/.config/color_setup/base16-custom.${BACKGROUND}.sh
fi

if [[ $(tty) = /dev/ttys00* && $TERM = *screen* ]]; then
    source $COLORS
fi

# screenfetch on first login
if [ $(tput cols) -ge 70 ] && [ $(tput lines) -ge 19 ]; then
    if [ $(tty) = "/dev/ttys001" ]; then
        cat /usr/local/bin/screenfetch.out
    fi
fi
