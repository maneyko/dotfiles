# initializations
# ======================================================================

# Give C-s and C-q to readline. [-] disables it
stty -ixon

# Disable C-d to quit session
set -o ignoreeof

# Posix mode
# set -o posix

# Extended globbing
shopt -s extglob

export COLORS=$HOME/.config/colors/base16-custom.$BACKGROUND.sh

test $TMUX && source $COLORS

if test $TERM
then
  ncols=$(tput cols)
  nlines=$(tput lines)


  if test $MAC_OS \
    && test $ncols -ge 70 \
    && test $nlines -ge 20 \
    && test "$(tty | grep 001)"
  then
    # cat $HOME/.bin/mac_screenfetch.out
    # printf "\n%s\n\n" "$(cowsay "Hello `whoami`")"
    printf "\n%s\n\n" "$(python -m this)"
    if test $TMUX
    then
      if test $ncols -eq 181 -a $nlines -eq 48
      then
        tmux split-window -h
      fi
    fi
  fi
fi
