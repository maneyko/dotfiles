#!/bin/bash

csv="$1"
db="$2"
table="$3"
out="out.sql"
temp="/tmp/_temp.sql"

if test "$1" == "--help" -o \
        "$1" == "-h" -o \
        ! -f "$csv"; then
  echo "Usage:"
  echo -e "\t./sql.sh {filename.csv} {database} [, {tablename}]"
  echo
  return 2>/dev/null || exit 1
fi

if ! test "$table"; then # Table name will be name of csv file
  base="`basename "$csv"`"
  table="${base%.*}"
fi

# echo "DROP TABLE IF EXISTS $table;" > $temp
echo "CREATE TABLE $table (" >> $temp
for col in `head -n1 "$csv" | tr -d "'" | tr -d '"' | tr ',' '\n'`; do
  echo '`'"$col"'` TEXT,' >> $temp
done

if test -f $out; then
  for i in {1..100}; do
    if ! test -f $out$i; then
      out=$out$i
      break
    fi
  done
fi

cat -v $temp | sed -e 's/\^M//g' > $out     # Remove DOS newline
sed -i '$ s/.$//' $out                      # Remove last comma
echo ");" >> $out
rm $temp

cp "$csv" /tmp/

cat << EOF >> $out
LOAD DATA INFILE '/tmp/`basename "$csv"`'
INTO TABLE $db.$table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF

mysql -u root < $out

rm /tmp/`basename "$csv"`

