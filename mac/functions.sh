#!/bin/sh

google() {
  if test "$1" == "-i"; then
    search="https://www.google.com/images?q="
    arg=`echo $@ | sed 's/[^ ]* //' | tr ' ' '+'`
  else
    search="https://www.google.com/search?q="
    arg=`echo $@ | tr ' ' '+'`
  fi
  open $search$arg
}

trash() {
  mv $@ $HOME/.Trash/
}

url() {
    open http://$1
}

volume() {
  if test $1 == "-r"; then
    /usr/bin/osascript -e 'output volume of (get volume settings)'
  elif ! test "`echo $1 | tr -d [:alpha:]`"; then
    echo Bad argument
    exit 1
  else
    /usr/bin/osascript -e "set volume output volume `echo $1 | tr -d [:alpha:]`"
  fi
}

wiki() {
  search='https://en.wikipedia.org/wiki/Special:\Search?search='
  open $search`echo $@ | tr ' ' '+'`
}

export -f google trash url volume wiki
