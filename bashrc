#!/bin/bash


# ---------------------------------------------------------------------
# Shell Defaults
# ---------------------------------------------------------------------

[[ -n $BASHRC_LOADED ]] && return
BASHRC_LOADED=1

if [[ -r /etc/bashrc ]]; then
  source /etc/bashrc
fi

set +e
set -o ignoreeof
set -o notify

shopt -s cdspell                 >/dev/null 2>&1
shopt -s checkjobs               >/dev/null 2>&1
shopt -s expand_aliases          >/dev/null 2>&1
shopt -s extglob                 >/dev/null 2>&1
shopt -s histappend              >/dev/null 2>&1
shopt -s hostcomplete            >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

umask 0002

if [[ -s $HOME/.bashrc.local.preload ]]; then
  source "$HOME/.bashrc.local.preload"
fi

# ---------------------------------------------------------------------
# Environment Variables
# ---------------------------------------------------------------------

PATH="\
$PATH:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/bin:\
/sbin\
"

PATH="\
$HOME/local/bin:\
$HOME/.bin.local:\
$HOME/.bin:\
$PATH\
"

MANPATH="\
$MANPATH:\
$HOME/local/share/man:\
/usr/local/share/man:\
/usr/local/man:\
/usr/share/man\
"

export UNAME_N="${UNAME_N:="$(uname -n)"}"
export UNAME_S="${UNAME_S:="$(uname -s)"}"
export UNAME="${UNAME:="$UNAME_S"}"
export TTY_S="$(tty)"

if [[ $UNAME_S == Darwin ]]; then
  export USING_MAC_OS=true
else
  unset USING_MAC_OS
fi


_vim="$(type -P nvim vim vi | head -1)"
export EDITOR="$_vim"
alias vi="$_vim"
alias vim="$_vim"

export GREP_COLOR='1;31'
export LESS='-RX -j5'
export PAGER='less'

export TZ='America/Chicago'
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=200000
export HISTTIMEFORMAT="%F %T: "

case "$-" in
  *i*) INTERACTIVE=true ;;
  *) unset INTERACTIVE ;;
esac

export BASH_SILENCE_DEPRECATION_WARNING=1

# Reclaim <C-q>, <C-s>, and <C-z>
if [[ -n $INTERACTIVE ]]; then
  controls=(start stop susp)
  for control in ${controls[@]}; do
    stty $control 'undef'
  done
fi

# My module
export PYTHONPATH="$HOME/.dotfiles/ipython/maneyko:$PYTHONPATH"

# if [[ -f $HOME/.pythonrc.py ]]; then
#   PYTHONSTARTUP="$HOME/.pythonrc.py"
# fi


# Bash Completion
# ---------------

completion_sources=(
/usr/local/etc/bash_completion
/etc/bash_completion
)

for f in ${completion_sources[@]}; do
  if [[ -f $f ]]; then
    : ${bash_completion:="$f"}
    # NOTE: This takes ~0.3 seconds
    source "$bash_completion"
    break
  fi
done

# Override `bash_completion` and disable tilde expansion
_expand() {
  return 0
}


# ---------------------------------------------------------------------
# COLORS and PS1
# ---------------------------------------------------------------------

TERM_COLORS="$HOME/.config/colors/base16-custom.dark.sh"
if [[ $TMUX && -s $TERM_COLORS && -n $USING_MAC_OS ]]; then
  source "$TERM_COLORS"
fi

# Bold print.
#
# @param text [String]
bprint() {
  printf "\033[1m$1\033[0m"
}
export -f bprint

# Color print.
#
# @param number [Integer]
# @param text   [String]
cprint() {
  printf "\033[38;5;${1}m${2}\033[0m"
}
export -f cprint

clr24() {  # ("r;g;b", text)
  printf "\033[38;2;${1}m${2}\033[0m"
}
export -f clr24

pclr() {  # (number, text)
  printf "\[\033[38;5;${1}m\]${2}\[\033[0m\]"
}

export PS1_NO_GIT=0

branch_colon() {
  [[ $PS1_NO_GIT -eq 1 ]] && return
  git branch >/dev/null 2>&1 && echo ':'
}
export -f branch_colon

parse_git_branch() {
  [[ $PS1_NO_GIT -eq 1 ]] && return
  t1="$(git branch 2>/dev/null)"
  t2="${t1##*\* }"
  printf "${t2%%$'\n'*}"
}
export -f parse_git_branch

date_command() {
  date +'%A %B %d, %Y @ %I:%M:%S %p'
}

border_color=241
pwd_color=228
: ${host_text:="$UNAME_N"}
: ${user_color:=196}
: ${host_color:=147}

if [[ $USER == root ]]; then
  user_color=220  # Yellow
fi

# \n\
# `pclr $border_color  '\$(date_command)' `\
# \n\
LONG_PS1="\
`pclr $border_color  '┌─['                  `\
`pclr $user_color    "$USER"                `\
`pclr $border_color  ':'                    `\
`pclr 250            '@'                    `\
`pclr $host_color    "$host_text"           `\
`pclr $border_color  ':'                    `\
`pclr $pwd_color     '\\w'                  `\
`pclr $border_color  '\$(branch_colon)'     `\
`pclr 207            '\$(parse_git_branch)' `\
`pclr $border_color  ']'                    `\
\n\
`pclr $border_color  '└['                   `\
`pclr 7              '\\$'                  `\
`pclr $border_color  ']› '                  `\
"

SHORT_PS1="\
`pclr $border_color  '┌─['         `\
`pclr $user_color    "$USER"       `\
`pclr 250            '@'           `\
`pclr $host_color    "$host_text"  `\
`pclr $border_color  ':'           `\
`pclr $pwd_color     '\\W'         `\
`pclr $border_color  ']'           `\
\n\
`pclr $border_color  '└['          `\
`pclr 7              '\\$'         `\
`pclr $border_color  ']› '         `\
"

export PS1="$LONG_PS1"


# ---------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------

# Find and evaluate `dircolors` if exists
_dircolors="$(type -P gdircolors dircolors | head -1)"
if [[ -n $_dircolors && -f $HOME/.dotfiles/bash/dircolors ]]; then
  eval "$($_dircolors -b $HOME/.dotfiles/bash/dircolors)"
fi

_cp="$(type -P gcp cp | head -1)"
alias cp="$_cp -i"

_grep="$(type -P ggrep grep | head -1)"
alias grep="$_grep -i --color=auto"

alias ag='ag --color-match "0;35"'

alias mv='mv -i'

_ls="$(type -P gls ls | head -1)"
if { $_ls --version | \grep GNU ; } >/dev/null 2>&1; then
  GNU_LS=true
fi
if [[ -n $GNU_LS ]]; then
  alias ls="$_ls --color=auto --group-directories-first --time-style +'%b %d %I:%M %p'"
else
  export CLICOLOR=1
  export LSCOLORS='ExGxFxdaCxDaDahbadacec'
  alias ls="$_ls -G"
fi
alias l='ls -hl'
alias ll='l'
alias la='ls -A'
alias lla='ls -Ahl'
if [[ -n $GNU_LS ]]; then
  alias ll="l --time-style +'%b %d %Y %I:%M %p'"
  alias lsld="ll -AI'*'"
  alias lsd="ls -AI'*'"
fi


# Aliases
alias bashrc='BASHRC_LOADED="" source ~/.bashrc'
alias cls="clear && printf '\e[3J'"
alias shortps1='export PS1="$SHORT_PS1"'
alias longps1='export PS1="$LONG_PS1"'
alias rm-DS='find . -name .DS_Store -delete -print'
alias hide='chflags hidden'
alias nohide='chflags nohidden'
alias nowrap='tput rmam'
alias rewrap='tput smam'
alias git-root='cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"'

function mkdirpcd { mkdir -p "$1"; cd "$1"; }
export -f mkdirpcd

alias ..='cd ../'
for i in {2..8}; do
  alias .$i='cd '"$(printf '../%.0s' `seq 1 $i`)"
done

alias whois='whois -h whois.arin.net'

# Platform specific
if [[ -n $USING_MAC_OS ]]; then
  alias top='top -u'
  alias mcopy='pbcopy'
  alias mpaste='pbpaste'
else
  if [[ -n $(command -v xclip) ]]; then
    alias mcopy='xclip -selection c'
    alias mpaste='xclip -o'
  fi
fi


# First TTY Greeting
# ------------------
if [[ -n $INTERACTIVE && -n $USING_MAC_OS ]]; then
  if [[ $TTY_S =~ .*0[1-2]$ ]]; then
    if [[ $COLUMNS -ge 70 && $LINES -ge 20 ]]; then
      if [[ $(($(date +%w) % 2)) -eq 0 ]]; then
        neofetch
      else
        curl wttr.in?2Fn
      fi
    fi
  fi
fi


# ---------------------------------------------------------------------
# Specific Environment
# ---------------------------------------------------------------------

rvms=(
/usr/local/rvm/scripts/rvm
$HOME/.rvm/scripts/rvm
)

for f in ${rvms[@]}; do
  if [[ -s $f ]]; then
    # This takes ~0.15 seconds
    rvm_source="$f"
    source "$f"  # Load RVM into a shell session *as a function*
    break
  fi
done

# Helps initialize RVM in new terminal
if [[ -s $rvm_source ]]; then
  _origin_pwd="$PWD"
  cd ../
  cd "$_origin_pwd"
fi

NVM_DIR="/usr/local/opt/nvm"

if [[ -n $USING_NVM ]]; then
  if [[ -s $NVM_DIR/nvm.sh ]]; then
    # NOTE: This takes ~0.5 seconds
    \. "$NVM_DIR/nvm.sh"  # This loads nvm
  fi
fi

if [[ -f $HOME/.bashrc.local ]]; then
  source $HOME/.bashrc.local
fi
