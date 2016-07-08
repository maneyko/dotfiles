#!/bin/bash
# functions
# ======================================================================

csview() { sed 's/,,/, ,/g;s/,,/, ,/g' $@ | column -s, -t;}
goto() { mkdir -p $@ && cd $@; }
num() { ls $@ | wc -l; }

href() {
  if test -f "$1"; then
    cmd="cat"
  else
    cmd="wget -qO -"
  fi
  $cmd "$1" | \
    grep -i -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
    sed -e 's/^<a href=["'"'"']//I' -e 's/["'"'"']$//I'
}


sizes() {
  for f in ${1%/}/*; do
    du -sh $f
  done | sort -h
}

sysbuild() {
  export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
  unalias -a
}

tarx() {
  if test -f "$1"; then
    tar xvzf "$1"
  else
    echo "'$1' is not a valid file"
  fi
}

zipc() {
  if test -d "$1"; then
    comp="`echo "$1" | sed 's/[.].*//'`"
    zip -r "${comp%/}.zip" "$1"
  else
    echo "$1" is not a valid file
  fi
}

if test $HOME = "/Users/maneyko"; then
  export is_maneyko='true'
else
  export is_maneyko=''
fi

man() {
  if test "`which $@ 2>/dev/null`"; then
    vim -c "execute 'Man ' . '$@'" \
        -c "execute \"normal \<C-w>o\"" \
        -c "silent! call ReadMode(1)" \
        -c "set so=0 ft=man"
  else
    /usr/bin/env man $@
  fi
}

setcv2() {
  export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"
}

setcv3() {
  export PYTHONPATH="/usr/local/opt/opencv3/lib/python2.7/site-packages:$PYTHONPATH"
}

extract() {
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

export -f csview goto num setcv2 setcv3 sizes sysbuild tarx man extract
