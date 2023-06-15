#!/bin/bash


fhome=/usr/share/abot2/
log="/var/log/trbot/trbot.log"
fPID=$fhome"trbot_pid.txt"
ftb=$fhome
cuf=$fhome
fm=$fhome"mail.txt"
mass_mesid_file=$fhome"mmid.txt"
home_trbot=$fhome
f_send=$fhome"abot2.txt"
mkdir -p /var/log/trbot/
lev_log=$(sed -n 14"p" $ftb"settings.conf" | tr -d '\r')
starten=1


function Init2() 
{
[ "$lev_log" == "1" ] && logger "Start Init"
chat_id1=$(sed -n 2"p" $ftb"settings.conf" | tr -d '\r')
echo $chat_id1 | tr " " "\n" > $ftb"chats.txt"
chat_id1=$(sed -n 1"p" $ftb"chats.txt" | tr -d '\r')

regim=$(sed -n 3"p" $ftb"settings.conf" | tr -d '\r')
echo $regim > $ftb"amode.txt"
sec4=$(sed -n 4"p" $ftb"settings.conf" | tr -d '\r')
sec4=$((sec4/1000))
sec=$(sed -n 6"p" $ftb"settings.conf" | tr -d '\r')
opov=$(sed -n 7"p" $ftb"settings.conf" | tr -d '\r')
email=$(sed -n 8"p" $ftb"settings.conf" | tr -d '\r')
startid=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')
zap=$(sed -n 10"p" $ftb"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $ftb"settings.conf" | tr -d '\r')
last_id=0
progons=$(sed -n 13"p" $ftb"settings.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $ftb"settings.conf" | tr -d '\r')
send_up_start=$(sed -n 15"p" $ftb"settings.conf" | tr -d '\r')
portapi=$(sed -n 17"p" $fhome"settings.conf" | tr -d '\r')
ipapi=$(sed -n 18"p" $fhome"settings.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $ftb"settings.conf" | tr -d '\r')
sty=$(sed -n 20"p" $ftb"settings.conf" | tr -d '\r')
promapi=$(sed -n 21"p" $ftb"settings.conf" | tr -d '\r')
label1=$(sed -n 22"p" $ftb"settings.conf" | tr -d '\r')
groupp=$(sed -n 23"p" $ftb"settings.conf" | tr -d '\r')

com_help=$(sed -n 28"p" $ftb"settings.conf" | tr -d '\r')
com_job=$(sed -n 29"p" $ftb"settings.conf" | tr -d '\r')
com_status=$(sed -n 30"p" $ftb"settings.conf" | tr -d '\r')
com_del=$(sed -n 31"p" $ftb"settings.conf" | tr -d '\r')
com_cd=$(sed -n 32"p" $ftb"settings.conf" | tr -d '\r')
com_on=$(sed -n 33"p" $ftb"settings.conf" | tr -d '\r')
com_off=$(sed -n 34"p" $ftb"settings.conf" | tr -d '\r')
com_testmail=$(sed -n 35"p" $ftb"settings.conf" | tr -d '\r')
kkik=0
tohelpness;
}



function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" trbot_"$bui": "$1
else
	echo $date1" trbot_"$bui": "$1 >> $log
fi
}


function tohelpness()
{
#help.txt
echo "/"$com_job" - Unresolved problems" > $fhome"help.txt"
echo "/"$com_status" - Server status" >> $fhome"help.txt"
echo "/"$com_del" - Delete event notification (/"$com_del" 12345678)" >> $fhome"help.txt"
echo "After deletion, the notification about the specified event will not come in the future" >> $fhome"help.txt"
echo "/"$com_cd" - Clearing the list of deleted notifications" >> $fhome"help.txt"
echo "/"$com_on" /"$com_off" - Alerting mode (quiet mode)" >> $fhome"help.txt"
#help1.txt
cp -f $fhome"help.txt" $fhome"help1.txt"
echo "Conventions:" >> $fhome"help1.txt"
echo "<b>&#10060;</b> Problem" >> $fhome"help1.txt"
echo "<b>&#9989</b> Resolved problem" >> $fhome"help1.txt"
#help2.txt
cp -f $fhome"help.txt" $fhome"help2.txt"
echo "Severity:" >> $fhome"help2.txt"
echo "<b>&#9898;</b> info" >> $fhome"help2.txt"
echo "<b>&#x1F7E1;</b> warning" >> $fhome"help2.txt"
echo "<b>&#x1F7E0;</b> average" >> $fhome"help2.txt"
echo "<b>&#128308;</b> high" >> $fhome"help2.txt"
echo "<b>&#128996;</b> disaster" >> $fhome"help2.txt"
#help3.txt
cp -f $fhome"help.txt" $fhome"help3.txt"
echo "Conventions:" >> $fhome"help3.txt"
echo "<b>&#10060;</b> Problem" >> $fhome"help3.txt"
echo "<b>&#9989</b> Resolved problem" >> $fhome"help3.txt"
echo "Severity:" >> $fhome"help3.txt"
echo "<b>&#9898;</b> info" >> $fhome"help3.txt"
echo "<b>&#x1F7E1;</b> warning" >> $fhome"help3.txt"
echo "<b>&#x1F7E0;</b> average" >> $fhome"help3.txt"
echo "<b>&#128308;</b> high" >> $fhome"help3.txt"
echo "<b>&#128996;</b> disaster" >> $fhome"help3.txt"

}



regstat()
{
str_col=$(grep -cv "^T" $ftb"settings.conf")
[ "$lev_log" == "1" ] && logger "str_col="$str_col

rm -f $ftb"settings1.conf" && touch $ftb"settings1.conf"

for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $ftb"settings.conf")
if [ "$i" -eq "3" ]; then
echo $regim >> $ftb"settings1.conf"
else
echo $test >> $ftb"settings1.conf"
fi
done

[ "$regim" -eq "1" ] && echo "Alerting mode ON" > $ftb"regim.txt"
[ "$regim" -eq "0" ] && echo "Alerting mode OFF" > $ftb"regim.txt"
otv=$fhome"regim.txt"
send;

echo $regim > $ftb"amode.txt"
logger "regim="$regim

cp -f $ftb"settings1.conf" $ftb"settings.conf"
}


roborob ()  	
{
date1=`date '+ %d.%m.%Y %H:%M:%S'`
[ "$lev_log" == "1" ] && logger "text="$text
otv=""

if [ "$text" = "/$com_help" ] ; then
	[ "$bicons" == "0" ] && [ "$sty" != "1" ] && otv=$fhome"help.txt"
	[ "$bicons" == "0" ] && [ "$sty" == "1" ] && otv=$fhome"help2.txt"
	[ "$bicons" == "1" ] && [ "$sty" != "1" ] && otv=$fhome"help1.txt"
	[ "$bicons" == "1" ] && [ "$sty" == "1" ] && otv=$fhome"help3.txt"
	send;
fi

if [ "$text" = "/$com_job" ]; then
	$ftb"job.sh"
	otv=$fhome"job.txt"
	send;
fi

if [ "$text" = "/$com_status" ]; then
	regim=$(sed -n "1p" $fhome"amode.txt" | tr -d '\r')
	[ "$regim" -eq "1" ] && echo "Alerting mode ON" > $fhome"ss.txt"
	[ "$regim" -eq "0" ] && echo "Alerting mode OFF" > $fhome"ss.txt"

	if [ $(nc -zv $ipapi $portapi 2>&1 | grep -cE "succeeded|open") -gt "0" ]; then 
		echo "Bot AlertAPI UP" >> $fhome"ss.txt"
	else
		echo "Bot AlertAPI DOWN" >> $fhome"ss.txt"
	fi
	if [ $(ps axu | grep -c abot2.sh) -gt "1" ]; then 
		echo "Handler started" >> $fhome"ss.txt"
	else
		echo "Handler stoped" >> $fhome"ss.txt"
	fi
	fpc=$(cat $fhome"delete.txt" | wc -l)
	if [ "$fpc" -gt "0" ]; then 
		echo "Fingerprints deleted:"$fpc >> $fhome"ss.txt"
		#cat $fhome"delete.txt" | tr '\015\012' ' ' >> $fhome"ss.txt"
		#cat $fhome"delete.txt" >> $fhome"ss.txt"
	else
		echo "No remote fingerprints" >> $fhome"ss.txt"
	fi
	autohcheck;
	if [ "$autohcheck_rez" -eq "0" ]; then
		echo "Prom API UP" >> $fhome"ss.txt"
	else
		echo "Prom API DOWN" >> $fhome"ss.txt"
	fi
	
	otv=$fhome"ss.txt"
	send;
fi

if [[ "$text" == "/$com_del"* ]]; then
	$ftb"del.sh" $text	
	otv=$fhome"del.txt"
	send;
fi

if [[ "$text" == "/$com_cd" ]]; then
	echo > $ftb"delete.txt"
	otv=$fhome"cd.txt"
	send;
fi

if [ "$text" = "/$com_on" ]; then
	regim=1;
	regstat;
fi

if [ "$text" = "/$com_off" ]; then
	regim=0;
	regstat;
fi

if [ "$text" = "/testmail" ]; then
	echo "Test abot2-"$bui" "$date1 > $fhome"mail.txt"
	echo "Testing send to mail" >> $fhome"mail.txt"
	$fhome"sendmail.sh"
	otv=$fhome"tmail.txt"
	send;
fi

logger "roborob otv="$otv
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
[ "$lev_log" == "1" ] && logger "send chat_id="$chat_id

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



[ "$lev_log" == "1" ] && logger "send exit"
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

input ()  		
{
[ "$lev_log" == "1" ] && logger "input start"

rm -f $cuf"in.txt"
file=$cuf"in.txt";
$ftb"cucu1.sh" &
pauseloop;

if [ -f $cuf"in.txt" ]; then
	if [ "$(cat $cuf"in.txt" | grep ":true,")" ]; then		
		logger "input OK"
	else
		logger "input file+, timeout.." #error_code
		cat $cuf"in.txt" >> $log
		ffufuf1=1
		sleep 2
	fi
else														
	logger "input FAIL"
	if [ -f $cuf"cu1_pid.txt" ]; then
		logger "input kill cucu1"
		cu_pid=$(sed -n 1"p" $cuf"cu1_pid.txt" | tr -d '\r')
		killall cucu1.sh
		kill -9 $cu_pid
		rm -f $cuf"cu1_pid.txt"
		ffufuf1=1
	fi
fi

[ "$lev_log" == "1" ] && logger "input exit"
}

starten_furer ()  				
{

input;
if [ "$starten" -eq "1" ]; then
	[ "$lev_log" == "1" ] && logger "starten_furer"
	upd_id=$(cat $ftb"in.txt" | jq ".result[].update_id" | tail -1 | tr -d '\r')
	if ! [ -z "$upd_id" ]; then
		echo $upd_id > $ftb"lastid.txt"
		else
		echo "0" > $ftb"lastid.txt"
	fi
	logger "starten_furer upd_id="$upd_id
	starten=0
fi

}




parce ()
{
[ "$lev_log" == "1" ] && logger "parce"
date1=`date '+ %d.%m.%Y %H:%M:%S'`
mi_col=$(cat $cuf"in.txt" | grep -c update_id | tr -d '\r')
logger "parce col upd_id ="$mi_col
upd_id=$(sed -n 1"p" $ftb"lastid.txt" | tr -d '\r')

for (( i=1;i<=$mi_col;i++)); do
	i1=$((i-1))
	mi=$(cat $ftb"in.txt" | jq ".result[$i1].update_id" | tr -d '\r')
	[ "$lev_log" == "1" ] && logger "parce update_id="$mi

	[ -z "$mi" ] && mi=0
	
	[ "$lev_log" == "1" ] && logger "parce cycle upd_id="$upd_id", i="$i", mi="$mi
	if [ "$upd_id" -ge "$mi" ] || [ "$mi" -eq "0" ] || [ "$mi" == "null" ]; then
		ffufuf=1
		else
		ffufuf=0
	fi
	[ "$lev_log" == "1" ] && logger "parce cycle ffufuf="$ffufuf
	
	
	if [ "$ffufuf" -eq "0" ]; then
		chat_id=$(cat $ftb"in.txt" | jq ".result[$i1].message.chat.id" | sed 's/-/z/g' | tr -d '\r')
		[ "$lev_log" == "1" ] && logger "parce chat_id="$chat_id
		if [ "$(echo $chat_id1|sed 's/-/z/g'| tr -d '\r'| grep $chat_id)" ]; then
			[ "$lev_log" == "1" ] && logger "parse chat_id="$chat_id" -> OK"
			text=$(cat $ftb"in.txt" | jq ".result[$i1].message.text" | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			[ "$lev_log" == "1" ] && logger "parse text="$text
			#echo $text > $home_trbot"t.txt"
			roborob;
			
			logger "parce ok"
		else
			logger "parce dont! chat_id="$chat_id" NOT OK"
		fi
	fi
done
echo $mi > $ftb"lastid.txt"

}

autohcheck ()
{
autohcheck_rez=$(curl -I -k -m 13 "$promapi" 2>&1 | grep -cE 'Failed')

if [ "$autohcheck_rez" -eq "1" ]; then
	logger "autohcheck prom api Failed"
else
	logger "autohcheck prom api OK"
fi

}






PID=$$
echo $PID > $fPID

logger ""
logger "start abot2"
Init2;

! [ -f $ftb"id.txt" ] && echo $startid > $fhome"id.txt"

logger "chat_id1="$chat_id1
starten_furer;

[ "$send_up_start" == "1" ] && ! [ -z "$chat_id1" ] && echo "Start abot2-"$bui > $fhome"start.txt" && otv=$fhome"start.txt" && send

if [ -z "$promapi" ]; then
	$fhome"abot1.sh" &
	$fhome"abot2.sh" &
else
	$fhome"abot3.sh" &
fi


kkik=0

while true
do
sleep $sec4
ffufuf1=0


[ "$opov" == "0" ] && input;
[ "$opov" == "0" ] && parce;


kkik=$(($kkik+1))
[ "$kkik" -ge "$progons" ] && Init2

done
rm -f $fPID




