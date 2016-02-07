#!/bin/sh

echo $1

if [ -z "$c020" ]; then
  for i in {000..255}; do
    export c$i="$(tput setaf $(expr $i + 0))"
  done
  export csgr="$(tput sgr0)"
fi

for i in {000..255} ; do
  printf "$(tput setaf $(expr $i + 0))color$i ■■■■■■■■■■■■■■\n"
done
