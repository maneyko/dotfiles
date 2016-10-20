#!/bin/bash

google() {
  if test "$1" == "-i"; then
    search="https://www.google.com/images?q="
  else
    search="https://www.google.com/search?q="
  fi
  arg=${@// /+}
  open $search$arg
}

trash() {
  mv $@ $HOME/.Trash/
}

url() {
    open http://$1
}

volume() {
  arg="`echo $1 | tr -d [:alpha:]`"
  if ! test ${arg//*'-r'*}; then
    /usr/bin/osascript -e 'output volume of (get volume settings)'
  elif ! test ${arg//*[0-9]*}; then
    /usr/bin/osascript -e "set volume output volume $arg"
  fi
}

wiki() {
  search='https://en.wikipedia.org/wiki/Special:\Search?search='
  open $search${@// /+}
}

funcs=`grep -o '[a-zA-Z0-9]\+()' $BASH_SOURCE | sed 's/[()]//g'`
for fn in $funcs; do
  export -f $fn
done
