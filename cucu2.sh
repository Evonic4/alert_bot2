#!/bin/bash

ftb=/usr/share/abot2/
fPID=$ftb"cu2_pid.txt"

Z1="0"
Z2="0"
code1=""
code2=""

if ! [ -f $fPID ]; then		#----------------------- старт------------------
PID=$$
echo $PID > $fPID
token=$(sed -n "1p" $ftb"settings.conf" | tr -d '\r')
chat_id=$(sed -n "1p" $ftb"send.txt" | tr -d '\r')
f_text=$(sed -n "2p" $ftb"send.txt" | tr -d '\r')
proxy=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $ftb"settings.conf" | tr -d '\r')
sty=$(sed -n 20"p" $ftb"settings.conf" | tr -d '\r')

[ "$bicons" == "1" ] && Z1=$1
[ "$sty" == "1" ] || [ "$sty" == "2" ] && Z2=$2

[ "$Z1" == "1" ] && code1="&#10060;"
[ "$Z1" == "2" ] && code1="&#9989"
[ "$Z2" == "1" ] && code2="&#9898;"
[ "$Z2" == "2" ] && code2="&#x1F7E1;"
[ "$Z2" == "3" ] && code2="&#x1F7E0;"
[ "$Z2" == "4" ] && code2="&#128308;"
[ "$Z2" == "5" ] && code2="&#128996;"


IFS=$'\x10'
text=`cat $f_text`


echo "token="$token
echo "chat_id="$chat_id
echo $text

if [ -z "$proxy" ]; then
[ "$Z1" == "0" ] && [ "$Z2" == "0" ] && curl -k -s -m 13 -L -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text > $ftb"out0.txt"
[ "$Z1" != "0" ] || [ "$Z2" != "0" ] && curl -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1$code2</b>"$text > $ftb"out0.txt"

else
[ "$Z1" == "0" ] && [ "$Z2" == "0" ] && curl -k -s -m 13 --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1$code2</b>"$text > $ftb"out0.txt"
[ "$Z1" != "0" ] || [ "$Z2" != "0" ] && curl --proxy $proxy -L -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1$code2</b>"$text > $ftb"out0.txt"

fi

mv $ftb"out0.txt" $ftb"out.txt"

fi #----------------------- конец старт------------------
rm -f $fPID
