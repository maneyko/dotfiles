# Bash Aliases
# ============

shopt -s expand_aliases

# Command Aliases
# ---------------
alias cp='cp -i'
alias grep='grep -i --color=auto'
alias mv='mv -i'
alias vi='vim'

# Need to ``brew install coreutils`` to pass
if ! test $MACOS \
  || which gls >/dev/null 2>&1
then
  test $MACOS && _ls='gls' || _ls='ls'
  alias ls="$_ls --color=auto --group-directories-first"
  alias lsld="ls -AhlGI'*'"
  alias lsd="ls -AI'*'"
fi
alias la='ls -A'
alias ll='ls -hlG'
alias lla='ls -AhlG'

# Miniature Functions
# -------------------
alias bashrc='source ~/.bashrc'
alias cls="clear && printf '\e[3J'"
alias less="~/.vim/macros/less.sh"
alias ipython='ipython --profile=maneyko'
alias readline-keys="less -c 'set ft=sh' ~/.bin/readline-keys.out"
alias shortps1='export PS1=$SHORT_PS1'
alias rm-DS='find . -name .DS_Store -delete -print'
alias hide='chflags hidden'
alias nohide='chflags nohidden'

alias ..='cd ../'
for i in {2..8}; do
  alias .$i='cd '"$(printf '../%.0s' `seq 1 $i`)"
done

# Platform Specific
# -----------------
if test $MACOS; then
  alias top='top -u'
  alias mcopy='pbcopy'
  alias mpaste='pbpaste'
  alias wifi-name="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep -o ' SSID: .*' | sed 's/.*: //'"
  alias wifi-pass="security find-generic-password -wa \"$(wifi-name)\""
else
  alias mcopy='xclip -selection c'
  alias mpaste='xclip -o'
fi
