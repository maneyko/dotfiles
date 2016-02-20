#!/bin/bash
# functions
# ======================================================================

os () {
  if test `uname -s` = "Darwin"; then
    echo "mac"
  else
    echo "linux"
  fi
}
export -f os

sysbuild () {
  export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
  unalias -a
}
export -f sysbuild

setcv3 () {
  export PYTHONPATH="/usr/local/opt/opencv3/lib/python2.7/site-packages:$PYTHONPATH"
}
export -f setcv3

setcv2 () {
  export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"
}
export -f setcv2

man () {
  if test "`which $@ 2>/dev/null`"; then
    before_last=`echo $@ | sed 's, *[^ ]\+/*$,,'`
    last=`echo $@ | sed 's@.* @@' | sed 's@.*/@@'`

    if test "`type $last 2>/dev/null | head -1 | grep alias`"; then
      last=`echo $(type $last) | sed 's@.*\`@@' | tr -d "'" | \
        sed 's@.*/@@' | sed 's/[ .].*$//'`
    fi
    argss=`echo $before_last $last`
    args=$@
    vim -c "execute 'Man ' . '$argss'" -c "execute \"normal \<C-w>o\"" \
        -c "silent! call ReadMode(1)" -c "set so=0 ft=man"
  else
    /usr/bin/env man $@
  fi
}
export -f man

csview () { sed 's/,,/, ,/g;s/,,/, ,/g' $@ | column -s, -t; }
export -f csview
num () { ls $@ | wc -l; }
export -f num
goto () { mkdir -p $@ && cd $@;  }

tarc () {
  if test -d $1 || test -f $1; then
    tar -zcvf $1.tgz $1
  else
    echo "'$1' is not a valid file"
  fi
}
export -f tarc

tarx () {
  if test -f $1; then
    tar xf $1
  else
    echo "'$1' is not a valid file"
  fi
}
export -f tarx

sizes () {
  for file in `ls -a $@`; do
    du -sh $@$file
  done | sort -h
}
export -f sizes

extract () {
  if test -f $1; then
    case $1 in
      *.tar.*) echo "using tar"        ; tar xf $1        ;;
      *.tar)   echo "using tar"        ; tar xf $1        ;;
      *.tbz2)  echo "using tar"        ; tar xf $1        ;;
      *.tgz)   echo "using tar"        ; tar xf $1        ;;
      *.gz)    echo "using gunzip"     ; gunzip $1        ;;
      *.bz2)   echo "using bunzip"     ; bunzip2 $1       ;;
      *.dmg)   echo "using hdiutil"    ; hdiutil mount $1 ;;
      *.zip)   echo "using unzip"      ; unzip -z $1      ;;
      *.ZIP)   echo "using unzip"      ; unzip -z $1      ;;
      *.rar)   echo "using unrar"      ; unrar x $1       ;;
      *.pax)   echo "using pax"        ; cat $1 | pax -r  ;;
      *.Z)     echo "using uncompress" ; uncompress $1    ;;
      *.pax.Z) uncompress $1 --stdout | pax -r            ;;
      *) echo "'$1' cannot be extracted/mounted"          ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
export -f extract

if test $HOME = "/Users/maneyko"; then
  export is_maneyko='true'
else
  export is_maneyko=''
fi
