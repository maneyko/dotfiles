# aliases
# ===============================================

shopt -s expand_aliases

alias gless="/usr/bin/env less"
alias gman="/usr/bin/env man"

alias cp="cp -i"
alias grep="grep -i --color=auto"
alias less="~/.vim/macros/less.sh"
alias ls="ls --color=auto"
alias mv="mv -i"
alias vi="vim"

alias cls="clear && printf '\e[3J'"
alias dots="cd ~/dotfiles/"
alias la="ls -Ahl"
alias ld="ls -A -I'*'"
alias ll="ls -hl"
alias lld="ls -Ahl -I'*'"
alias num="ls | wc -l"

alias showDesktop='chflags nohidden ~/Desktop/*'
alias hideDesktop='chflags hidden ~/Desktop/*'
alias rm_DS='find . -name .DS_Store -exec rm -v {} \;'

alias ..="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias .6="cd ../../../../../../"

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

