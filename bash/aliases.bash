# aliases
# ===============================================

shopt -s expand_aliases

alias gless="/usr/bin/env less"
alias gman="/usr/bin/man"

alias cp="cp -i"
alias grep="grep -i --color=auto"
alias less="~/.vim/macros/less.sh"
alias ls="ls --color=auto --group-directories-first"
alias mv="mv -i"
alias top="top -u"
alias vi="vim"

alias cls="clear && printf '\e[3J'"
alias la="ls -A"
alias ll="ls -hlG"
alias lla="ls -AhlG"
alias lsld="ls -AhlGI'*'"
alias lsd="ls -AI'*'"

alias bashrc='source ~/.bashrc'
alias ipython='ipython --profile=maneyko'
alias hideDesktop='chflags hidden ~/Desktop/*'
alias showDesktop='chflags nohidden ~/Desktop/*'
alias readline-keys="less -c 'set ft=sh' ~/.bin/readline-keys.out"
alias shortps1='export PS1=$SHORT_PS1'
alias rm_DS='find . -name .DS_Store -exec rm -v {} \;'

alias ..="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias .6="cd ../../../../../../"

if test `uname -s` = "Darwin" 2>/dev/null; then
  alias mcopy="pbcopy"
  alias mpaste="pbpaste"
else
  alias mcopy="xclip -selection c"
  alias mpaste="xclip -o"
fi
alias git-completion="source /usr/local/etc/bash_completion.d/git-completion.bash"

# if test -d /usr/local/etc/bash_completion.d/; then
#   for file in /usr/local/etc/bash_completion.d/*; do
#     base=`basename "$file"`
#     noext=${base%.*}
#     if [[ "$noext" ==  *completion* ]]; then
#       alias "$noext"="source $file"
#     else
#       alias "${noext}-completion"="source $file"
#     fi
#   done
# fi
# unset file base noext

