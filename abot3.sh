#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#переменные
fhome=/usr/share/abot2/
fhsender=$fhome"sender/"
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
fstat=$fhome"stat/"
f_send=$fhome"send_abot3.txt"
ftb=$fhome
cuf=$fhome
lev_log=$(sed -n 14"p" $ftb"sett.conf" | tr -d '\r')
fPID=$fhome"abot3_pid.txt"
fpost_home=/home/en/fetchmail/
fpost_new=/home/en/fetchmail/mail/new/
fpost_cur=/home/en/fetchmail/mail/cur/
fpost_tmp=/home/en/fetchmail/mail/tmp/
col_alert_in=$(sed -n 1"p" $fstat"stat_alert_in.txt" | tr -d '\r')		#stat alert in



function Init() 
{
[ "$lev_log" == "1" ] && logger "Init"
regim=$(sed -n 3"p" $fhome"sett.conf" | tr -d '\r')
proxy=$(sed -n 5"p" $ftb"sett.conf" | tr -d '\r')
sec=$(sed -n 6"p" $fhome"sett.conf" | tr -d '\r')

em=$(sed -n 8"p" $fhome"sett.conf" | tr -d '\r')
	smtp_hostname=$(sed -n 36"p" $fhome"sett.conf" | tr -d '\r')
	smtp_sport=$(sed -n 37"p" $fhome"sett.conf" | tr -d '\r')
	smtp_user=$(sed -n 38"p" $fhome"sett.conf" | tr -d '\r')
	smtp_pass=$(sed -n 39"p" $fhome"sett.conf" | tr -d '\r')

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

chm=$(sed -n 40"p" $ftb"sett.conf" | tr -d '\r')

#mutejf=$(sed -n 49"p" $ftb"sett.conf" | tr -d '\r')
#mutej_onof=$(sed -n 67"p" $ftb"sett.conf" | tr -d '\r')

rm -f $fhome"alerts3.txt"
rm -f $fhome"alerts4.txt"

kkik=0
kkik1=0
bic="0"
styc="0"

snu=0	#номер файла sender_queue
}


function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" abot3_"$bui": "$1
}



function alert_bot()
{
logger "alert_bot"
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
logger "alert_bot GET status success"
str_col=$(grep -cv "^---" $fhome"a3.txt")
logger "alert_bot bot api str_col="$str_col

if [ "$str_col" -gt "6" ]; then
num_alerts=$(grep -c 'alertname' $fhome"a3.txt" )
echo "" > $fhome"newalerts.txt"
redka;
fi

[ "$str_col" -gt "6" ] && comm_vessels;
fi
fi


#[ "$lev_log" == "1" ] && logger "prom api checks end"

}


#==========================================================================================================================
check_mail ()
{
local tmp=0
local tmp1=""
local a=0

logger " "
logger "check_mail start"
#cd $fpost_new; fetchmail -v -f $fpost_home"fetchmail.conf"
su en -c 'cd $fpost_new; fetchmail -v -f /home/en/fetchmail/fetchmail.conf' -s /bin/bash

find $fpost_new -maxdepth 1 -type f > $fhome"post_in.txt"
str_col11=$(grep -c '' $fhome"post_in.txt")
logger "check_mail str_col11="$str_col11


if [ "$str_col11" -gt "0" ]; then

	for (( i8=1;i8<=$str_col11;i8++)); do
	test_post=$(sed -n $i8"p" $fhome"post_in.txt" | tr -d '\r')
	logger "check_mail test_post="$test_post
	
	tmp=$(grep -c "\[FIRING:" $test_post)
	[ "$tmp" -gt "0" ] && a=1
	tmp=$(grep -c "\[RESOLVED\]" $test_post)
	[ "$tmp" -gt "0" ] && a=2
	
	tmp=$(grep -c "start|" $test_post)

	if [ "$tmp" -gt "0" ]; then
	tmp1=$(grep -m1 -A7 "start|" $test_post | sed 's/=//g' | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\n\r')
	
	alertname=$(echo $tmp1 | awk -F'|' '{print $2}' | tr -d '\r')
	groupp1=$(echo $tmp1 | awk -F'|' '{print $3}' | tr -d '\r')
	inst=$(echo $tmp1 | awk -F'|' '{print $4}' | tr -d '\r')
	jober=$(echo $tmp1 | awk -F'|' '{print $5}' | tr -d '\r')
	severity=$(echo $tmp1 | awk -F'|' '{print $6}' | tr -d '\r')
	urler=$(echo $tmp1 | awk -F'|' '{print $7}' | tr -d '\r')
	desc=$(echo $tmp1 | awk -F'|' '{print $8}' | tr -d '\r')
	unic=$(echo $tmp1 | awk -F'|' '{print $9}' | tr -d '\r')
	#finger=$(echo -n $alertname$inst$jober$severity$unic | md5sum | awk '{print $1}')
	
	[ "$a" -eq "1" ] && logger "check_mail [ALERT]"
	[ "$a" -eq "2" ] && logger "check_mail [RESOLVED]"
	! [ -z "$tst" ] && desc=$desc", "$tst": "$(date '+ %Y-%m-%d %H:%M:%S')			#2023-11-09 23:43:23
	
	logger "check_mail alertname="$alertname
	logger "check_mail groupp1="$groupp1
	logger "check_mail inst="$inst
	logger "check_mail jober="$jober
	logger "check_mail severity="$severity
	logger "check_mail urler="$urler
	logger "check_mail desc="$desc
	logger "check_mail unic="$unic
	#logger "check_mail finger="$finger
	
	[ "$a" -eq "1" ] && fromm="m" && redka2;
	[ "$a" -eq "2" ] && resolved_mail;
	
	mv -f $test_post $fpost_tmp
	else
		logger "check_mail ERROR: find start"
		mv -f $test_post $fpost_cur
	fi
	done
else
	logger "check_mail ERROR: no post data";
fi

}
#==========================================================================================================================


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

state=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].state' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
if [ "$state" == "firing" ]; then

alertname=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.alertname' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
groupp1=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.'${label1}'' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
inst=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.instance' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
jober=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.job' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
severity=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.severity' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
urler=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.url' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
desc=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/UTC/ /g' | sed 's/+0000/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
unic=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].annotations.unicum')

webhook=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.webhook' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
annot_url=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.annot_url' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
annot_text=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.annot_text' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
annot_tag=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.annot_tag' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
annot_atoken=$(cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.annot_atoken' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')

[ "$urler" == "null" ] && urler=""
[ "$webhook" == "null" ] && webhook=""
[ "$annot_url" == "null" ] && annot_url=""
[ "$annot_text" == "null" ] && annot_text=""
[ "$annot_tag" == "null" ] && annot_tag=""
[ "$annot_atoken" == "null" ] && annot_atoken=""

[ "$lev_log" == "1" ] && logger "redka i1="$i1
[ "$lev_log" == "1" ] && logger "redka alertname="$alertname
[ "$lev_log" == "1" ] && logger "redka groupp1="$groupp1
[ "$lev_log" == "1" ] && logger "redka severity="$severity
[ "$lev_log" == "1" ] && logger "redka inst="$inst
[ "$lev_log" == "1" ] && logger "redka jober="$jober
[ "$lev_log" == "1" ] && logger "redka desc="$desc
[ "$lev_log" == "1" ] && logger "redka unic="$unic
[ "$lev_log" == "1" ] && logger "redka urler="$urler

[ "$lev_log" == "1" ] && logger "redka webhook="$webhook
[ "$lev_log" == "1" ] && logger "redka annot_url="$annot_url
[ "$lev_log" == "1" ] && logger "redka annot_text="$annot_text
[ "$lev_log" == "1" ] && logger "redka annot_tag="$annot_tag
[ "$lev_log" == "1" ] && logger "redka annot_atoken="$annot_atoken

#-----------------процедура-------
fromm="t"
redka2;
#--------------------процедура-------

fi	#state=firing
done
#to_send;
}


function redka2()
{
logger "redka2"
bic="0"
styc="0"
code2=""

if [ "$severity" != "keepalive" -a "$groupp" == "$groupp1" ]; then

finger=$(echo -n $alertname$inst$jober$severity$unic | md5sum | awk '{print $1}')
echo $finger >> $fhome"newalerts.txt"
logger "redka2 finger="$finger

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
[ "$lev_log" == "1" ] && logger "redka2 new desc="$desc
fi

logger "redka2 finger="$finger
if ! [ "$(grep $finger $fhome"alerts.txt")" ]; then
	logger "- new alert"
	#if ! [ "$(grep $finger $fhome"delete.txt")" ]; then		#более не используется com_mutej
		[ "$lev_log" == "1" ] && logger "-1"
		gen_id_alert;
		[ "$bicons" == "1" ] && bic="1"
		echo $newid1" "$finger >> $fhome"alerts.txt"
		logger "redka2 newid1="$newid1
		
		[ "$sty" == "0" ] && echo $newid1" "$desc$desc4 >> $fhome"alerts2.txt"
		[ "$sty" == "1" ] && echo $code2$newid1" "$desc$desc4 >> $fhome"alerts2.txt"
		[ "$sty" == "2" ] && echo $newid1" "$desc$severity1$desc4 >> $fhome"alerts2.txt"
		
		[ "$regim" == "1" ] && [ "$silent_mode" == "on" ] && ! [ "$severity" == "high" ] && ! [ "$severity" == "disaster" ] && add_alerts34;
		
		[ "$bicons" == "0" ] && [ "$sty" == "0" ] && echo "[ALERT] "$newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "0" ] && [ "$sty" == "1" ] && echo "[ALERT] "$newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "0" ] && [ "$sty" == "2" ] && echo "[ALERT] "$newid1" "$desc$severity1$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "0" ] && echo $newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "1" ] && echo $code2$newid1" "$desc$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "2" ] && echo $newid1" "$desc$severity1$desc3 >> $f_send
		
		[ "$em" == "1" ] && MSUBJ="[ALERT] Problem "$newid1$severity2 && MBODY="[ALERT] "$newid1" "$desc$desc3 && smail;
		! [ -z "$webhook" ] && webhooker;
		! [ -z "$annot_url" ] && annoter;
		
		[ "$fromm" == "m" ] && echo $finger >> $fhome"alerts_mail.txt"
		cat $fhome"alerts_mail.txt"
		
		#silent_mode
		#silent_mode;
		s_url=$urler
		if [ "$silent_mode" == "on" ]; then
		[ "$severity" == "high" ] && s_mute=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r') && to_send;
		[ "$severity" == "disaster" ] && s_mute=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r') && to_send;
		else
		s_mute=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r')
		to_send;
		fi
	#else
	#logger "redka2 finger "$finger" already removed earlier"
	#fi
else
logger "redka2 finger "$finger" is already in alerts"
fi
fi

}


annoter ()
{
logger "annoter start "$finger
cp -f $fhome"0.sh" $fhome"annot/annot_"$finger".sh"

echo "curl -X POST "$annot_url" \\" >> $fhome"annot/annot_"$finger".sh"
echo "  -H 'Content-Type: application/json' \\" >> $fhome"annot/annot_"$finger".sh"
echo "  -H 'Authorization: Bearer "$annot_atoken"' \\" >> $fhome"annot/annot_"$finger".sh"
echo "--data '{" >> $fhome"annot/annot_"$finger".sh"
echo "\"text\": \""$annot_text"\"," >> $fhome"annot/annot_"$finger".sh"
echo "\"tags\": [\""$annot_tag"\"]" >> $fhome"annot/annot_"$finger".sh"
echo "  }' 1>"$fhome"annot/annot_"$finger".log 2>>"$fhome"annot/annot_"$finger".log" >> $fhome"annot/annot_"$finger".sh"

chmod +rx $fhome"annot/annot_"$finger".sh"
$fhome"annot/annot_"$finger".sh" &
}


webhooker()
{
logger "webhooker start "$finger
cp -f $fhome"0.sh" $fhome"wh/webhooker_"$finger".sh"
echo "curl -s -L -k -m 13 "$webhook" 1>"$fhome"wh/webhooker_"$finger".log 2>>"$fhome"wh/webhooker_"$finger".log" >> $fhome"wh/webhooker_"$finger".sh"
chmod +rx $fhome"wh/webhooker_"$finger".sh"
$fhome"wh/webhooker_"$finger".sh" &
}



smail()
{
if ! [ "$smtp_hostname" == "" ] && ! [ "$smtp_sport" == "" ] && ! [ "$smtp_user" == "" ] && ! [ "$smtp_pass" == "" ]; then
logger "smail"
cp -f $fhome"sendmail_tmp.sh" $fhome"sendmail.sh"

to_mail=$(sed -n 41"p" $fhome"sett.conf" | tr -d '\r')

if ! [ "$to_mail" == "" ]; then
	for MADDR in $(echo $to_mail | tr " " "\n")
	do
	logger "smail send mail to "$MADDR
	
	echo "su monitoring -c 'cd; echo \""$MBODY"\" | mail -s \""$MSUBJ"\" "$MADDR"' -s /bin/bash" >> $fhome"sendmail.sh"
	
	done
else
	logger "smail to_mail is NULL"
fi

chmod +rx $fhome"sendmail.sh"
$fhome"sendmail.sh"
fi
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
	num=$(grep -n "$test" $fhome"newalerts.txt" | awk -F":" '{print $1}' | tr -d '\r')
	[ "$lev_log" == "1" ] && logger "comm_vessels test="$test
	[ "$lev_log" == "1" ] && logger "comm_vessels num="$num
	if [ -z "$num" ] && [ "$(grep -c $test $fhome"alerts_mail.txt")" -eq "0" ]; then
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
		local date2=$(date '+ %Y-%m-%d %H:%M:%S')
		desc3=", timestamp: "$date2
		[ "$bicons" == "0" ] && echo "[OK] "$desc4$desc3 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk '{print $2}')
		[ "$bicons" != "0" ] && echo $desc4$desc3 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk -F"</b>" '{print $2}' | awk '{print $1}')
		logger "comm_vessels resolved idprob="$idprob" finger="$test
		
		resolv_sever2;
		[ "$lev_log" == "1" ] && logger "comm_vessels resolv_sever2"
		desc4=$(sed -n $num2"p" $fhome"alerts2.txt" | tr -d '\r' | awk -F"</b>" '{print $2}')
		[ "$lev_log" == "1" ] && logger "comm_vessels resolved desc4="$desc4
		[ "$em" == "1" ] && MSUBJ="[OK] Resolved "$idprob$severity2 && MBODY="[OK] "$desc4$desc3 && smail;
		
		
		#silent_mode
		#silent_mode;
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
		
		str_col11=$(grep -cv "^---" $fhome"alerts.txt")
		str_col2=$(grep -cv "^---" $fhome"alerts2.txt")
		
		head -n $((num1-1)) $fhome"alerts.txt" > $fhome"alerts1_tmp.txt"
		tail -n $((str_col11-num1)) $fhome"alerts.txt" >> $fhome"alerts1_tmp.txt"
		cp -f $fhome"alerts1_tmp.txt" $fhome"alerts.txt"
		
		head -n $((num2-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num2)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		resolv_alerts34;
	else
		[ "$lev_log" == "1" ] && logger "comm_vessels check "$test" in newalerts.txt detected"
	fi

done

echo "" > $fhome"newalerts.txt"
}


function add_alerts34()
{
[ "$lev_log" == "1" ] && logger "add_alerts34 "$newid1" "$finger
echo $newid1" "$finger >> $fhome"alerts3.txt"
[ "$sty" == "0" ] && echo $newid1" "$desc$desc4 >> $fhome"alerts4.txt"
[ "$sty" == "1" ] && echo $code2$newid1" "$desc$desc4 >> $fhome"alerts4.txt"
[ "$sty" == "2" ] && echo $newid1" "$desc$severity1$desc4 >> $fhome"alerts4.txt"
}
function resolv_alerts34()
{
[ "$lev_log" == "1" ] && logger "resolv_alerts34"

if [ "$regim" == "1" ] && [ "$silent_mode" == "on" ]; then
num1=$(grep -n "$test" $fhome"alerts3.txt" | awk -F":" '{print $1}')
#num1id=$(grep "$test" $fhome"alerts3.txt" | awk -F":" '{print $1}')
#num2=$(grep -n "$num1id" $fhome"alerts4.txt" | awk -F":" '{print $1}')
num2=$num1
[ "$lev_log" == "1" ] && logger "resolv_alerts34 test="$test" num1="$num1" num2="$num2

if ! [ -z "$num1" ] && ! [ -z "$num2" ]; then
		#resolved---
		
		str_col11=$(grep -c '' $fhome"alerts3.txt")
		str_col2=$(grep -c '' $fhome"alerts4.txt")
		[ "$lev_log" == "1" ] && logger "resolv_alerts34 str_col11="$str_col11" str_col2="$str_col2
		
		head -n $((num1-1)) $fhome"alerts3.txt" > $fhome"alerts3_tmp.txt"
		tail -n $((str_col11-num1)) $fhome"alerts3.txt" >> $fhome"alerts3_tmp.txt"
		cp -f $fhome"alerts3_tmp.txt" $fhome"alerts3.txt"
		
		head -n $((num2-1)) $fhome"alerts4.txt" > $fhome"alerts4_tmp.txt"
		tail -n $((str_col2-num2)) $fhome"alerts4.txt" >> $fhome"alerts4_tmp.txt"
		cp -f $fhome"alerts4_tmp.txt" $fhome"alerts4.txt"
fi
fi
}
function resolv_alerts34_mail()
{
idfp=$(grep $finger $fhome"alerts3.txt" | awk '{print $1}' | tr -d '\r')
numfp1=$(grep -n $finger $fhome"alerts3.txt" | awk -F':' '{print $1}' | tr -d '\r')
numfp2=$(grep -n $idfp $fhome"alerts4.txt" | awk -F':' '{print $1}' | tr -d '\r')
#numfp2=$numfp1
[ "$lev_log" == "1" ] && logger "resolv_alerts34_mail finger="$finger" idfp="$idfp" numfp1="$numfp1" numfp2="$numfp2

if ! [ -z "$numfp1" ] && ! [ -z "$numfp2" ]; then
	#resolved---
	
	col1=$(grep -c '' $fhome"alerts3.txt")
	col2=$(grep -c '' $fhome"alerts4.txt")
	[ "$lev_log" == "1" ] && logger "resolv_alerts34_mail col1="$col1" col2="$col2
	
	head -n $((numfp1-1)) $fhome"alerts3.txt" > $fhome"alerts3_tmp.txt"
	tail -n $((col1-numfp1)) $fhome"alerts3.txt" >> $fhome"alerts3_tmp.txt"
	cp -f $fhome"alerts3_tmp.txt" $fhome"alerts3.txt"
	
	head -n $((numfp2-1)) $fhome"alerts4.txt" > $fhome"alerts4_tmp.txt"
	tail -n $((col2-numfp2)) $fhome"alerts4.txt" >> $fhome"alerts4_tmp.txt"
	cp -f $fhome"alerts4_tmp.txt" $fhome"alerts4.txt"
	
fi
}
send_def ()
{
s_url=""
s_sty=0
s_bic=0
}


resolved_mail () 
{
logger "resolved_mail"
local idfp=""
local descrip1=""
local descrip2=""
local col1=0
local col2=0
local numfp1=0
local numfp2=0
rm -f $f_send

finger=$(echo -n $alertname$inst$jober$severity$unic | md5sum | awk '{print $1}')
logger "resolved_mail finger="$finger

if [ "$(grep -c $finger $fhome"alerts.txt")" -gt "0" ]; then
	idfp=$(grep $finger $fhome"alerts.txt" | awk '{print $1}' | tr -d '\r')
	numfp1=$(grep -n $finger $fhome"alerts.txt" | awk -F':' '{print $1}' | tr -d '\r')
	logger "resolved_mail idfp="$idfp
	numfp2=$(grep -n $idfp $fhome"alerts2.txt" | awk -F':' '{print $1}' | tr -d '\r')
	logger "resolved_mail numfp1="$numfp1", numfp2="$numfp2
	
	[ "$bicons" == "1" ] && bic="2"
	descrip1=$(sed -n $numfp2"p" $fhome"alerts2.txt" | tr -d '\r')
	local date2=$(date '+ %Y-%m-%d %H:%M:%S')
	descrip2=", timestamp: "$date2
	[ "$bicons" == "0" ] && echo "[OK] "$descrip1$descrip2 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk '{print $2}')
	[ "$bicons" != "0" ] && echo $descrip1$descrip2 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk -F"</b>" '{print $2}' | awk '{print $1}')
	logger "resolved_mail idprob="$idprob" finger="$finger
	
	num2=$numfp2
	resolv_sever2;
	
	desc4=$(sed -n $num2"p" $fhome"alerts2.txt" | tr -d '\r' | awk -F"</b>" '{print $2}')
	[ "$em" == "1" ] && MSUBJ="[OK] Resolved "$idprob$severity2 && MBODY="[OK] "$desc4$descrip2 && smail;
	
	#silent_mode
	#silent_mode;
	if [ "$silent_mode" == "on" ]; then
	logger "resolved_mail resolved smt1="$smt1", smt2="$smt2", smt3="$smt3", smt4="$smt4
	! [ -z "$smt1" ] || ! [ -z "$smt2" ] || ! [ -z "$smt3" ] || ! [ -z "$smt4" ] && s_mute=$(sed -n 31"p" $ftb"sett.conf" | tr -d '\r') && to_send;
	else
		[ "$lev_log" == "1" ] && logger "resolved_mail to_send"
		s_mute=$(sed -n 31"p" $ftb"sett.conf" | tr -d '\r')
		! [ -z "$idfp" ] && to_send
		#to_send;
	fi
	
	col1=$(grep -cv "^---" $fhome"alerts.txt")
	col2=$(grep -cv "^---" $fhome"alerts2.txt")
	
	head -n $((numfp1-1)) $fhome"alerts.txt" > $fhome"alerts1_tmp.txt"
	tail -n $((col1-numfp1)) $fhome"alerts.txt" >> $fhome"alerts1_tmp.txt"
	cp -f $fhome"alerts1_tmp.txt" $fhome"alerts.txt"
	
	head -n $((numfp2-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
	tail -n $((col2-numfp2)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
	cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
	
	sed -i "/$finger/d" $fhome"alerts_mail.txt"
	
	[ "$regim" == "1" ] && [ "$silent_mode" == "on" ] && resolv_alerts34_mail;
else
	logger "resolved_mail ERROR id finger not found"
fi

}



silent_mode ()
{
local sm=0
local vivod=0
local silent_mode2=""
silent_mode2=$silent_mode

silent_mode="off"

[ "$lev_log" == "1" ] && logger "--------------silent_mode------------------"
sm=$(sed -n 24"p" $ftb"sett.conf" | tr -d '\r')			#тихий режим по ночам 0-выключен, 1-включен
if [ "$sm" == "1" ]; then
		mdt1=$(date '+%H:%M:%S' | sed 's/\://g' | tr -d '\r')
		[ "$lev_log" == "1" ] && logger "silent_mode mdt1="$mdt1
		[ "$lev_log" == "1" ] && logger "silent_mode mdt_start="$mdt_start
		[ "$lev_log" == "1" ] && logger "silent_mode mdt_end="$mdt_end
		if ([ "$mdt1" \> "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]) || ([ "$mdt1" \< "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]); then
			silent_mode="on"
		fi
		vivod=$(sed -n 69"p" $ftb"sett.conf" | tr -d '\r')		#выводить нерезолвные алерты за время тихого режима
		[ "$silent_mode2" == "on" ] && [ "$silent_mode" == "off" ] && [ "$vivod" == "1" ] && $fhome"job2.sh" && otv=$fhome"job2.txt" && send_def && send2	#вывод в бота alerts4.txt
		[ "$silent_mode2" == "off" ] && [ "$silent_mode" == "on" ] && rm -f $fhome"alerts3.txt" && touch $fhome"alerts3.txt" && rm -f $fhome"alerts4.txt" && touch $fhome"alerts4.txt"
fi
logger "silent_mode="$silent_mode

}



function to_send()
{
[ "$lev_log" == "1" ] && logger "to_send start"

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



send ()
{
logger "send start otv="
local mute_job=0
local gftest1=0
local gftest2=0
local gftest3=0

cat $otv

#special_mute=1 alerts; =2 resolv 

#mute mask alerts
if [ "$special_mute" -eq "1" ]; then
	[ "$lev_log" == "1" ] && logger "send special_mute=1"
	if [ "$(sed -n 32"p" $ftb"sett.conf" | tr -d '\r')" == "1" ]; then
		[ "$lev_log" == "1" ] && logger "send conf32=1"
		if ! [ -z "$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')" ]; then
			[ "$lev_log" == "1" ] && logger "send conf33!=_"
			gftest1=$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')
			gftest2=$(cat $otv | grep -cE $gftest1)
			[ "$lev_log" == "1" ] && logger "send gftest1="$gftest1
			[ "$lev_log" == "1" ] && logger "send gftest2="$gftest2
			if [ "$gftest2" -gt "0" ]; then
				[ "$lev_log" == "1" ] && logger "send otv alert mask >0"
				s_mute=1
			fi
		fi
	fi
fi
#mute mask resolv
if [ "$special_mute" -eq "2" ]; then
	[ "$lev_log" == "1" ] && logger "send special_mute=1"
	if [ "$(sed -n 34"p" $ftb"sett.conf" | tr -d '\r')" == "1" ]; then
		[ "$lev_log" == "1" ] && logger "send conf34=1"
		if ! [ -z "$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')" ]; then
			[ "$lev_log" == "1" ] && logger "send conf35!=_"
			gftest1=$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')
			gftest2=$(cat $otv | grep -cE $gftest1)
			[ "$lev_log" == "1" ] && logger "send gftest1="$gftest1
			[ "$lev_log" == "1" ] && logger "send gftest2="$gftest2
			if [ "$gftest2" -gt "0" ]; then
				[ "$lev_log" == "1" ] && logger "send otv resolv mask >0"
				s_mute=1
			fi
		fi
	fi
fi
logger "send mutej !!!!!!!!!!"
#mutej mask mutejf mutej_onof
mutejf=$(sed -n 49"p" $ftb"sett.conf" | tr -d '\r')
mutej_onof=$(sed -n 67"p" $ftb"sett.conf" | tr -d '\r')
if [ "$mutej_onof" == "1" ]; then
	[ "$lev_log" == "1" ] && logger "send mutej_onof=1"
	logger "send mutejf="$mutejf
	if ! [ -z "$mutejf" ]; then
		gftest3=$(cat $otv | grep -cE $mutejf)
		[ "$lev_log" == "1" ] && logger "send gftest3="$gftest3
		[ "$gftest3" -gt "0" ] && mute_job=1
	fi
fi
[ "$lev_log" == "1" ] && logger "send mute_job="$mute_job
logger "send mutej !!!!!!!"

[ "$mute_job" -eq "0" ] && send2;

}


sender_queue ()
{
#snu=$(sed -n 1"p" $sender_id | tr -d '\r')
#snu=$((snu+1))
#echo $snu > $sender_id

snu="B_"$(date +%s%N)
logger "sender_queue snu="$snu
}


send1 () 
{

logger "send1 start-------------------------------------------------------"
[ "$lev_log" == "1" ] && logger "send1 mute_job="$mute_job

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



send2 ()
{
logger "send2 start"

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	sv=$((sv+1))
	echo "sv="$sv
	$ftb"rex3.sh" $otv
	logger "obrezka3"
	for (( i4=1;i4<=$sv;i4++)); do
		otv=$fhome"rez3"$i4".txt"
		send1;
		rm -f $fhome"rez3"$i4".txt"
	done
	
else
	send1;
fi
}



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
		dtna=$(date -d "$RTIME $pappi min" '+ %Y%m%d%H%M%S')
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
			#echo > $fhome"alerts.txt"
			#echo > $fhome"alerts2.txt"
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
silent_mode;
alert_bot;

[ "$chm" -eq "1" ] && check_mail;

kkik=$(($kkik+1))
[ "$kkik" -ge "$progons" ] && Init

#kkik1=$((kkik%5))
#[ "$kkik1" -eq "0" ] && autohcheck

done



rm -f $fPID

