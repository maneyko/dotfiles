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
  if test \
    $ncols -ge 70 \
    -a $nlines -ge 20 \
    -a "$(tty | grep 001)" \
    -a $MAC_OS
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
