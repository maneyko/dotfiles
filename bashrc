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
$HOME/.local/bin:\
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

__prompt_cmd() { history -a ; }

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

for f in ${completion_sources[@]}; do
  if [[ -f $f ]]; then
    : ${bash_completion:="$f"}
    # NOTE: This takes ~0.3 seconds
    source "$bash_completion"
    break
  fi
done

log_time "After bash completion"

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
pstr() { pclr "$1" "$2"; ps1+=$REPLY ; }

ps1_border_color=241
: ${ps1_pwd_color:=228}
: ${ps1_host_text:=$HOSTNAME}
: ${ps1_user_color:=196}
: ${ps1_host_color:=147}
: ${PS1_NO_AWS_PROFILE:=true}

if [[ $USER == root ]]; then
  user_color=220  # Yellow
fi

export ps1_border_color ps1_user_color ps1_host_color ps1_host_text ps1_pwd_color

ps1::git_branch() {
  REPLY=
  [[ $PS1_NO_GIT == true ]] && return
  : ${ps1_git_branch:=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)}
  if [[ $ps1_git_branch == HEAD ]]; then
    local ref=$(git rev-parse HEAD)
    ps1_git_branch=${ref:0:7}
  fi
  REPLY=$ps1_git_branch
}

ps1::branch_colon() {
  REPLY=
  ps1::git_branch >/dev/null 2>&1
  if [[ ${#ps1_git_branch} -gt 0 ]]; then
    ps1_branch_colon=':'
  fi
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
  if [[ ${#ps1_aws_profile} -gt 0 ]]; then
    ps1_aws_profile_colon=':'
  fi
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
  if [[ ${#ps1_virtual_env} -gt 0 ]]; then
    ps1_virtual_env_colon=':'
  fi
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
_dircolors=$(type -P uu-dircolors gdircolors dircolors | head -1)
if [[ -n $_dircolors && -f $HOME/.dotfiles/bash/dircolors ]]; then
  eval "$($_dircolors -b $HOME/.dotfiles/bash/dircolors)"
fi

_cp=$(type -P uu-cp gcp cp | head -1)
alias cp="$_cp -i"

_grep=$(type -P ggrep grep | head -1)
alias grep="$_grep -i --color=auto"

if command -v rg >/dev/null 2>&1; then
  read -r -d '' _ag_alias << 'EOT'
--smart-case
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

_ls=$(type -P gls uu-ls ls | head -1)
if [[ $($_ls --version 2>/dev/null) == *(GNU|uutils)* ]]; then
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

named_array_to_json() {
  jq -n '
    $ARGS.positional
    | map(
      split("=")
      | {
          key:   .[0],
          value: (.[1:] | if . == [] then null else join("=") end)
        }
    )
    | from_entries
  ' --args "$@"
}

json_to_named_array() {
  local reply=()
  while read -r line; do
    reply+=("$line")
  done < <(
    jq --argjson mapping "$1" -nr '
      $mapping
      | to_entries
      | map("\(.key)=\(.value)")[]
    '
  )
  echo 'Result is stored in $REPLY'
  REPLY=$reply
}

log_time "After aliases"

# ---------------------------------------------------------------------
# Specific Environment
# ---------------------------------------------------------------------

if command -v tmux >/dev/null 2>&1; then
  export TMUX_VERSION_INT=$(tmux -V | awk "{match(\$2, /[[:digit:]]+\.[[:digit:]]+/); s = substr(\$2, RSTART, RLENGTH); split(s, a, \".\"); printf(\"%d%02d\", a[1], a[2])}")
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

lesspipes=(
$BREW_PREFIX/bin/lesspipe.sh
$BREW_PREFIX/bin/lesspipe
)

for f in ${lesspipes[@]}; do
  if [[ -f $f ]]; then
    export LESSOPEN="|$f %s"

    if [[ $OSTYPE == *darwin* ]]; then
      LESSOPEN+=":"
    fi
    break
  fi
done

if [[ -n $BREW_X86_PREFIX ]]; then
  alias ibrew="arch -x86_64 $BREW_X86_PREFIX/bin/brew"
fi

# https://github.com/h5py/h5py/blob/05ceae63a19ba0cbac7f37a5b2a8ecf745e2bc32/setup_configure.py#L108
export HDF5_DIR="$BREW_PREFIX/opt/hdf5"

export K9S_CONFIG_DIR=$HOME/.k9s
export K9S_LOGS_DIR=$HOME/.k9s

log_time "After specific environment section"

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

if [[ -f $HOME/.bashrc.local ]]; then
  source $HOME/.bashrc.local
fi

log_time "After bashrc.local"

# Pyenv
# -----

# My module
export PYTHONPATH="$HOME/.dotfiles/ipython/maneyko:$PYTHONPATH"
export PYTHON_BASIC_REPL=1

# if [[ -f $HOME/.pythonrc.py ]]; then
#   PYTHONSTARTUP="$HOME/.pythonrc.py"
# fi

export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

export DOCKER_CLI_HINTS=false

if [[ -n "$(command -v pyenv)" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - bash)"

  log_time "After pyenv init"

  if [[ -n $PYTHON_USE_VIRTUALENV ]]; then
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    eval "$(pyenv virtualenv-init -)"
  fi

  log_time "After pyenv virtualenv init"
fi


# NVM
# ---
nvms=(
/usr/local/opt/nvm
$BREW_PREFIX/opt/nvm
/usr/local/nvm
$HOME/.nvm
)

for d in ${nvms[@]}; do
  if [[ -s $d/nvm.sh ]]; then
    NVM_DIR="$d"
    if [[ $USING_NVM == true ]]; then
      # NOTE: This takes ~0.5 seconds
      \. "$NVM_DIR/nvm.sh"
    fi
    break
  fi
done

log_time "After NVM"

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
