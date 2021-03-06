#!/bin/bash


# ---------------------------------------------------------------------
# Shell Defaults
# ---------------------------------------------------------------------

test -n "$BASHRC_LOADED" && return

test -r /etc/bashrc && {
  source /etc/bashrc
}

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

test -s "$HOME/.bashrc.local.preload" && {
  source "$HOME/.bashrc.local.preload"
}

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


_vim="$(type -P nvim vim vi | head -1)"
export EDITOR="$_vim"
alias vi="$_vim"
alias vim="$_vim"

export GREP_COLOR='1;31'
export LESS='-RX'
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
test "$INTERACTIVE" && {
  controls=(start stop susp)
  for control in ${controls[@]}; do
    stty $control 'undef'
  done
}

# My module
export PYTHONPATH="$HOME/.dotfiles/ipython/maneyko:$PYTHONPATH"

# test -f "$HOME/.pythonrc.py" && {
#   PYTHONSTARTUP="$HOME/.pythonrc.py"
# }


# Bash Completion
# ---------------

completion_sources=(
/usr/local/etc/bash_completion
/etc/bash_completion
)

for f in ${completion_sources[@]}; do
  if test -f "$f"; then
    : ${bash_completion:="$f"}
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
test "$TMUX" -a -f "$TERM_COLORS" -a $(uname) = 'Darwin' && {
  source "$TERM_COLORS"
}

clr() {  # (number, text)
  printf "\033[38;5;${1}m${2}\033[0m"
}
export -f clr

clr24() {  # ("r;g;b", text)
  printf "\033[38;2;${1}m${2}\033[0m"
}
export -f clr24

pclr() {  # (number, text)
  printf "\[\033[38;5;${1}m\]${2}\[\033[0m\]"
}

export PS1_NO_GIT=0

branch_colon() {
  test $PS1_NO_GIT -eq 1 && return
  git branch >/dev/null 2>&1 && echo ':'
}
export -f branch_colon

parse_git_branch() {
  test $PS1_NO_GIT -eq 1 && return
  t1="$(git branch 2>/dev/null)"
  t2="${t1##*\* }"
  printf "${t2%%$'\n'*}"
}
export -f parse_git_branch

nodename="$(uname -n)"
border_color=241
pwd_color=228
: ${host_text:="$nodename"}
: ${user_color:=196}
: ${host_color:=147}

test "$(whoami)" = 'root' && {
  user_color=220  # Yellow
}

LONG_PS1="\
`pclr $border_color  '┌─['                  `\
`pclr $user_color    "$(whoami)"            `\
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
`pclr $user_color    "$(whoami)"   `\
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
test "$_dircolors" -a -f $HOME/.dotfiles/bash/dircolors && {
  eval "$($_dircolors -b $HOME/.dotfiles/bash/dircolors)"
}

_cp="$(type -P gcp cp | head -1)"
alias cp="$_cp -i"

_grep="$(type -P ggrep grep | head -1)"
alias grep="$_grep -i --color=auto"

alias ag='ag --color-match "0;35"'

alias mv='mv -i'

_ls="$(type -P gls ls | head -1)"
if $_ls --color / >/dev/null 2>&1; then
  GNU_LS=true
fi
if test "$GNU_LS"; then
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
if test "$GNU_LS"; then
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
if test $(uname) = 'Darwin'; then
  alias top='top -u'
  alias mcopy='pbcopy'
  alias mpaste='pbpaste'
else
  if test -n "$(command -v xclip)"; then
    alias mcopy='xclip -selection c'
    alias mpaste='xclip -o'
  fi
fi


# First TTY Greeting
# ------------------
if test -n "$INTERACTIVE" -a $(uname) = 'Darwin'; then
  if test -n "$(tty | grep '0[1-2]$')" \
          -a -n "$(command -v neofetch)" \
          -a $COLUMNS -ge 70 \
          -a $LINES   -ge 20; then
    neofetch
  fi
fi


# ---------------------------------------------------------------------
# Specific Environment
# ---------------------------------------------------------------------

# Necessary environment variable for ~/.tmux.conf
if test -n "$(command -v tmux)"; then
  export TMUX_VERSION=$(tmux -V \
    | perl -ne 'printf("%d.%02d",$1,$2) if /([\d]+)\.([\d]+)/')
fi

rvms=(
/usr/local/rvm/scripts/rvm
$HOME/.rvm/scripts/rvm
)

for f in ${rvms[@]}; do
  if test -s "$f"; then
    source "$f"  # Load RVM into a shell session *as a function*
    break
  fi
done

# Helps initialize RVM in new terminal
test $(uname) = 'Darwin' && {
  cd ..
  cd - >/dev/null
}

if test -n "$(command -v pyenv)"; then
  eval "$(pyenv init -)"
fi

NVM_DIR="/usr/local/opt/nvm"

test -s "$NVM_DIR/nvm.sh" && {
  \. "$NVM_DIR/nvm.sh"  # This loads nvm
}

test -f $HOME/.bashrc.local && {
  source $HOME/.bashrc.local
}


BASHRC_LOADED=1
