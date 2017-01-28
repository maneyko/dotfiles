# aliases
# ===============================================

shopt -s expand_aliases

alias cp="cp -i"
alias grep="grep -i --color=auto"
alias mv="mv -i"
alias vi="vim"
alias less="~/.vim/macros/less.sh"

if test $MAC_OS; then
  # Need to ``brew install coreutils``
  alias ls="gls --color=auto --group-directories-first"
else
  alias ls="ls --color=auto --group-directories-first"
fi

alias la="ls -A"
alias ll="ls -hlG"
alias lla="ls -AhlG"
alias lsld="ls -AhlGI'*'"
alias lsd="ls -AI'*'"

alias cls="clear && printf '\e[3J'"
alias bashrc='source ~/.bashrc'
alias ipython='ipython --profile=maneyko'
alias hideDesktop='chflags hidden ~/Desktop/*'
alias showDesktop='chflags nohidden ~/Desktop/*'
alias readline-keys="less -c 'set ft=sh' ~/.bin/readline-keys.out"
alias shortps1='export PS1=$SHORT_PS1'
alias rm-DS='find . -name .DS_Store -delete -print'

alias ..="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias .6="cd ../../../../../../"

if test $MAC_OS
then
  alias top="top -u"
  alias mcopy="pbcopy"
  alias mpaste="pbpaste"
  alias wifi-name="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep -o ' SSID: .*' | sed 's/.*: //'"
  alias wifi-pass="security find-generic-password -wa \"$(wifi-name)\""
else
  alias mcopy="xclip -selection c"
  alias mpaste="xclip -o"
fi
