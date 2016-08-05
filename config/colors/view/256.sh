#!/bin/bash

if test -z $1; then
  start=0
  stop=255
else
  start=$1
  if test -z $2; then
    stop=255
  else
    stop=$2
  fi
fi

if test ! "$c020"; then
  for i in {000..255}; do
    export c$i="`tput setaf $(($i))`"
  done
  export csgr="`tput sgr0`"
fi

for i in `seq $start $stop`; do
  printf "`tput setaf $i` color00$i ■■■■■■■■■■■■■■\n"
  if test $i -lt 10; then
    printf "`tput setaf $i` color00$i ■■■■■■■■■■■■■■\n"
  elif test $i -lt 100; then
    printf "`tput setaf $i` color0$i ■■■■■■■■■■■■■■\n"
  else
    printf "`tput setaf $i` color$i ■■■■■■■■■■■■■■\n"
  fi
done

