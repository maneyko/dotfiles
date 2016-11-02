# initializations
# ======================================================================

# give C-s and C-q to readline   # [-] disables it
stty -ixon
# disable C-d to quit session
set -o ignoreeof
# posix mode
# set -o posix
shopt -s extglob

export COLORS=$HOME/.config/colors/base16-custom.$BACKGROUND.sh

if test $TMUX; then
  source $COLORS
fi

if test "$TERM"; then
  ncols="`tput cols`"
  nlines="`tput lines`"
  if test \
    $ncols -ge 70 \
    -a $nlines -ge 20 \
    -a "`tty | grep 001`" \
    -a "`uname -s`" = "Darwin"; then
    # echo; cowsay "Hello, `whoami`"; echo
    # cat $HOME/.bin/mac_screenfetch.out
    printf "\n%s\n\n" "`python -m this`"
    if test $TMUX; then
      if test $ncols -eq 181 -a $nlines -eq 48; then
        tmux split-window -h
      fi
    fi
  fi
fi
