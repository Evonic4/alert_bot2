#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#переменные
fhome=/usr/share/abot2/
fstat=$fhome"stat/"
fPID=$fhome"hchecker_pid.txt"


function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" hchecker_"$bui": "$1
}


function Init2() 
{
logger "Init2"
bui=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
startid=$(sed -n 9"p" $fhome"sett.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
pushg=$(sed -n 48"p" $fhome"sett.conf" | tr -d '\r')
}


function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" hchecker_"$bui": "$1
}


zapushgateway ()
{
logger "zapushgateway start"

echo "abot2_stat_check_api "$stat_check_api | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
echo "abot2_stat_check_trbot "$stat_check_trbot | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
echo "abot2_stat_check_abot3 "$stat_check_abot3 | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
echo "abot2_stat_check_sender "$stat_check_sender | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui

echo "abot2_stat_send_ok "$stat_send_ok | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
echo "abot2_stat_send_err "$stat_send_err | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
echo "abot2_stat_input_err "$stat_input_err | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
echo "abot2_stat_input_alert "$stat_input_alert | curl -m 4 --data-binary @- "http://"$pushg"/metrics/bot_id/"$bui
}



PID=$$
echo $PID > $fPID
logger "hchecker start"
Init2;

while true
do
sleep 10

#check_api
if [ $(grep -c '\"status\"\: \"success\"' $fhome"a3.txt" ) -eq "1" ]; then
	logger "check_api OK"
	stat_check_api="1"
else
	logger "check_api ERR"
	stat_check_api="0"
fi

ab3p=$(ps axu| awk '{ print $2 }' | grep $(sed -n 1"p" $fhome"abot3_pid.txt"))
trbp=$(ps axu| awk '{ print $2 }' | grep $(sed -n 1"p" $fhome"trbot_pid.txt"))
senderp=$(ps axu| awk '{ print $2 }' | grep $(sed -n 1"p" $fhome"sender_pid.txt"))
if [ -z "$trbp" ]; then
	stat_check_trbot="0"
else
	stat_check_trbot="1"
fi
if [ -z "$ab3p" ]; then
	stat_check_abot3="0"
else
	stat_check_abot3="1"
fi
if [ -z "$senderp" ]; then
	stat_check_sender="0"
else
	stat_check_sender="1"
fi

#telegram
stat_send_ok=$(sed -n 1"p" $fstat"stat_tok_out.txt" | tr -d '\r')
stat_send_err=$(sed -n 1"p" $fstat"stat_terr_out.txt" | tr -d '\r')
stat_input_err=$(sed -n 1"p" $fstat"stat_terr_in.txt" | tr -d '\r')
id_tmp=$(sed -n 1"p" $fhome"id.txt" | tr -d '\r'); stat_input_alert=$((id_tmp-startid))
[ "$stat_input_alert" -lt "0" ] && stat_input_alert=0

[ "$lev_log" == "1" ] && logger "stat_check_api="$stat_check_api
[ "$lev_log" == "1" ] && logger "stat_check_trbot="$stat_check_trbot
[ "$lev_log" == "1" ] && logger "stat_check_abot3="$stat_check_abot3
[ "$lev_log" == "1" ] && logger "stat_check_sender="$stat_check_sender

[ "$lev_log" == "1" ] && logger "stat_send_ok="$stat_send_ok
[ "$lev_log" == "1" ] && logger "stat_send_err="$stat_send_err
[ "$lev_log" == "1" ] && logger "stat_input_err="$stat_input_err
[ "$lev_log" == "1" ] && logger "stat_input_alert="$stat_input_alert

zapushgateway;
done



rm -f $fPID

