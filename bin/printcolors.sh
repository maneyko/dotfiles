#!/bin/bash


print::color() {
  s1="\033[38;5;$1m"
  s2="\033[48;5;$1m$2"
  s3="\033[39;49m"
  printf "$s1$s2$s3"
}

for (( i=0; i < 32 ; i++ )); do
  for (( j=0; j < 8; j++ )); do
    num=$((i + 32*j))
    printf " %03d " $num
    print::color $num '======='
  done
  echo
done
