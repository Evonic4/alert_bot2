#!/bin/bash

#переменные
fhome=/usr/share/abot2/
fcache1=$fhome"cache/1/"
fcache2=$fhome"cache/2/"
fPIDcu2=$fhome"cu2_pid.txt"
f_send=$fhome"abot2.txt"
log="/var/log/trbot/trbot.log"
lev_log=$(sed -n 14"p" $ftb"settings.conf" | tr -d '\r')
ftb=$fhome
cuf=$fhome
fPID=$fhome"abot2_pid.txt"



function Init2() 
{
[ "$lev_log" == "1" ] && logger "Init2"
chat_id1=$(sed -n 2"p" $fhome"settings.conf" | sed 's/z/-/g' | tr -d '\r')
regim=$(sed -n 3"p" $fhome"settings.conf" | tr -d '\r')
sec=$(sed -n 6"p" $fhome"settings.conf" | tr -d '\r')
em=$(sed -n 8"p" $fhome"settings.conf" | tr -d '\r')
zap=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')
ssec=$(sed -n 12"p" $fhome"settings.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"settings.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $fhome"settings.conf" | tr -d '\r')
tst=$(sed -n 16"p" $fhome"settings.conf" | tr -d '\r')

kkik=0
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" abot2_"$bui": "$1
else
	echo $date1" abot2_"$bui": "$1 >> $log
fi
}



function alert_bot()
{

[ "$lev_log" == "1" ] && logger "api checks"

#chmod +rx -R $fcache1
find $fcache1 -maxdepth 1 -type f -name '*.xt' | sort > $fhome"a.txt"
str_col=$(grep -cv "^---" $fhome"a.txt")
[ "$lev_log" == "1" ] && logger "bot api str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
test=`basename $(sed -n $i"p" $fhome"a.txt" | tr -d '\r')`
head -n 7 $fcache1$test | tail -n 1 | jq '' > $fcache2$test
[ "$lev_log" == "1" ] && logger $fcache2$test" ok"
cat $fcache2$test

rm -f $fcache1$test
num_alerts=`grep -c description $fcache2$test`
redka;

rm -f $fcache2$test
done

[ "$lev_log" == "1" ] && logger "api checks ok"

}

function gen_id_alert() 
{

oldid=$(sed -n 1"p" $fhome"id.txt" | tr -d '\r')
newid=$((oldid+1))
echo $newid > $fhome"id.txt"

}

function redka() #выдергиваем проблемы из сообщений менеджера
{
[ "$lev_log" == "1" ] && logger "start redka"
logger $fcache2$test
logger "num_alerts="$num_alerts

rm -f $f_send

for (( i1=$((num_alerts-1));i1>=0;i1--)); do
desc=`cat $fcache2$test | jq '.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/UTC/ /g' | sed 's/+0000/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
status=`cat $fcache2$test | jq '.alerts['${i1}'].status' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
finger=`cat $fcache2$test | jq '.alerts['${i1}'].fingerprint' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
severity=`cat $fcache2$test | jq '.alerts['${i1}'].labels.severity' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
#datest=`cat $fcache2$test | jq '.alerts['${i1}'].labels.datest' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`

logger $i1
logger $finger
logger $desc
logger $status
logger $severity

if [ "$tst" == "1" ]; then
desc1=$(echo $desc | awk -F", timestamp:" '{print $1}')
desc2=$(echo $desc | awk -F", timestamp:" '{print $2}'| awk -F"." '{print $1}')
desc=$desc1", timestamp:"$desc2
logger "new desc="$desc
fi

num=$(grep -n "$finger" $fhome"alerts.txt" | awk -F":" '{print $1}')
logger "alerts.txt num="$num

#if ! [ "$(grep "$finger" $fhome"alerts.txt")" ]; then
if [ -z "$num" ]; then
	[ "$lev_log" == "1" ] && logger "-"
	if ! [ "$(grep $finger $fhome"delete.txt")" ]; then
	if [ "$status" == "firing" ]; then
		[ "$lev_log" == "1" ] && logger "-1"
		gen_id_alert;
		echo $newid" "$finger >> $fhome"alerts.txt"
		echo $newid" "$desc >> $fhome"alerts2.txt"
		echo "[ALERT] "$newid" "$desc >> $f_send
		[ "$em" == "1" ] && echo "[ALERT] Problem "$newid", severity: "$severity > $fhome"mail.txt" && echo "[ALERT] "$newid" "$desc >> $fhome"mail.txt" && $ftb"sendmail.sh"
		to_send;
	fi
	else
	[ "$lev_log" == "1" ] && logger "finger "$finger" already removed earlier"
	fi
else
	[ "$lev_log" == "1" ] && logger "+"
	if [ "$status" == "resolved" ]; then
		[ "$lev_log" == "1" ] && logger "+1"
		
		str_col2=$(grep -cv "^#" $fhome"alerts.txt")
		[ "$lev_log" == "1" ] && logger "str_col2="$str_col2
		
		
		desc1=$(sed -n $num"p" $fhome"alerts2.txt" | tr -d '\r')
		
		head -n $((num-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		grep -v $finger $fhome"alerts.txt" > $fhome"alerts_tmp.txt"
		cp -f $fhome"alerts_tmp.txt" $fhome"alerts.txt"
		
		echo "[OK] "$desc1 >> $f_send
		idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk '{print $2}')
		[ "$em" == "1" ] && echo "[OK] Resolved "$idprob", severity: "$severity > $fhome"mail.txt" && echo "[OK] "$idprob" "$desc >> $fhome"mail.txt" && $ftb"sendmail.sh"
		to_send;
	fi
fi

done

#to_send;

}


function to_send() 
{
[ "$lev_log" == "1" ] && logger "start to_send"

regim=$(sed -n "1p" $fhome"amode.txt" | tr -d '\r')

if [ -f $f_send ]; then
	if [ "$regim" == "1" ]; then
		logger "Regim ON"
		! [ -z "$chat_id1" ] && otv=$f_send && send && rm -f $f_send
	fi
fi

}


send1 () 
{

[ "$lev_log" == "1" ] && logger "send1 start"

echo $chat_id > $cuf"send.txt"
echo $otv >> $cuf"send.txt"

rm -f $cuf"out.txt"
file=$cuf"out.txt"; 
$ftb"cucu2.sh" &
pauseloop;

if [ -f $cuf"out.txt" ]; then
	if [ "$(cat $cuf"out.txt" | grep ":true,")" ]; then	
		logger "send OK"
	else
		logger "send file+, timeout.."
		cat $cuf"out.txt" >> $log
		sleep 2
	fi
else	
	logger "send FAIL"
	if [ -f $cuf"cu2_pid.txt" ]; then
		logger "send kill cucu2"
		cu_pid=$(sed -n 1"p" $cuf"cu2_pid.txt" | tr -d '\r')
		killall cucu2.sh
		kill -9 $cu_pid
		rm -f $cuf"cu2_pid.txt"
	fi
fi

[ "$lev_log" == "1" ] && logger "send1 exit"

}



send ()
{
[ "$lev_log" == "1" ] && logger "send start"
rm -f $cuf"send.txt"

chat_id=$(sed -n 2"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
[ "$lev_log" == "1" ] && logger "chat_id="$chat_id

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	echo "sv="$sv
	$ftb"rex.sh" $otv
	
	for (( i=1;i<=$sv;i++)); do
		otv=$fhome"rez"$i".txt"
		send1;
		rm -f $fhome"rez"$i".txt"
	done
	
else
	send1;
fi
}


pauseloop ()  		
{
sec1=0
rm -f $file
again0="yes"
while [ "$again0" = "yes" ]
do
sec1=$((sec1+1))
sleep 1
if [ -f $file ] || [ "$sec1" -eq "$sec" ]; then
	again0="go"
	[ "$lev_log" == "1" ] && logger "pauseloop sec1="$sec1
fi
done
}



autohcheck ()
{

ach=0
for (( i1=1;i<=3;i++)); do
	#nc -zv 127.0.0.1 9087 2>&1 > $fhome"autohcheck.txt"
	[ $(nc -zv 127.0.0.1 9087 2>&1 | grep -cE "succeeded|open") -gt "0" ] && ach=$((ach+1))
	sleep 1
done

if [ "$ach" -gt "0" ]; then
	logger "autohcheck 9087 OK"
else
	logger "autohcheck 9087 NO_OK"
	ab1_pid=$(sed -n 1"p" $fhome"abot1_pid.txt" | tr -d '\r')
	killall abot1.sh
	kill -9 $ab1_pid
	rm -f $fhome"abot1_pid.txt"
	$fhome"abot1.sh" &
fi


}


PID=$$
echo $PID > $fPID
logger "start"
Init2;

while true
do
sleep $ssec
alert_bot;
to_send;
kkik=$(($kkik+1))
if [ "$kkik" -ge "$progons" ]; then
	autohcheck 
	Init2
fi
done



rm -f $fPID

