#!/bin/bash
# exports
# ===============================================

# paths
# =====================================
export PATH="\
/usr/local/gnubin:\
/usr/local/bin:\
/usr/local/sbin:\
/bin:\
/sbin:\
/usr/bin:\
/usr/sbin:\
$PATH
"

export MANPATH="\
/usr/local/gnuman:\
/usr/share/man:\
/usr/local/share/man:\
$MANPATH\
"

export PYTHONPATH="\
/usr/local/lib/python2.7/site-packages:\
/usr/local/lib/python3.5/site-packages:\
$PYTHONPATH\
"

# export VIMRUNTIME="\
# /usr/local/Cellar/macvim/current/MacVim.app\
# /Contents/Resources/vim/runtime/"

# UI
# =====================================

export PS1='\
\[\e[0;36m\]┌─[\[\e[0m\]\
\[\e[1;33m\]\u\[\e[0m\]\
\[\e[0;36m\]]─[\[\e[0m\]\
\[\e[1;31m\]\l\[\e[0m\]\
\[\e[0;36m\]]—[\[\e[0m\]\
\[\e[1;34m\]\w\[\e[0m\]\
\[\e[0;36m\]]\[\e[0m\]\
\n\
\[\e[0;36m\]└─[\[\e[0m\]\
\[\e[1;37m\]\$\[\e[0m\]\
\[\e[0;36m\]]› \[\e[0m\]'

export PAGER="\
/bin/sh -c \"unset PAGER; \
col -bx | source ~/.vim/macros/less.sh -\""

export LESS='-rI'
export EDITOR='vim'
export GREP_COLOR='0;34'
eval `dircolors ~/.dircolors`

# terminal background
export BACKGROUND="dark"

# aliases
# ===============================================

alias ..="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias .6="cd ../../../../../../"

alias gless="env less"
alias less="~/.vim/macros/less.sh"
alias ls="ls --color=auto"
alias grep="grep -i --color=auto"
alias cp="cp -i"
alias mv="mv -i"

alias num="echo $(ls | wc -l)" 
alias cls="clear && printf '\e[3J'"

alias dots="cd ~/dotfiles/"

