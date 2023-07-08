#!/bin/bash

#переменные
fhome=/usr/share/abot2/
fhsender=/usr/share/abot2/sender/
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
fPID=$fhome"sender_pid.txt"
log=$fhsender"sender_log.txt"

sender_id=$fhome"sender_id.txt"
sender_list=$fhome"sender_list.txt"
sendok=0
senderr=0

function Init2() 
{
logger "Init2"
#rm -rf $fhsender
mkdir -p $fhsender1
mkdir -p $fhsender2
echo 0 > $sender_id

zap=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')
token=$(sed -n "1p" $fhome"settings.conf" | tr -d '\r')
proxy=$(sed -n 5"p" $fhome"settings.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $fhome"settings.conf" | tr -d '\r')
sty=$(sed -n 20"p" $fhome"settings.conf" | tr -d '\r')
ssec=$(sed -n 12"p" $fhome"settings.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"settings.conf" | tr -d '\r')
chat_id=$(sed -n "2p" $fhome"settings.conf" | sed 's/z/-/g' | tr -d '\r')

kkik=0

integrity;
}



integrity ()
{
logger "integrity"

local ab3p=""
local trbp=""
ab3p=$(ps af | grep $(sed -n 1"p" ./abot3_pid.txt | tr -d '\r') | grep abot3.sh | awk '{ print $1 }')
trbp=$(ps af | grep $(sed -n 1"p" ./trbot_pid.txt | tr -d '\r') | grep trbot.sh | awk '{ print $1 }')

[ -z "$ab3p" ] && logger "starter abot3.sh" && $fhome"abot3.sh" &
[ -z "$trbp" ] && logger "starter trbot.sh" && $fhome"trbot.sh" &
}



function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" sender_"$bui": "$1
else
	echo $date1" sender_"$bui": "$1 >> $log
fi
}



function sender()
{
#logger "sender"

find $fhsender1 -maxdepth 1 -type f -name '*.txt' | sort > $sender_list
str_col=$(grep -cv "^---" $sender_list)
#logger "sender str_col="$str_col

if [ "$str_col" -gt "0" ]; then
for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $sender_list | tr -d '\r')
logger "sender str_col>0"

#logger "sender test="$test

Z1="0"
Z2="0"
code1=""
code2=""
mess_path=$(sed -n "1p" $test | tr -d '\r')			#путь к мессаджу
bic1=$(sed -n "2p" $test | tr -d '\r')				#спец картинок в уведомлениях 0-2
styc1=$(sed -n "3p" $test | tr -d '\r')				#показ спец картинок severity 0-6
url1=$(sed -n "4p" $test | tr -d '\r')				#урл
muter=$(sed -n "5p" $test | tr -d '\r')				#mute
	
if ! [ -z "$test" ] && ! [ -z "$mess_path" ]; then
	[ "$bicons" == "1" ] && Z1=$bic1
	[ "$sty" == "1" ] && Z2=$styc1
	
	[ "$bic1" == "1" ] && code1="&#10060;"
	[ "$bic1" == "2" ] && code1="&#9989"
	
	[ "$muter" == "0" ] && muter="false"
	[ "$muter" == "1" ] && muter="true"
	
	logger "sender mess_path="$mess_path
	logger "sender bic1="$bic1
	logger "sender styc1="$styc1
	logger "sender url1="$url1
	logger "sender muter="$muter
	
	
	directly
	
	#statistic
	if [ "$(cat $fhome"out2.txt" | grep "\"ok\":true,")" ]; then	
		sendok=$((sendok+1))
		logger "send OK "$sendok
		rm -f $test
		rm -f $mess_path
	else
		errc=$(grep "curl" $fhome"out2_err.txt")
		senderr=$((senderr+1))
		logger "send ERROR "$senderr":   "$errc
	fi
fi

sleep 0.3
done

sums=$((sendok+senderr))
[ "$sums" -gt "0" ] && echo $(echo "scale=2; $senderr/$sums * 100" | bc) > $fhome"err_send.txt"

fi


}



directly () {
logger " "
logger "sender directly"

IFS=$'\x10'
text=`cat $mess_path`
echo "token="$token
echo "chat_id="$chat_id
echo $text

if ! [ -z "$text" ]; then
if [ -z "$proxy" ]; then
[ "$Z1" == "0" ] && [ "$Z2" == "0" ] && curl -k -m $ssec -L -X POST https://api.telegram.org/bot$token/sendMessage -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"
[ "$Z1" != "0" ] || [ "$Z2" != "0" ] && curl -k -m $ssec -L -X POST https://api.telegram.org/bot$token/sendMessage -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1</b>"$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"

else
[ "$Z1" == "0" ] && [ "$Z2" == "0" ] && curl -k -m $ssec --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage  -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"
[ "$Z1" != "0" ] || [ "$Z2" != "0" ] && curl -k -m $ssec --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage  -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1</b>"$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"
fi

fi

unset IFS

}








PID=$$
echo $PID > $fPID
Init2;
logger "sender start"

while true
do
sleep 1
sender;

kkik=$(($kkik+1))
[ "$kkik" -ge "$progons" ] && Init2

done



rm -f $fPID
