#!/bin/sh
## derived from http://stackoverflow.com/questions/994563/\
##  integrate-readlines-kill-ring-and-the-x11-clipboard

## You need to choose which clipboard to integrate with, OS X or X11:

shell_copy() {
  pbcopy # OS X
  # or ssh user@remote_mac pbcopy
  # or xclip
}
shell_yank() {
  pbpaste
  # or ssh user@remote_mac pbcopy
  # or xclip -o
}
# in the above you could also copy and yank to gnu screen's paste buffer
#   or even remote shared clipboards.
# Just pipe to wherever you want!


## then wire up readline
_xdiscard() {
    echo -n "${READLINE_LINE:0:$READLINE_POINT}" | shell_copy
    READLINE_LINE="${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=0
}
_xkill() {
    echo -n "${READLINE_LINE:$READLINE_POINT}" | shell_copy
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}"
}
_xyank() {
    CLIP=$(shell_yank)
    COUNT=$(echo -n "$CLIP" | wc -c)
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${CLIP}\
        ${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(($READLINE_POINT + $COUNT))
}
# bind -m emacs -x '"\ed": _xdiscard' # backwards kill from point
# bind -m emacs -x '"\ef": _xkill'
# bind -m emacs -x '"\ey": _xyank'
