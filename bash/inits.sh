#!/bin/bash
# initializations
# ======================================================================

# enable some readline shortcuts
stty -ixon
set -o ignoreeof

export COLORS=${HOME}/.config/color_setup/base16-custom.${BACKGROUND}.sh

if [[ -n "$TMUX" ]]; then
    source $COLORS
fi

# screenfetch on first login
if [ $(tput cols) -ge 70 ] && [ $(tput lines) -ge 19 ]; then
    if [ $(tty) = "/dev/ttys001" ]; then
        if [ -f /usr/local/bin/screenfetch.out ]; then
            cat /usr/local/bin/screenfetch.out
        fi
    fi
fi
