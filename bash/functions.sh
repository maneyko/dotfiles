#!/bin/bash
# functions
# ======================================================================

extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.*)  echo "using tar"        ; tar xf $1            ;;
            *.tar)    echo "using tar"        ; tar xf $1            ;;
            *.tbz2)   echo "using tar"        ; tar xf $1            ;;
            *.tgz)    echo "using tar"        ; tar xf $1            ;;
            *.gz)     echo "using gunzip"     ; gunzip $1            ;;
            *.bz2)    echo "using bunzip"     ; bunzip2 $1           ;;
            *.dmg)    echo "using hdiutil"    ; hdiutil mount $1     ;;
            *.zip)    echo "using unzip"      ; unzip -z $1          ;;
            *.ZIP)    echo "using unzip"      ; unzip -z $1          ;;
            *.rar)    echo "using unrar"      ; unrar x $1           ;;
            *.pax)    echo "using pax"        ; cat $1 | pax -r      ;;
            *.Z)      echo "using uncompress" ; uncompress $1        ;;
            *.pax.Z)     uncompress $1 --stdout | pax -r             ;;
            *) echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
export -f extract

sizes () {
    for file in $(ls -a); do
        du -sh $file
    done | sort -h
}
export -f sizes

os() {
    if [[ $(uname -a | grep -i linux) ]]; then
        echo "linux"
    else
        echo "mac"
    fi
}
export -f os
