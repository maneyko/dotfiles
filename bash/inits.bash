# Shell Initializations
# =====================

# Give ``C-s`` and ``C-q`` to readline. ``-`` disables it
test "$TERM" != 'dumb' && stty -ixon

# Disable ``C-d`` to quit session
set -o ignoreeof

# Posix mode
# set -o posix

# Extended globbing
shopt -s extglob

export COLORS=$HOME/.config/colors/base16-custom.$BACKGROUND.sh
test $TMUX && source $COLORS

# Find proper ``dircolors`` if exists on system
if test $MACOS \
  && which gdircolors >/dev/null 2>&1; then
  eval $(gdircolors -b ~/.bash/dircolors)
elif which dircolors >/dev/null 2>&1; then
  eval $(dircolors -b ~/.bash/dircolors)
fi

if test $HOME = '/Users/maneyko'; then
  export MANEYKO=true
fi

if test "$TERM" != 'dumb'
then  # Check if enough room to have first terminal instance greeting
  ncols=$(tput cols)
  nlines=$(tput lines)
  if test $MACOS \
    && test $ncols -ge 70 \
    && test $nlines -ge 20 \
    && test "$(tty | grep 001)"
  then
    # cat $HOME/.mac/mac_screenfetch.out
    # printf "\n%s\n\n" "$(cowsay "Hello $USER")"
    printf "\n%s\n\n" "$(python -m this)"
    if test $TMUX
    then
      if test $ncols -ge 181 \
        && test $nlines -ge 48
      then  # Full screen on macOS
        tmux split-window -h
      fi
    fi
  fi
fi
