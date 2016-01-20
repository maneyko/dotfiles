#!/bin/bash

cd ~/dotfiles/

for file in $(ls | grep -v setup); do

	rm -v ~/.$file 2>/dev/null

done
