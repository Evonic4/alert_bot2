#!/bin/bash

home_trbot=/usr/share/abot2/
vjob=$home_trbot"job2.txt"
rm -f $vjob && touch $vjob

str_col=$(grep -cv "^#" $home_trbot"alerts4.txt")
echo "str_col="$str_col

echo "Exiting silent mode, related jobs:" > $vjob
#echo "ID JOB" >> $vjob
cat $home_trbot"alerts4.txt" >> $vjob

echo "----" >> $vjob
cat $vjob

