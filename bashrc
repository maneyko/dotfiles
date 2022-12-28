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

if [[ $OSTYPE == *darwin* && -n $BREW_PREFIX ]]; then
  PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
fi

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

export GPG_TTY=$(tty)

if [[ $OSTYPE == *darwin* ]]; then
  export USING_MAC_OS=true
else
  unset USING_MAC_OS
fi

export EDITOR=$(type -P nvim vim vi | head -1)
alias vi=$EDITOR
alias vim=$EDITOR

export GREP_COLOR='1;31'
export GREP_COLORS='mt=1;31'
export LESS='-QRX -j5'
export PAGER='less'

__prompt_cmd() {
  history -a
}

export TZ='America/Chicago'
export PROMPT_COMMAND="__prompt_cmd"
export HISTFILE=$HOME/.bash_history
export HISTSIZE=200000
export HISTTIMEFORMAT="%F %T: "

if [[ $- == *i* ]]; then
  INTERACTIVE=true
else
  unset INTERACTIVE
fi

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
$BREW_PREFIX/etc/bash_completion
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
_expand() { return 0 ; }


# ---------------------------------------------------------------------
# COLORS and PS1
# ---------------------------------------------------------------------

TERM_COLORS="$HOME/.config/colors/base16-custom.dark.sh"
if [[ -z "$TMUX" && -s $TERM_COLORS && $OSTYPE == *darwin* ]]; then
  source "$TERM_COLORS"
fi

# Bold print.
bprint() { printf -- "%b" "\033[1m$1\033[0m" ; }
export -f bprint

# 8-bit color print. Example: cprint 1 ERROR
cprint() { printf -- "%b" "\033[38;5;${1}m${2}\033[0m" ; }
export -f cprint

# 24-bit color print. Example: cprint24 "255;0;0" "hello world". Color is in "r;g;b" format.
cprint24() { printf -- "%b" "\033[38;2;${1}m${2}\033[0m" ; }
export -f cprint24

# Underline print.
ulprint() { printf -- "%b" -- "\033[4${1}\033[0m" ; }

# Special color print for prompt string.
pclr() { REPLY="\[\033[38;5;${1}m\]${2}\[\033[0m\]" ; }
pstr() { pclr "$1" "$2"; ps1+="$REPLY" ; }

export PS1_NO_GIT=0

border_color=241
pwd_color=228
: ${host_text:=$HOSTNAME}
: ${user_color:=196}
: ${host_color:=147}

if [[ $USER == root ]]; then
  user_color=220  # Yellow
fi

export border_color user_color host_color host_text pwd_color

ps1::git_branch() {
  [[ $PS1_NO_GIT -eq 1 ]] && return
  [[ $ps1_git_branch_size == 0 ]] && return
  : ${ps1_git_branch1:=$(git branch 2>/dev/null)}
  if [[ ${#ps1_git_branch1} -eq 0 ]]; then
    ps1_git_branch_size=0
    return
  fi
  : ${ps1_git_branch2:=${ps1_git_branch1##*\* }}
  ps1_git_branch=${ps1_git_branch2%%$'\n'*}
  printf "$ps1_git_branch"
}

ps1::branch_colon() {
  [[ $PS1_NO_GIT -eq 1 ]] && return
  ps1::git_branch >/dev/null 2>&1
  if [[ ${#ps1_git_branch} -gt 0 ]]; then
    ps1_branch_colon=':'
    printf $ps1_branch_colon
  fi
}

ps1::tilde_home() {
  ps1_tilde_home=${PWD/#$HOME/'~'}
  printf "$ps1_tilde_home"
}

ps1::spaces() {
  columns=$(tput cols)
  { ps1::git_branch ; ps1::branch_colon ; ps1::tilde_home; } >/dev/null 2>&1
  line1_size=$((3 + ${#USER} + 2 + ${#host_text} + 1 + ${#ps1_tilde_home} + ${#ps1_branch_colon} + ${#ps1_git_branch} + 1))
  remaining_width=$(($columns - $line1_size % $columns))
  space_width=$(($remaining_width - 12))
  if [[ $space_width -lt 0 ]]; then
    space_width=0
  fi
  printf -- ' %.0s' `seq 1 $space_width`
}

pstr $border_color '┌─['
pstr $user_color   "$USER"
pstr $border_color ':'
pstr 250           '@'
pstr $host_color   "$host_text"
pstr $border_color ':'
pstr $pwd_color    '$(ps1::tilde_home)'
pstr $border_color '$(ps1::branch_colon)'
pstr 207           '$(ps1::git_branch)'
pstr $border_color "]"
ps1+='$(ps1::spaces)'
pstr $border_color "[\\t]"

ps1+="\n"
pstr $border_color '└['
pstr 7             '\\$'
pstr $border_color ']› '
export LONG_PS1="$ps1"

ps1=

pstr $border_color '┌─['
pstr $user_color   "$USER"
pstr 250           '@'
pstr $host_color   "$host_text"
pstr $border_color ':'
pstr $pwd_color    '\W'
pstr $border_color ']'
ps1+="\n"
pstr $border_color '└['
pstr 7             '\$'
pstr $border_color ']› '

export SHORT_PS1="$ps1"
export PS1=$LONG_PS1


# ---------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------

# Find and evaluate `dircolors` if exists
_dircolors=$(type -P gdircolors dircolors | head -1)
if [[ -n $_dircolors && -f $HOME/.dotfiles/bash/dircolors ]]; then
  eval "$($_dircolors -b $HOME/.dotfiles/bash/dircolors)"
fi

_cp=$(type -P gcp cp | head -1)
alias cp="$_cp -i"

_grep=$(type -P ggrep grep | head -1)
alias grep="$_grep -i --color=auto"

alias ag='ag --color-match "0;35"'

alias mv='mv -i'

_ls=$(type -P gls ls | head -1)
if [[ $($_ls --version 2>/dev/null) == *GNU* ]]; then
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
alias hread="history -r"

mkdirpcd() { mkdir -p "$1" ; cd "$1" ; }
export -f mkdirpcd

alias ..='cd ../'
for i in {2..8}; do
  alias .$i='cd '"$(printf '../%.0s' `seq 1 $i`)"
done

alias whois='whois -h whois.arin.net'

# Platform specific
if [[ $OSTYPE == *darwin* ]]; then
  alias top='top -u'
  alias mcopy='pbcopy'
  alias mpaste='pbpaste'
else
  if command -v xclip >/dev/null 2>&1; then
    alias mcopy='xclip -selection c'
    alias mpaste='xclip -o'
  fi
fi


# ---------------------------------------------------------------------
# Specific Environment
# ---------------------------------------------------------------------

if command -v tmux >/dev/null 2>&1; then
  export TMUX_VERSION_INT=$(tmux -V | awk "{ gsub(/[:alpha:]/, \"\", \$2); split(\$2, a, \".\"); printf(\"%d%02d\", a[1], a[2]) }")
fi

if [[ $EDITOR == *nvim* ]]; then
  export VIM_CONFIG_DIR="$HOME/.config/nvim"
else
  export VIM_CONFIG_DIR="$HOME/.vim"
fi

if [[ -f $HISTFILE ]]; then
  hist_size=$(wc -l < $HISTFILE)
  hist_size=$(($hist_size / 2))  # Every other line is a timestamp
  if [[ $(($HISTSIZE - $hist_size)) -le 1000 ]]; then
    hist_dir=$HISTFILE.d
    hist_logfile="$hist_dir/bash_history-$(date +'%Y%m%d')"
    hist_keep=1000
    echo "Rolling bash history. Backup will be saved to '$hist_logfile'. Keeping last $hist_keep commands."
    mkdir -p "${hist_dir}/"
    cp "$HISTFILE" "$hist_logfile"
    tail -n $(($hist_keep * 2)) "$hist_logfile" > "$HISTFILE"
  fi
fi

export LESSOPEN="|$BREW_PREFIX/bin/lesspipe.sh %s:"

if [[ -n $BREW_X86_PREFIX ]]; then
  alias ibrew="arch -x86_64 $BREW_X86_PREFIX/bin/brew"
fi

# https://github.com/h5py/h5py/blob/05ceae63a19ba0cbac7f37a5b2a8ecf745e2bc32/setup_configure.py#L108
export HDF5_DIR="$BREW_PREFIX/opt/hdf5"

# RVM
# ---
rvms=(
/usr/local/rvm/scripts/rvm
$HOME/.rvm/scripts/rvm
)

for f in ${rvms[@]}; do
  if [[ -s $f ]]; then
    # This takes ~0.15 seconds
    rvm_source=$f
    source "$f"  # Load RVM into a shell session *as a function*
    break
  fi
done

# Helps initialize RVM in new terminal
if [[ -s $rvm_source ]]; then
  cd ../
  cd "$OLDPWD"
fi

if [[ -n $USING_MAC_OS ]]; then
  ulimit -Sn 1024
fi


if [[ -f $HOME/.bashrc.local ]]; then
  source $HOME/.bashrc.local
fi

export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

if [[ -n "$(command -v pyenv)" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PATH="$PYENV_ROOT/shims:$PATH"  # eval "$(pyenv init --path)"
  if [[ -n $PYTHON_USE_VIRTUALENV ]]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# NVM
# ---
nvms=(
/usr/local/opt/nvm
$BREW_PREFIX/opt/nvm
$HOME/.nvm
)

for d in ${nvms[@]}; do
  if [[ -s $d/nvm.sh ]]; then
    NVM_DIR="$d"
    if [[ -n $USING_NVM ]]; then
      # NOTE: This takes ~0.5 seconds
      \. "$NVM_DIR/nvm.sh"
    fi
    break
  fi
done



# First TTY Greeting
# ------------------
if [[ -n $INTERACTIVE && $OSTYPE == *darwin* ]]; then
  if [[ $GPG_TTY == *0[1-2] ]]; then
    if [[ $COLUMNS -ge 70 && $LINES -ge 20 ]]; then
      if [[ $(($(date +%w) % 2)) -eq 1 && -z $DONT_USE_WTTR_IN ]]; then
        curl wttr.in?2Fn
      else
        neofetch
      fi
    fi
  fi
fi
