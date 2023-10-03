#!/bin/bash

#переменные
fhome=/usr/share/abot2/
fhsender=/usr/share/abot2/sender/
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
f_send=$fhome"send_abot3.txt"
log="/var/log/trbot/trbot.log"
lev_log=$(sed -n 14"p" $ftb"sett.conf" | tr -d '\r')
ftb=$fhome
cuf=$fhome
fPID=$fhome"abot3_pid.txt"
#sender_id=$fhome"sender_id.txt"


function Init() 
{
[ "$lev_log" == "1" ] && logger "Init"
regim=$(sed -n 3"p" $fhome"sett.conf" | tr -d '\r')
proxy=$(sed -n 5"p" $ftb"sett.conf" | tr -d '\r')
sec=$(sed -n 6"p" $fhome"sett.conf" | tr -d '\r')
em=$(sed -n 8"p" $fhome"sett.conf" | tr -d '\r')
bui=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
ssec=$(sed -n 12"p" $fhome"sett.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
tst=$(sed -n 16"p" $fhome"sett.conf" | tr -d '\r')
#portapi=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
#ipapi=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $ftb"sett.conf" | tr -d '\r')
sty=$(sed -n 20"p" $ftb"sett.conf" | tr -d '\r')

promapi=$(sed -n 21"p" $ftb"sett.conf" | tr -d '\r')
label1=$(sed -n 22"p" $ftb"sett.conf" | tr -d '\r')
groupp=$(sed -n 23"p" $ftb"sett.conf" | tr -d '\r')

#sm=$(sed -n 24"p" $ftb"sett.conf" | tr -d '\r')
pappi=$(sed -n 25"p" $ftb"sett.conf" | tr -d '\r')
pappi1=0	#1-уже сработал, 0-не сработал
pappiOK=0	#сообщение о восстановлении pappi
special_mute=0

mdt_start=$(sed -n 26"p" $ftb"sett.conf" | sed 's/\://g' | tr -d '\r')
mdt_end=$(sed -n 27"p" $ftb"sett.conf" | sed 's/\://g' | tr -d '\r')

kkik=0
kkik1=0
bic="0"
styc="0"

snu=0	#номер файла sender_queue
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" abot3_"$bui": "$1
}



function alert_bot()
{
local str_col=0
#[ "$lev_log" == "1" ] && logger "prom api checks"

autohcheck;
if [ "$autohcheck_rez" -eq "0" ]; then
	if [ -z "$proxy" ]; then
		curl -k -s -m 4 "$promapi" | jq '.' > $fhome"a3.txt"
	else
		curl -k -s -m 4 --proxy $proxy "$promapi" | jq '.' > $fhome"a3.txt"
	fi
[ "$lev_log" == "1" ] && cat $fhome"a3.txt"
if [ $(grep -c '\"status\"\: \"success\"' $fhome"a3.txt" ) -eq "1" ]; then
logger "status success"
str_col=$(grep -cv "^---" $fhome"a3.txt")
logger "bot api str_col="$str_col

if [ "$str_col" -gt "6" ]; then
num_alerts=$(grep -c 'alertname' $fhome"a3.txt" )
echo "" > $fhome"newalerts.txt"
redka;
fi

comm_vessels;
fi
fi


#[ "$lev_log" == "1" ] && logger "prom api checks end"

}


function gen_id_alert() 
{

oldid=$(sed -n 1"p" $fhome"id.txt" | tr -d '\r')
newid=$((oldid+1))
echo $newid > $fhome"id.txt"
newid1=$newid
#! [ "$urler" == "no" ] && newid1='<b><a href="'$urler'" target="_blank">'$newid'</a></b>'

}


function redka()
{
special_mute=1
[ "$lev_log" == "1" ] && logger "start redka"
logger "redka num_alerts="$num_alerts

for (( i1=0;i1<$num_alerts;i1++)); do
rm -f $f_send

bic="0"
styc="0"
code2=""

state=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].state' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
if [ "$state" == "firing" ]; then

alertname=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.alertname' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
groupp1=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.'${label1}'' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
inst=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.instance' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
jober=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.job' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
severity=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.severity' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
urler=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.url' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
desc=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/UTC/ /g' | sed 's/+0000/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
unic=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].annotations.unicum'`

[ "$urler" == "null" ] && urler=""

[ "$lev_log" == "1" ] && logger "redka i1="$i1
[ "$lev_log" == "1" ] && logger "redka alertname="$alertname
[ "$lev_log" == "1" ] && logger "redka groupp1="$groupp1
[ "$lev_log" == "1" ] && logger "redka severity="$severity
[ "$lev_log" == "1" ] && logger "redka inst="$inst
[ "$lev_log" == "1" ] && logger "redka jober="$jober
[ "$lev_log" == "1" ] && logger "redka desc="$desc
[ "$lev_log" == "1" ] && logger "redka unic="$unic
[ "$lev_log" == "1" ] && logger "redka urler="$urler

if [ "$severity" != "keepalive" -a "$groupp" == "$groupp1" ]; then

finger=$(echo -n $alertname$inst$jober$severity$unic | md5sum | awk '{print $1}')
echo $finger >> $fhome"newalerts.txt"

[ "$severity" == "info" ] && styc="1" && code2=$(echo "<b><a href=\"$urler\" target=\"_blank\">&#9898;</a></b>")
[ "$severity" == "warning" ] && styc="2" && code2=$(echo "<b><a href=\"$urler\" target=\"_blank\">&#x1F7E1;</a></b>")
[ "$severity" == "average" ] && styc="3" && code2=$(echo "<b><a href=\"$urler\" target=\"_blank\">&#x1F7E0;</a></b>")
[ "$severity" == "high" ] && styc="4" && code2=$(echo "<b><a href=\"$urler\" target=\"_blank\">&#128308;</a></b>")
[ "$severity" == "disaster" ] && styc="5" && code2=$(echo "<b><a href=\"$urler\" target=\"_blank\">&#128996;</a></b>")

severity1=""
severity2=", severity: "$severity
[ "$sty" == "2" ] && severity1=$severity2


desc3=""
if ! [ -z "$tst" ]; then
desc1=$(echo $desc | awk -F", ${tst}:" '{print $1}')
desc2=$(echo $desc | awk -F", ${tst}:" '{print $2}'| awk -F"." '{print $1}')
desc=$desc1
desc3=", "$tst":"$desc2 #Started at 
desc4=", Started at "$desc2
[ "$lev_log" == "1" ] && logger "redka new desc="$desc
fi

logger "redka finger="$finger
if ! [ "$(grep $finger $fhome"alerts.txt")" ]; then
	logger "- new alert"
	if ! [ "$(grep $finger $fhome"delete.txt")" ]; then
		[ "$lev_log" == "1" ] && logger "-1"
		gen_id_alert;
		[ "$bicons" == "1" ] && bic="1"
		echo $newid1" "$finger >> $fhome"alerts.txt"
		logger "redka newid1="$newid1
		
		[ "$sty" == "0" ] && echo $newid1" "$desc$desc4 >> $fhome"alerts2.txt"
		[ "$sty" == "1" ] && echo $code2$newid1" "$desc$desc4 >> $fhome"alerts2.txt"
		[ "$sty" == "2" ] && echo $newid1" "$desc$severity1$desc4 >> $fhome"alerts2.txt"
		
		[ "$bicons" == "0" ] && [ "$sty" == "0" ] && echo "[ALERT] "$newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "0" ] && [ "$sty" == "1" ] && echo "[ALERT] "$newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "0" ] && [ "$sty" == "2" ] && echo "[ALERT] "$newid1" "$desc$severity1$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "0" ] && echo $newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "1" ] && echo $code2$newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "2" ] && echo $newid1" "$desc$severity1$desc3 >> $f_send
		
		[ "$em" == "1" ] && echo "[ALERT] Problem "$newid1$severity2 > $fhome"mail.txt" && echo "[ALERT] "$newid1" "$desc$desc3 >> $fhome"mail.txt" && $ftb"sendmail.sh"
		
		#silent_mode
		silent_mode;
		s_url=$urler
		if [ "$silent_mode" == "on" ]; then
		[ "$severity" == "high" ] && s_mute=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r') && to_send;
		[ "$severity" == "disaster" ] && s_mute=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r') && to_send;
		else
		s_mute=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r')
		to_send;
		fi
		
	else
	logger "finger "$finger" already removed earlier"
	fi
else
logger "finger "$finger" is already in alerts"
fi
fi

fi	#state=firing


done

#to_send;

}


resolv_sever2()
{
smt1=""; smt2=""; smt3=""; smt4=""
smt1=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#128996;" )
! [ -z "$smt1" ] && severity2=", severity: disaster"
smt2=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#128308;" )
! [ -z "$smt2" ] && severity2=", severity: high"
smt3=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: high" )
! [ -z "$smt3" ] && severity2=", severity: high"
smt4=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: disaster" )
! [ -z "$smt4" ] && severity2=", severity: disaster"

smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#9898;" )
! [ -z "$smt0" ] && severity2=", severity: info"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#x1F7E1;" )
! [ -z "$smt0" ] && severity2=", severity: warning"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#x1F7E0;" )
! [ -z "$smt0" ] && severity2=", severity: average"
smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: high" )

smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: info" )
! [ -z "$smt0" ] && severity2=", severity: info"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: warning" )
! [ -z "$smt0" ] && severity2=", severity: warning"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: average" )
! [ -z "$smt0" ] && severity2=", severity: average"
}


comm_vessels()
{
local str_col=0
special_mute=2
[ "$lev_log" == "1" ] && logger "comm_vessels checks"
cp -f $fhome"alerts.txt" $fhome"alerts_old.txt"
str_col=$(grep -cv "^---" $fhome"alerts_old.txt")
logger "comm_vessels alerts_old str_col="$str_col
for (( i=1;i<=$str_col;i++)); do
	rm -f $f_send
	test=$(sed -n $i"p" $fhome"alerts_old.txt" | awk '{print $2}' | tr -d '\r')
	num=$(grep -n "$test" $fhome"newalerts.txt" | awk -F":" '{print $1}')
	[ "$lev_log" == "1" ] && logger "comm_vessels test="$test
	[ "$lev_log" == "1" ] && logger "comm_vessels num="$num
	if [ -z "$num" ]; then
		[ "$lev_log" == "1" ] && logger "comm_vessels check "$test" in newalerts.txt not found"
		
		testid=$(sed -n $i"p" $fhome"alerts_old.txt" | awk '{print $1}' | tr -d '\r')
		num1=$(grep -n "$test" $fhome"alerts.txt" | awk -F":" '{print $1}')
		num2=$(grep -n "$testid" $fhome"alerts2.txt" | awk -F":" '{print $1}')
		[ "$lev_log" == "1" ] && logger "comm_vessels testid="$testid
		[ "$lev_log" == "1" ] && logger "comm_vessels num1="$num1
		[ "$lev_log" == "1" ] && logger "comm_vessels num2="$num2
		
		#---resolved
		[ "$bicons" == "1" ] && bic="2"
		[ "$lev_log" == "1" ] && logger "comm_vessels resolved bic="$bic
		
		desc4=$(sed -n $num2"p" $fhome"alerts2.txt" | tr -d '\r')
		[ "$lev_log" == "1" ] && logger "comm_vessels resolved desc4="$desc4
		local date2=`date '+ %Y-%m-%d %H:%M:%S'`
		desc3=", timestamp: "$date2
		[ "$bicons" == "0" ] && echo "[OK] "$desc4$desc3 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk '{print $2}')
		[ "$bicons" != "0" ] && echo $desc4$desc3 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk -F"</b>" '{print $2}' | awk '{print $1}')
		logger "comm_vessels resolved idprob="$idprob" finger="$test
		
		resolv_sever2;
		[ "$lev_log" == "1" ] && logger "comm_vessels resolv_sever2"
		desc4=$(sed -n $num2"p" $fhome"alerts2.txt" | tr -d '\r' | awk -F"</b>" '{print $2}')
		[ "$lev_log" == "1" ] && logger "comm_vessels resolved desc4="$desc4
		[ "$em" == "1" ] && echo "[OK] Resolved "$idprob$severity2 > $fhome"mail.txt" && echo "[OK] "$desc4$desc3 >> $fhome"mail.txt" && $ftb"sendmail.sh"
		
		
		#silent_mode
		silent_mode;
		if [ "$silent_mode" == "on" ]; then
		logger "comm_vessels resolved smt1="$smt1", smt2="$smt2", smt3="$smt3", smt4="$smt4
		! [ -z "$smt1" ] || ! [ -z "$smt2" ] || ! [ -z "$smt3" ] || ! [ -z "$smt4" ] && s_mute=$(sed -n 31"p" $ftb"sett.conf" | tr -d '\r') && to_send;
		else
			[ "$lev_log" == "1" ] && logger "comm_vessels to_send"
			s_mute=$(sed -n 31"p" $ftb"sett.conf" | tr -d '\r')
			! [ -z "$testid" ] && to_send
			#to_send;
		fi
		
		#resolved---
		
		str_col1=$(grep -cv "^---" $fhome"alerts.txt")
		str_col2=$(grep -cv "^---" $fhome"alerts2.txt")
		
		head -n $((num1-1)) $fhome"alerts.txt" > $fhome"alerts1_tmp.txt"
		tail -n $((str_col1-num1)) $fhome"alerts.txt" >> $fhome"alerts1_tmp.txt"
		cp -f $fhome"alerts1_tmp.txt" $fhome"alerts.txt"
		
		head -n $((num2-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num2)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
	else
		[ "$lev_log" == "1" ] && logger "comm_vessels check "$test" in newalerts.txt detected"
	fi

done

echo "" > $fhome"newalerts.txt"
}


silent_mode ()
{
local sm=0
silent_mode="off"
[ "$lev_log" == "1" ] && logger "--------------silent_mode------------------"
sm=$(sed -n 24"p" $ftb"sett.conf" | tr -d '\r')
if [ "$sm" == "1" ]; then
		mdt1=$(date '+%H:%M:%S' | sed 's/\://g' | tr -d '\r')
		[ "$lev_log" == "1" ] && logger "silent_mode mdt1="$mdt1
		[ "$lev_log" == "1" ] && logger "silent_mode mdt_start="$mdt_start
		[ "$lev_log" == "1" ] && logger "silent_mode mdt_end="$mdt_end
		if [ "$mdt1" \> "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]; then
			silent_mode="on"
		fi
fi
logger "silent_mode="$silent_mode

}



function to_send()
{
[ "$lev_log" == "1" ] && logger "start to_send"

regim=$(sed -n 3"p" $ftb"sett.conf" | tr -d '\r')

if [ -f $f_send ]; then
	if [ "$regim" == "1" ]; then
		logger "Regim ON"
		otv=$f_send
		send
		rm -f $f_send
	fi
fi

}


sender_queue ()
{
#snu=$(sed -n 1"p" $sender_id | tr -d '\r')
#snu=$((snu+1))
#echo $snu > $sender_id

snu="B_"$(date +%s)
logger "sender_queue snu="$snu
}


send1 () 
{

logger "send1 start-------------------------------------------------------"
#special_mute=1 alerts; =2 resolv 

#mute mask alerts
if [ "$special_mute" -eq "1" ] && [ "$(sed -n 32"p" $ftb"sett.conf" | tr -d '\r')" -eq "1" ] && ! [ -z "$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')" ]; then
	[ "$(cat $otv | grep -cE "$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')")" -gt "0" ] && s_mute=1 && logger "mute alerts-------------------------------------------------------"
fi
#mute mask resolv
if [ "$special_mute" -eq "2" ] && [ "$(sed -n 34"p" $ftb"sett.conf" | tr -d '\r')" -eq "1" ] && ! [ -z "$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')" ]; then
	[ "$(cat $otv | grep -cE "$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')")" -gt "0" ] && s_mute=1 && logger "mute resolv-------------------------------------------------------"
fi

sender_queue
echo $fhsender2$snu".txt" > $fhome"sender3.txt"
echo $bic >> $fhome"sender3.txt"							#спец картинок в уведомлениях 0-2
echo $styc >> $fhome"sender3.txt"							#показ спец картинок severity 0-6
echo $s_url >> $fhome"sender3.txt"							#урл
echo $s_mute >> $fhome"sender3.txt"							#mute

mv -f $otv $fhsender2$snu".txt"
mv -f $fhome"sender3.txt" $fhsender1$snu".txt"

logger "send1 end-------------------------------------------------------"
}



send ()
{
logger "send start"

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	sv=$((sv+1))
	echo "sv="$sv
	$ftb"rex3.sh" $otv
	logger "obrezka3"
	for (( i=1;i<=$sv;i++)); do
		otv=$fhome"rez3"$i".txt"
		send1;
		rm -f $fhome"rez3"$i".txt"
	done
	
else
	send1;
fi
}


#pauseloop ()  		
#{
#sec1=0
#rm -f $file
#again0="yes"
#while [ "$again0" = "yes" ]
#do
#sec1=$((sec1+1))
#sleep 1
#if [ -f $file ] || [ "$sec1" -eq "$sec" ]; then
#	again0="go"
#	[ "$lev_log" == "1" ] && logger "pauseloop sec1="$sec1
#fi
#done
#}



autohcheck ()
{
autohcheck_rez=$(curl -I -k -m 4 "$promapi" 2>&1 | grep -cE 'Failed')
echo $autohcheck_rez > $ftb"prom_api_status.txt"

if [ "$autohcheck_rez" -eq "1" ]; then
  logger "autohcheck prom api Failed"
  pappi=$(sed -n 25"p" $ftb"sett.conf" | tr -d '\r')
  [ "$pappi" -eq "0" ] && pappi1=0
  
  if [ "$pappi" -gt "0" ]; then
	logger "pappi>0"
	if [ "$pappi1" -eq "0" ]; then
		dtna=`date -d "$RTIME $pappi min" '+ %Y%m%d%H%M%S'`
		echo $dtna > $fhome"napip.txt"
		pappi1=1
		logger "pappi1=1"
	else
		logger "pappi1>0"
		dtna1=$(echo $(date '+ %Y%m%d%H%M%S') | sed 's/z/-/g' | tr -d '\r')
		#echo $(date '+ %Y%m%d%H%M%S') > $fhome"napip1.txt"
		#dtna1=$(sed -n 1"p" $fhome"napip1.txt" | sed 's/z/-/g' | tr -d '\r')
		dtna=$(sed -n 1"p" $fhome"napip.txt" | sed 's/z/-/g' | tr -d '\r')
		logger "dtna="$dtna
		logger "dtna1="$dtna1
	
		if [ "$dtna1" -gt "$dtna" ]; then
			logger "dtna1="$dtna1" > dtna="$dtna
			echo "Prom API down "$pappi" min" > $fhome"pappi.txt"
			pappi1=0
			logger "pappi1=0"
			echo > $fhome"alerts.txt"
			echo > $fhome"alerts2.txt"
			otv=$fhome"pappi.txt"
			[ "$bicons" == "1" ] && bic="1"
			s_mute=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
			#sys
			[ "$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')" == "1" ] && s_mute="1"
			send;
			pappiOK=1
		else 
			logger ">"
		fi
	fi
  fi
else
	logger "autohcheck prom api OK"
	pappi1=0
	if [ "$pappiOK" -eq "1" ]; then
		echo "Prom API up" > $fhome"pappi.txt"
		otv=$fhome"pappi.txt"
		[ "$bicons" == "1" ] && bic="2"
		s_mute=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
		#sys
		[ "$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')" == "1" ] && s_mute="1"
		send;
		pappiOK=0
	fi
fi

}


PID=$$
echo $PID > $fPID
logger "start abot3"
Init;

while true
do
sleep $ssec
alert_bot;
#to_send;
kkik=$(($kkik+1))
[ "$kkik" -ge "$progons" ] && Init

#kkik1=$((kkik%5))
#[ "$kkik1" -eq "0" ] && autohcheck

done



rm -f $fPID

