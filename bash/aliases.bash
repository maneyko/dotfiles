# aliases
# ===============================================

# ps ax | grep itunes | awk -F" " '{print $1}' | xargs kill 2>/dev/null

shopt -s expand_aliases

alias gless="/usr/bin/env less"
alias gman="/usr/bin/env man"

alias cc="clang"
alias cp="cp -i"
alias grep="grep -i --color=auto"
alias less="~/.vim/macros/less.sh"
alias ls="ls --color=auto"
alias mv="mv -i"
alias vi="vim"

alias cls="clear && printf '\e[3J'"
alias dots="cd ~/dot/"
alias la="ls -A"
alias ld="ls -A -I'*'"
alias ll="ls -hl"
alias lla="ls -Ahl"
alias lld="ls -Ahl -I'*'"

alias hideDesktop='chflags hidden ~/Desktop/*'
alias showDesktop='chflags nohidden ~/Desktop/*'
alias rm_DS='find . -name .DS_Store -exec rm -v {} \;'

if [ $(os) = "mac" ]; then
  alias ccopy="pbcopy"
else
  alias ccopy="xclip -selection c"
fi

if [ $(os) = "mac" ]; then
  alias cput="pbpaste"
else
  alias cput="xclip -o"
fi

alias ..="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias .6="cd ../../../../../../"

