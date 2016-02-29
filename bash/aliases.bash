# aliases
# ===============================================

# ps ax | grep itunes | sed 's/[ ].*$//'

shopt -s expand_aliases

alias gless="/usr/bin/env less"
alias gman="/usr/bin/man"

alias cp="cp -i"
alias grep="grep -i --color=auto"
alias less="~/.vim/macros/less.sh"
alias ls="ls --color=auto --group-directories-first"
alias mv="mv -i"
alias vi="vim"

alias cls="clear && printf '\e[3J'"
alias la="ls -A"
alias ll="ls -hl"
alias lla="ls -Ahl"
alias lsld="ls -Ahl -I'*'"
alias lsd="ls -A -I'*'"

alias hideDesktop='chflags hidden ~/Desktop/*'
alias showDesktop='chflags nohidden ~/Desktop/*'
alias rm_DS='find . -name .DS_Store -exec rm -v {} \;'

alias ..="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias .6="cd ../../../../../../"

if test `uname -s` = "Darwin" 2>/dev/null; then
  alias mcopy="pbcopy"
else
  alias mcopy="xclip -selection c"
fi

if test `uname -s` = "Darwin" 2>/dev/null; then
  alias mpaste="pbpaste"
else
  alias mpaste="xclip -o"
fi

