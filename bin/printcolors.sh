#!/bin/bash


print::color() {
  s1="\033[38;5;$1m"   # Foreground
  s2="\033[48;5;$1m$2" # Background
  s3="\033[39;49m"     # Reset
  printf "$s1$s2$s3"
}

rows=32
cols=8

for (( i=0; i < $rows ; i++ )); do
  for (( j=0; j < $cols; j++ )); do
    num=$((i + $rows*j))
    printf " %03d " $num
    print::color $num '======='
  done
  echo
done
