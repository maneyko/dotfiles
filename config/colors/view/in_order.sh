x=`tput op`
y=`printf %$((${COLUMNS}-6))s`

for i in {0..15}
do o=00$i
	echo -e ${o:${#o}-3:3} `tput setaf $i
	tput setab $i`${y// /=}$x
done
unset x y i
