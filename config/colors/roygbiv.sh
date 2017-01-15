#!/bin/bash

x=`tput op`
y=`printf %$((${COLUMNS}-6))s`

# for i in 0 18 19 8 20 7 21 15 9 16 3 2 6 4 5 17; do
for i in {0..255}; do
  o=00$i
  full=${o:${#o}-3:3}
	echo -e $full `
    tput setaf $i
    tput setab $i
  `${y// /=}$x
done
