#!/bin/bash


# ---------------------------------------------------------------------
# Shell Defaults
# ---------------------------------------------------------------------

set +e

if [[ -n $BASHRC_LOADED ]]; then return; fi
BASHRC_LOADED=1

if [[ -r /etc/bashrc ]]; then
  source /etc/bashrc
fi

set -o ignoreeof
set -o notify

shopt -s \
  cdspell \
  checkjobs \
  expand_aliases \
  extglob \
  histappend \
  hostcomplete \
  no_empty_cmd_completion \
  2>/dev/null

# umask 0022  # D=755,F=644
umask 0002  # D=775,F=664

f=$HOME/.bashrc.local.preload
[[ -s $f ]] && source "$f"

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
$HOME/.local/bin:\
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

export LANG="en_US.UTF-8"

export EDITOR=$(type -P nvim vim vi | head -1)
alias vi=$EDITOR
alias vim=$EDITOR

export GREP_COLOR='1;31'
export GREP_COLORS='mt=1;31'
export LESS='-QRX -j5'
export PAGER='less'

__prompt_cmd() { history -a ; }

export TZ='America/Chicago'
export PROMPT_COMMAND="__prompt_cmd"
export HISTFILE=$HOME/.bash_history
export HISTSIZE=200000
export HISTTIMEFORMAT="%F %T: "

if [[ $- == *i* ]]; then
  INTERACTIVE=true
fi

export BASH_SILENCE_DEPRECATION_WARNING=1

# Reclaim <C-q>, <C-s>, and <C-z>
if [[ -n $INTERACTIVE ]]; then
  for control in start stop susp; do
    stty $control undef
  done
fi

# For debugging Bash startup slowdowns
LOG_TIME_ENABLED=
log_time() {
  if [[ -n $LOG_TIME_ENABLED ]]; then
    : ${START:=$EPOCHREALTIME}
    echo "$1: $(awk "BEGIN { print $EPOCHREALTIME - $START }")"
  fi
}

# Bash Completion
# ---------------

log_time "Before bash completion"

completion_sources=(
$BREW_PREFIX/etc/bash_completion
/etc/bash_completion
)

if [[ -n $INTERACTIVE ]]; then
  for f in ${completion_sources[@]}; do
    if [[ -f $f ]]; then
      : ${bash_completion:=$f}
      # NOTE: This takes ~0.3 seconds
      source "$bash_completion" 2>/dev/null
      break
    fi
  done
fi

log_time "After bash completion"

# Override `bash_completion` and disable tilde expansion
_expand() { return 0 ; }

# ---------------------------------------------------------------------
# COLORS and PS1
# ---------------------------------------------------------------------

TERM_COLORS="$HOME/.config/colors/base16-custom.dark.sh"
if [[ -z $TMUX && -s $TERM_COLORS && $OSTYPE == *darwin* ]]; then
  source "$TERM_COLORS"
fi

# Bold print.
bprint() { printf -- "%b" "\033[1m$1\033[0m" ; }

# 8-bit color print. Example: cprint 1 ERROR
cprint() { printf -- "%b" "\033[38;5;${1}m${2}\033[0m" ; }

# 24-bit color print. Example: cprint24 "255;0;0" "hello world". Color is in "r;g;b" format.
cprint24() { printf -- "%b" "\033[38;2;${1}m${2}\033[0m" ; }

# Underline print.
ulprint() { printf -- "%b" -- "\033[4${1}\033[0m" ; }

# Special color print for prompt string.
pclr() { REPLY="\[\033[38;5;$1m\]$2\[\033[0m\]" ; }
pstr() { pclr "$1" "$2"; ps1+=$REPLY ; }

ps1_border_color=241
: ${ps1_pwd_color:=228}
: ${ps1_host_text:=$HOSTNAME}
: ${ps1_user_color:=196}
: ${ps1_host_color:=147}
: ${PS1_NO_AWS_PROFILE:=true}

if [[ $USER == root ]]; then
  ps1_user_color=220  # Yellow
fi

export ps1_border_color ps1_user_color ps1_host_color ps1_host_text ps1_pwd_color

ps1::git_branch() {
  REPLY=
  [[ $PS1_NO_GIT == true ]] && return
  : ${ps1_git_branch:=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)}
  if [[ $ps1_git_branch == HEAD ]]; then
    local ref=$(git rev-parse HEAD 2>/dev/null)
    ps1_git_branch=${ref:0:7}
  fi
  REPLY=$ps1_git_branch
}

ps1::branch_colon() {
  REPLY=
  ps1::git_branch >/dev/null 2>&1
  [[ ${#ps1_git_branch} -eq 0 ]] && return
  ps1_branch_colon=':'
  REPLY=$ps1_branch_colon
}

ps1::aws_profile() {
  REPLY=
  : ${ps1_aws_profile:=}
  [[ $PS1_NO_AWS_PROFILE == true ]] && return
  [[ $AWS_PROFILE == staging ]] && return
  : ${ps1_aws_profile:=$AWS_PROFILE}
  REPLY=$ps1_aws_profile
}

ps1::aws_profile_colon() {
  REPLY=
  ps1::aws_profile >/dev/null 2>&1
  [[ ${#ps1_aws_profile} -eq 0 ]] && return
  ps1_aws_profile_colon=':'
  REPLY=$ps1_aws_profile_colon
}

ps1::virtual_env() {
  REPLY=
  [[ $PS1_NO_VIRTUAL_ENV == true ]] && return
  ps1_virtual_env=${VIRTUAL_ENV##*/}
  REPLY=$ps1_virtual_env
}

ps1::virtual_env_colon() {
  REPLY=
  ps1::virtual_env >/dev/null 2>&1
  [[ ${#ps1_virtual_env} -eq 0 ]] && return
  ps1_virtual_env_colon=':'
  REPLY=$ps1_virtual_env_colon
}

ps1::tilde_home() {
  ps1_tilde_home=${PWD/#$HOME/'~'}
  REPLY=$ps1_tilde_home
}

ps1::spaces() {
  columns=$(tput cols)
  {
    if [[ $PS1_NO_GIT != true ]]; then
      ps1::git_branch
      ps1::branch_colon
    fi
    if [[ $PS1_NO_AWS_PROFILE != true ]]; then
      ps1::aws_profile
      ps1::aws_profile_colon
    fi
    if [[ $PS1_NO_VIRTUAL_ENV != true ]]; then
      ps1::virtual_env_colon
    fi
    ps1::tilde_home
  } >/dev/null 2>&1
  local line1_size=$((3
    + ${#USER}
    + 2
    + ${#ps1_host_text}
    + 1
    + ${#ps1_tilde_home}
    + ${#ps1_branch_colon}
    + ${#ps1_git_branch}
    + ${#ps1_aws_profile}
    + ${#ps1_aws_profile_colon}
    + ${#ps1_virtual_env}
    + ${#ps1_virtual_env_colon}
    + 1
  ))
  local remaining_width=$(($columns - $line1_size % $columns))
  local space_width=$(($remaining_width - 12))
  if [[ $space_width -lt 0 ]]; then
    space_width=0
  fi
  printf -- ' %.0s' `seq 1 $space_width`
}

ps1=
pstr $ps1_border_color '┌─['
pstr $ps1_user_color   "$USER"
pstr $ps1_border_color ':'
pstr 250               '@'
pstr $ps1_host_color   "$ps1_host_text"
pstr $ps1_border_color ':'
pstr $ps1_pwd_color    '$(ps1::tilde_home;        printf "$REPLY")'
pstr $ps1_border_color '$(ps1::branch_colon;      printf "$REPLY")'
pstr 207               '$(ps1::git_branch;        printf "$REPLY")'
pstr $ps1_border_color '$(ps1::aws_profile_colon; printf "$REPLY")'
pstr 24                '$(ps1::aws_profile;       printf "$REPLY")'
pstr $ps1_border_color '$(ps1::virtual_env_colon; printf "$REPLY")'
pstr 52                '$(ps1::virtual_env;       printf "$REPLY")'
pstr $ps1_border_color "]"
if [[ $PS1_NO_TIME != true ]]; then
  ps1+='$(ps1::spaces)'
  pstr $ps1_border_color "[\\t]"
fi
ps1+="\n"
pstr $ps1_border_color '└['
pstr 7                 '\\$'
pstr $ps1_border_color ']› '
export LONG_PS1="$ps1"

ps1=

pstr $ps1_border_color '┌─['
pstr $ps1_user_color   "$USER"
pstr 250               '@'
pstr $ps1_host_color   "$ps1_host_text"
pstr $ps1_border_color ':'
pstr $ps1_pwd_color    '\W'
pstr $ps1_border_color ']'
ps1+="\n"
pstr $ps1_border_color '└['
pstr 7                 '\$'
pstr $ps1_border_color ']› '

export SHORT_PS1=$ps1
export PS1=$LONG_PS1

log_time "After PS1"

# ---------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------

# Find and evaluate `dircolors` if exists
if [[ -n $INTERACTIVE ]]; then
  _dircolors=$(type -P uu-dircolors gdircolors dircolors | head -1)
  if [[ -n $_dircolors && -f $HOME/.dotfiles/bash/dircolors ]]; then
    eval "$($_dircolors -b $HOME/.dotfiles/bash/dircolors)"
  fi
fi

cp() {
  local cmd=$(type -P uu-cp gcp cp | head -1)
  # `command` prevents infinite recursion
  command "$cmd" -i "$@"
}

grep() {
  local cmd=$(type -P ggrep grep | head -1)
  command "$cmd" -i --color=auto "$@"
}

if command -v rg >/dev/null 2>&1; then
  read -r -d '' _ag_alias << 'EOT'
--smart-case
--follow
--hidden
--glob='!**/.git/*'
--glob='!**/.terraform/*'
--colors='match:fg:magenta'
--colors='match:style:nobold'
--colors='line:fg:yellow'
--colors='line:style:bold'
--colors='path:fg:green'
--colors='path:style:bold'
EOT
  alias rg="rg ${_ag_alias//$'\n'/ }"
  alias ag="rg"
else
  alias ag="ag --color-match '0;35' --hidden --ignore '\\.git/*' --ignore '\\.terraform/*'"
fi

alias mv='mv -i'

alias l='ls -hl'
alias ll='ls -hl'
alias la='ls -A'
alias lla='ls -Ahl'

_ls=$(type -P gls uu-ls ls | head -1)
if [[ $($_ls --version 2>/dev/null) == *(GNU|uutils)* ]]; then
  alias ls="$_ls --color=auto --group-directories-first --time-style +'%b %d %I:%M %p'"
  alias ll="ls -hl --time-style +'%b %d %Y %I:%M %p'"
  alias lsld="ls -hl -AI'*'"
  alias lsd="ls -AI'*'"
else
  export CLICOLOR=1
  export LSCOLORS='ExGxFxdaCxDaDahbadacec'
  alias ls="$_ls -G"
fi

# Helper functions
bashrc()     { BASHRC_LOADED= source "$HOME/.bashrc"; }
cls()        { clear && printf '\e[3J'; }
shortps1()   { export PS1=$SHORT_PS1; }
longps1()    { export PS1=$LONG_PS1; }
rm-DS()      { find . -name .DS_Store -delete -print; }
mac-hide()   { chflags hidden "$@"; }
mac-nohide() { chflags nohidden "$@"; }
nowrap()     { tput rmam; }
rewrap()     { tput smam; }
git-root()   { cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"; }
hread()      { history -r; }
mkdirpcd()   { mkdir -p "$1" ; cd "$1" ; }
tree()       { command tree --filesfirst "$@"; }

if [[ -n $INTERACTIVE ]]; then
  alias ..='cd ../'
  for i in {2..8}; do
    alias .$i='cd '"$(printf '../%.0s' `seq 1 $i`)"
  done
fi

# Platform specific
if [[ $OSTYPE == *darwin* ]]; then
  mcopy()  { pbcopy "$@"; }
  mpaste() { pbpaste "$@"; }
else
  if command -v xclip >/dev/null 2>&1; then
    mcopy() { xclip -selection c "$@"; }
    mpaste() { xclip -o "$@"; }
  fi
fi

log_time "After aliases"

# ---------------------------------------------------------------------
# Specific Environment
# ---------------------------------------------------------------------

if [[ -n $INTERACTIVE ]] ;then
  if command -v tmux >/dev/null 2>&1; then
    export TMUX_VERSION_INT=$(tmux -V | awk "{match(\$2, /[[:digit:]]+\.[[:digit:]]+/); s = substr(\$2, RSTART, RLENGTH); split(s, a, \".\"); printf(\"%d%02d\", a[1], a[2])}")
  fi
fi

if [[ $EDITOR == *nvim* ]]; then
  export VIM_CONFIG_DIR="$HOME/.config/nvim"
else
  export VIM_CONFIG_DIR="$HOME/.vim"
fi

if [[ -f $HISTFILE && -n $INTERACTIVE ]]; then
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

lesspipes=(
$BREW_PREFIX/bin/lesspipe.sh
$BREW_PREFIX/bin/lesspipe
)

if [[ -n $INTERACTIVE ]]; then
  for f in ${lesspipes[@]}; do
    if [[ -f $f ]]; then
      export LESSOPEN="|$f %s"
      [[ $OSTYPE == *darwin* ]] && LESSOPEN+=":"
      break
    fi
  done
fi

# https://github.com/h5py/h5py/blob/05ceae63a19ba0cbac7f37a5b2a8ecf745e2bc32/setup_configure.py#L108
export HDF5_DIR="$BREW_PREFIX/opt/hdf5"

export K9S_CONFIG_DIR=$HOME/.k9s
export K9S_LOGS_DIR=$HOME/.k9s

log_time "After specific environment section"

bashrc_load_rvm() {
  local f=$HOME/.rvm/scripts/rvm
  [[ -f $f ]] || return

  source "$f"
  RVM_LOADED=true
}

bashrc_load_rv() {
  command -v rv >/dev/null 2>&1 || return

  eval "$(rv shell init bash)"
  if [[ -n $INTERACTIVE ]]; then
    eval "$(rv shell completions bash)"
  fi
  RV_LOADED=true
}

# bashrc_load_rvm
bashrc_load_rv

[[ -z $RVM_LOADED ]] && alias rvm=rv

gemdir() {
  if [[ -n $RV_LOADED ]]; then
    rv ruby list --format=json |
      jq -r 'first(.[] | select(.active)).Installed.gem_root + "/gems/"' |
      while read -r line; do echo ${line/#$HOME/\~}; done
  elif [[ -n $RVM_LOADED ]]; then
    echo $rvm_path/gems/$rvm_env_string/gems/
  fi
}

ruby.gemdir() { gemdir; }

[[ $OSTYPE == *darwin* ]] && ulimit -Sn 1024

if [[ $OSTYPE == *darwin* ]]; then
  for app_root in $HOME/ /; do
    chrome_path="${app_root}Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    if [[ -r $chrome_path ]]; then
      : ${WD_CHROME_PATH:=$chrome_path}
      export WD_CHROME_PATH
    fi
  done
fi

log_time "After RVM"

f=$HOME/.bashrc.local
[[ -f $f ]] && source "$f"

log_time "After bashrc.local"

# Python
# -----

f=$HOME/.pythonrc.py
[[ -f $f ]] && export PYTHONSTARTUP="$HOME/.pythonrc.py"

export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

export DOCKER_CLI_HINTS=false

if command -v pi >/dev/null 2>&1; then
  export PI_CACHE_RETENTION=long
fi

# First TTY Greeting
# ------------------
if [[ -n $INTERACTIVE && $OSTYPE == *darwin* ]]; then
  if [[ $GPG_TTY == *0[1-2] ]]; then
    if [[ $COLUMNS -ge 70 && $LINES -ge 20 ]]; then
      if [[ $(($(date +%w) % 2)) -eq 1 && -z $DONT_USE_WTTR_IN ]]; then
        curl wttr.in?2Fn
      else
        :
        # fastfetch -c $HOME/.config/fastfetch-config.json
      fi
    fi
  fi
fi

log_time "After bashrc"
