# Shell Initializations
# =====================

# Give ``C-s`` and ``C-q`` to readline. ``-`` disables it
stty -ixon

# Disable ``C-d`` to quit session
set -o ignoreeof

# Posix mode
# set -o posix

# Extended globbing
shopt -s extglob

export COLORS=$HOME/.config/colors/base16-custom.$BACKGROUND.sh
test $TMUX && source $COLORS

# Find proper ``dircolors`` if exists on system
if test "$(which gdircolors 2>/dev/null)"; then
  alias dircolors='gdircolors'
fi
if test "$(type dircolors 2>/dev/null)"; then
  # Creates and exports ``$LS_COLORS``
  eval $(dircolors -b ~/.bash/dircolors)
fi

if test $HOME = '/Users/maneyko'; then
  export MANEYKO='true'
fi


if test $TERM
then  # Check if enough room to have first terminal instance greeting
  ncols=$(tput cols)
  nlines=$(tput lines)
  if test $MAC_OS \
    && test $ncols -ge 70 \
    && test $nlines -ge 20 \
    && test "$(tty | grep 001)"
  then
    # cat $HOME/.bin/mac_screenfetch.out
    # printf "\n%s\n\n" "$(cowsay "Hello $USER")"
    printf "\n%s\n\n" "$(python -m this)"
    if test $TMUX
    then
      if test \
        $ncols -ge 181 \
        -a $nlines -ge 48  # Full screen on MacOS
      then
        tmux split-window -h
      fi
    fi
  fi
fi
