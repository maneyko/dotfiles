#!/bin/sh
# https://github.com/vim/vim/blob/master/runtime/macros/less.sh

if test -t 1; then
  if test $# = 0; then
    if test -t 0; then
      echo "Missing filename" 1>&2
      exit
    fi
    vim - \
      -c 'AnsiEsc' \
      -c 'silent! call ReadMode(1)'

  else
    vim "$@" \
      -c 'AnsiEsc' \
      -c 'silent! call ReadMode(1)'
  fi
else
  # Output is not a terminal, cat arguments or stdin
  if test $# = 0; then
    if test -t 0; then
      echo "Missing filename" 1>&2
      exit
    fi
    /usr/local/bin/less
  else
    /usr/local/bin/less "$@"
  fi
fi
