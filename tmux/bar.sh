#!/bin/sh

if [ $(os) = "mac" ]; then
    while true
    do
        if [ -n "$(osascript ~/dotfiles/tmux/tunes.scpt)" ]; then
            tmux set -g status-right \
                "#[fg=colour19]#(osascript ~/dotfiles/tmux/tunes.scpt)" || break
        else
            tmux set -g status-right \
                "#[fg=colour19]#(date +'%a %b %d %Y')" || break
        fi
        sleep 10
    done &
else
    tmux set -g status-right \
        "#[fg=colour19]#(date +'%a %b %d %Y')"
fi

exit 0
