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

umask 0022


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
export HISTSIZE=50000
export HISTTIMEFORMAT="%F %T: "

case "$-" in
  *i*) INTERACTIVE=true ;;
  *) unset INTERACTIVE ;;
esac

export BASH_SILENCE_DEPRECATION_WARNING=1

# Reclaim <C-q> and <C-s>
test "$INTERACTIVE" && {
  stty -ixon
}

test -n "$(type -P tmux)" && {
  export TMUX_VERSION=$(tmux -V \
    | perl -ne 'printf("%d.%02d",$1,$2) if /([\d]+)\.([\d]+)/')
}

# My module
export PYTHONPATH="$HOME/.dotfiles/ipython/maneyko:$PYTHONPATH"

# test -f "$HOME/.pythonrc.py" && {
#   PYTHONSTARTUP="$HOME/.pythonrc.py"
# }


# Bash Completion
# ---------------
completions=(ag aws bash brew bundler coreutils docker docker-compose find git
             hub man nmap npm perl postgres rails rake sh ssh tmux)
completion_dirs=(/usr/local/etc/bash_completion.d)

test -f /usr/local/etc/bash_completion && {
  source /usr/local/etc/bash_completion
}

test -z "$BASH_COMPLETION" && {
  for comp_d in "${completion_dirs[@]}"; do
    test ! -d "$comp_d" && continue
    for prog in "${completions[@]}"; do
      for comp_f in $(ls $comp_d/${prog}* 2>/dev/null); do
        source "$comp_f"
      done
    done
  done
}

# Override `bash_completion` and disable tilde expansion
_expand() {
  return 0
}


# ---------------------------------------------------------------------
# COLORS and PS1
# ---------------------------------------------------------------------

TERM_COLORS=$HOME/.config/colors/base16-custom.dark.sh
test "$TMUX" -a -f "$TERM_COLORS" -a $(uname) = 'Darwin' && {
  source $TERM_COLORS
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

  branch=$(git branch 2>/dev/null | perl -ne 'print $1 if /^\* (.*)/')
  echo $branch
}
export -f parse_git_branch

border_color=241
user_color=154
pwd_color=228
test "$(whoami)" = 'root' && {
  user_color=220  # Yellow
}

if test -n "$(uname -n | grep 'peter-ubuntu')"; then
  host_color=124
  host_text='barry'
elif test -n "$(uname -n | grep 'staging')"; then
  host_color=27
  host_text='staging1'
  RAILS_ENV=staging
elif test $(uname -n) = 'Peters-MacBook-Pro.local'; then
  host_color=214
  host_text='integra'
else
  host_color=147
  host_text="$(uname -n)"
  user_color=196
fi

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
`clr $border_color  '┌─['         `\
`clr $user_color    "$(whoami)"   `\
`clr 250            '@'           `\
`clr $host_color    "$host_text"  `\
`clr $border_color  ':'           `\
`clr $pwd_color     '\\W'         `\
`clr $border_color  ']'           `\
\n\
`clr $border_color  '└['          `\
`clr 7              '\\$'         `\
`clr $border_color  ']› '         `\
"

export PS1="$LONG_PS1"


# ---------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------

# Find and evaluate ``dircolors`` if exists
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
  alias ls="$_ls --color=auto --group-directories-first \
                 --time-style +'%b %d %I:%M %p'"
  alias lsld="ls -AhlI'*'"
  alias lsd="ls -AI'*'"
else
  export CLICOLOR=1
  export LSCOLORS='ExGxFxdaCxDaDahbadacec'
  alias ls="$_ls -G"
fi
alias la='ls -A'
alias ll='ls -hl'
alias lla='ls -Ahl'
alias l='ll'



# Aliases
alias bashrc='source ~/.bashrc'
alias cls="clear && printf '\e[3J'"
alias shortps1='export PS1=$SHORT_PS1'
alias longps1='export PS1="$LONG_PS1"'
alias rm-DS='find . -name .DS_Store -delete -print'
alias hide='chflags hidden'
alias nohide='chflags nohidden'
alias nowrap='tput rmam'
alias rewrap='tput smam'

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
if test -n "$INTERACTIVE"; then
  if test -n "$(tty | grep '00[1-2]')" \
          -a $(uname) = 'Darwin' \
          -a $COLUMNS -ge 70 \
          -a $LINES   -ge 20; then
    source $HOME/.dotfiles/mac/mac_screenfetch
  fi
  if test -n "$TMUX"; then
    if test $COLUMNS -ge 181 \
      -a    $LINES   -ge 48; then
      tmux split-window -h
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
  if test -s $f; then
    source $f  # Load RVM into a shell session *as a function*
    break
  fi
done

test $(uname) = 'Darwin' && {
  cd ..
  cd - >/dev/null
}

test -s "/usr/local/opt/nvm/nvm.sh" && {
  source "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
}

test -f $HOME/.bashrc.local && {
  source $HOME/.bashrc.local
}

BASHRC_LOADED=1
