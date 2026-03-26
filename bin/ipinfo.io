#!/bin/bash

path=$1
shift

curl https://ipinfo.io/"$path" "$@"
echo
