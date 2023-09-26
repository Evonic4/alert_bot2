#!/bin/bash
ver="v0.641"


fhome=/usr/share/abot2/
fhsender=/usr/share/abot2/sender/
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
log="/var/log/trbot/trbot.log"
fPID=$fhome"trbot_pid.txt"
ftb=$fhome
cuf=$fhome
fm=$fhome"mail.txt"
mass_mesid_file=$fhome"mmid.txt"
home_trbot=$fhome
#f_send=$fhome"abot2.txt"
mkdir -p /var/log/trbot/
lev_log=$(sed -n 14"p" $ftb"sett.conf" | tr -d '\r')
starten=1
sender_id=$fhome"sender_id.txt"
#sender_list=$fhome"sender_list.txt"

function Init2() 
{
[ "$lev_log" == "1" ] && logger "Start Init"
chat_id1=$(sed -n 2"p" $ftb"sett.conf" | tr -d '\r')
regim=$(sed -n 3"p" $ftb"sett.conf" | tr -d '\r')
#echo $regim > $ftb"amode.txt"
sec4=$(sed -n 4"p" $ftb"sett.conf" | tr -d '\r')
#sec4=$((sec4/1000))
sec=$(sed -n 6"p" $ftb"sett.conf" | tr -d '\r')
opov=$(sed -n 7"p" $ftb"sett.conf" | tr -d '\r')
email=$(sed -n 8"p" $ftb"sett.conf" | tr -d '\r')
startid=$(sed -n 9"p" $ftb"sett.conf" | tr -d '\r')
bui=$(sed -n 11"p" $ftb"sett.conf" | tr -d '\r')
#last_id=0
progons=$(sed -n 13"p" $ftb"sett.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $ftb"sett.conf" | tr -d '\r')
send_up_start=$(sed -n 15"p" $ftb"sett.conf" | tr -d '\r')
health_check=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
health_on=0
[ "$health_check" -gt "0" ] && health_on=1 #включено или нет по факту
mute_health_on=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')

bicons=$(sed -n 19"p" $ftb"sett.conf" | tr -d '\r')
sty=$(sed -n 20"p" $ftb"sett.conf" | tr -d '\r')
promapi=$(sed -n 21"p" $ftb"sett.conf" | tr -d '\r')
label1=$(sed -n 22"p" $ftb"sett.conf" | tr -d '\r')
groupp=$(sed -n 23"p" $ftb"sett.conf" | tr -d '\r')

#40+
com_help=$(sed -n 40"p" $ftb"sett.conf" | tr -d '\r')
com_job=$(sed -n 41"p" $ftb"sett.conf" | tr -d '\r')
com_status=$(sed -n 42"p" $ftb"sett.conf" | tr -d '\r')
com_del=$(sed -n 43"p" $ftb"sett.conf" | tr -d '\r')
com_cd=$(sed -n 44"p" $ftb"sett.conf" | tr -d '\r')
com_on=$(sed -n 45"p" $ftb"sett.conf" | tr -d '\r')
com_off=$(sed -n 46"p" $ftb"sett.conf" | tr -d '\r')
com_testmail=$(sed -n 47"p" $ftb"sett.conf" | tr -d '\r')
com_health=$(sed -n 48"p" $ftb"sett.conf" | tr -d '\r')
com_mute=$(sed -n 49"p" $ftb"sett.conf" | tr -d '\r')
com_papi=$(sed -n 50"p" $ftb"sett.conf" | tr -d '\r')
com_conf=$(sed -n 51"p" $ftb"sett.conf" | tr -d '\r')

echo 0 > $fhome"err_send.txt"
echo 0 > $fhome"err_accept.txt"

kkik=0
snu=0	#номер файла sender_queue
tinp_ok=0
tinp_err=0
tohelpness;
}



function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" trbot_"$bui": "$1
}


function tohelpness()
{
#help.txt
echo "Commands:" > $fhome"help.txt"
echo "/"$com_job" - Unresolved problems" >> $fhome"help.txt"
echo "/"$com_status" - Bot status" >> $fhome"help.txt"
echo "/"$com_del" - Delete event notification (/"$com_del" 12345678)" >> $fhome"help.txt"
echo "After deletion, the notification about the specified event will not come in the future" >> $fhome"help.txt"
echo "/"$com_cd" - Clearing the list of deleted notifications" >> $fhome"help.txt"
echo "/"$com_on" /"$com_off" - Alerting mode (quiet mode)" >> $fhome"help.txt"
echo "/"$com_papi" - Prometheus API alert mode (/"$com_papi" on|off >0 mute on|off)" >> $fhome"help.txt"
echo "/"$com_health" - Auto health checks in chat (/"$com_health" on|off|mute >0 mute on|off)" >> $fhome"help.txt"
echo "/"$com_mute" - Working with notify sounds (/"$com_mute" on|off|mask *|all|status|sys|papi|hc|mask|rm alerts|resolves)" >> $fhome"help.txt"
#echo "/"$com_conf" - Configure sett.conf (/"$com_conf" A B; где A - номер строки, B-значение)" >> $fhome"help.txt"

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


bot_status()
{
local tmprbs1=""
local tmprbs2=0
local tmprbs3=0
local tmprbs4=0
local tmprbs5=0
local tmprbs6=""

#opov
[ "$opov" -eq "0" ] && tmprbs1="Managed"
[ "$opov" -eq "1" ] && tmprbs1="Messenger"

tmprbs2=$(cat $fhome"alerts2.txt" | wc -l)
tmprbs3=$(cat $fhome"alerts2.txt" | wc -c)
[ "$tmprbs2" -gt "0" ] && [ "$tmprbs3" -lt "8" ] && tmprbs2=0

tmprbs4=$(cat $fhome"delete.txt" | wc -l)
tmprbs5=$(cat $fhome"delete.txt" | wc -c)
[ "$tmprbs4" -gt "0" ] && [ "$tmprbs5" -lt "8" ] && tmprbs4=0

echo $tmprbs1" bot "$bui" "$ver" jobs:"$tmprbs2",delete:"$tmprbs4 > $fhome"ss.txt"

#Alerting mode
#regim=$(sed -n "1p" $fhome"amode.txt" | tr -d '\r')
regim=$(sed -n 3"p" $ftb"sett.conf" | tr -d '\r')
[ "$regim" -eq "1" ] && echo "Alerting mode ON" >> $fhome"ss.txt"
[ "$regim" -eq "0" ] && echo "Alerting mode OFF" >> $fhome"ss.txt"

#Prom API
autohcheck_rez=$(sed -n "1p" $fhome"prom_api_status.txt" | tr -d '\r')
if [ "$autohcheck_rez" -eq "0" ]; then
	echo "Prom API UP" >> $fhome"ss.txt"
else
	echo "Prom API DOWN" >> $fhome"ss.txt"
fi

#health check
mute_health_on=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')
[ "$mute_health_on" == "1" ] && tmprbs6="ON"
[ "$mute_health_on" == "0" ] && tmprbs6="OFF"
	
if [ -z "$com1" ] && [ -z "$com2" ] && [ -z "$com3" ] && [ -z "$com4" ]; then
	[ "$health_on" -eq "1" ] && echo "Auto health check status ON every "$health_check"m mute "$tmprbs6 >> $fhome"ss.txt"
	[ "$health_on" -eq "0" ] && echo "Auto health check status OFF" >> $fhome"ss.txt"
fi

#Prometheus API down alert (papi)
local tmp40=""
local tmp44=""
local tmp45=""
local tmp451=""

tmp45=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
[ "$tmp45" == "1" ] && tmp451="ON"
[ "$tmp45" == "0" ] && tmp451="OFF"

tmp40=$(sed -n 25"p" $ftb"sett.conf" | tr -d '\r')
if [ "$tmp40" == "0" ]; then
	tmp44="OFF"
else
	tmp44="ON every "$tmp40"m"
fi
echo "Prometheus API down alert "$tmp44" mute "$tmp451 >> $fhome"ss.txt"



#telegram API errors
sumi=$((tinp_ok+tinp_err))
[ "$sumi" -gt "0" ] && echo "Telegram api send_err:"$(sed -n 1"p" $fhome"err_send.txt" | tr -d '\r')", input_err:"$(echo "scale=2; $tinp_err/$sumi * 100" | bc) >> $fhome"ss.txt"

#mute
mute_stat;
echo "Mute "$mute_stat1 >> $fhome"ss.txt"

otv=$fhome"ss.txt"
s_mute=$(sed -n 18"p" $ftb"sett.conf" | tr -d '\r')
send_def
send;

}

mute_stat ()  	
{
logger "mute_stat"
local mts=""
mute_stat1=""

mts=$(sed -n 18"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"hc "
mts=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"sys "
mts=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"papi "
mts=$(sed -n 30"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"alerts "
mts=$(sed -n 31"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"resolves "

mts=$(sed -n 32"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"& mask alerts ["$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')"]"
mts=$(sed -n 34"p" $ftb"sett.conf" | tr -d '\r')
[ "$mts" == "1" ] && mute_stat1=$mute_stat1"& mask resolves ["$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')"]"

[ -z "$mute_stat1" ] && mute_stat1="disable"
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
	s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
	send_def
	send;
fi

if [ "$text" = "/$com_job" ]; then
	$ftb"job.sh"
	otv=$fhome"job.txt"
	s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
	send_def
	send;
fi

if [ "$text" = "/$com_status" ]; then
	bot_status;
fi

if [[ "$text" == "/$com_conf"* ]]; then
	echo $text | tr " " "\n" > $fhome"com_conf.txt"
	local com1=""
	local com2=""
	com1=$(sed -n 2"p" $ftb"com_conf.txt" | tr -d '\r')
	com2=$(sed -n 3"p" $ftb"com_conf.txt" | tr -d '\r')
		
	if [[ $com1 =~ ^[0-9]+$ ]]; then
		older_conf=$(sed -n $com1"p" $ftb"sett.conf" | tr -d '\r')
		logger "configure com1="$com1" com2="$com2" older_conf="$older_conf
		echo "Configure "$older_conf" -> "$com2 > $fhome"configure.txt"
		echo "configuration initialization started" >> $fhome"configure.txt"
		$fhome"to-config.sh" $com1 $com2
		otv=$fhome"configure.txt"
		s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
		Init2;
	fi
fi

if [[ "$text" == "/$com_mute"* ]]; then		#on|off|mask *|all|status|sys|papi|hc|mask|rm alerts|resolves
	echo $text | tr " " "\n" > $fhome"com_mute.txt"
	local com1=""
	local com2=""
	local com3=""
	local com4=""
	local com5=""
	local com66=""
	local com7=""
	local com8=""
	local com9=""
	local com10=""

	local com44=""
	local com444=""
	local com555=""
	local com6=0
	local cont1=0
	local cont2=""
	local cont3=0
	local cont4=""
	com1=$(sed -n 2"p" $ftb"com_mute.txt" | tr -d '\r')
	com2=$(sed -n 3"p" $ftb"com_mute.txt" | tr -d '\r')
	com3=$(sed -n 4"p" $ftb"com_mute.txt" | tr -d '\r')
	com4=$(sed -n 5"p" $ftb"com_mute.txt" | tr -d '\r')
	
	com5=$(sed -n 6"p" $ftb"com_mute.txt" | tr -d '\r')
	com66=$(sed -n 7"p" $ftb"com_mute.txt" | tr -d '\r')
	com7=$(sed -n 8"p" $ftb"com_mute.txt" | tr -d '\r')
	com8=$(sed -n 9"p" $ftb"com_mute.txt" | tr -d '\r')
	com9=$(sed -n 10"p" $ftb"com_mute.txt" | tr -d '\r')
	com10=$(sed -n 11"p" $ftb"com_mute.txt" | tr -d '\r')
	
	#/mute
	if [ -z "$com1" ] && [ -z "$com2" ] && [ -z "$com3" ]; then
		mute_stat;
		echo "Mute "$mute_stat1 > $fhome"mutes.txt"
		com6=5
	fi
	
	
	#/mute mask
	[ "$com1" == "mask" ] && [ -z "$com2" ] && com6=7
	#/mute status
	[ "$com1" == "status" ] && mute_stat && echo "Mute "$mute_stat1 > $fhome"mutes.txt" && com6=5
	#/mute on
	[ "$com1" == "on" ] && [ -z "$com2" ] && com6=1
	#/mute on all
	[ "$com1" == "on" ] && [ "$com2" == "all" ] && com6=1
	#/mute on hc
	[ "$com1" == "on" ] && [ "$com2" == "hc" ] && echo "Mute ON hc" > $fhome"mutes.txt" && com6=5 && cont1=18 && cont2="1"
	#/mute on sys
	[ "$com1" == "on" ] && [ "$com2" == "sys" ] && echo "Mute ON sys" > $fhome"mutes.txt" && com6=5 && cont1=28 && cont2="1"
	#/mute on papi
	[ "$com1" == "on" ] && [ "$com2" == "papi" ] && echo "Mute ON papi" > $fhome"mutes.txt" && com6=5 && cont1=29 && cont2="1"
	#/mute on alerts
	[ "$com1" == "on" ] && [ "$com2" == "alerts" ] && echo "Mute ON alerts" > $fhome"mutes.txt" && com6=5 && cont1=30 && cont2="1"
	#/mute on alerts
	[ "$com1" == "on" ] && [ "$com2" == "resolves" ] && echo "Mute ON resolves" > $fhome"mutes.txt" && com6=5 && cont1=31 && cont2="1"
	#/mute on mask alerts|resolves
	[ "$com1" == "on" ] && [ "$com2" == "mask" ] && [ "$com3" == "alerts" ] && com6=3
	[ "$com1" == "on" ] && [ "$com2" == "mask" ] && [ "$com3" == "resolves" ] && com6=4

	#/mute mask alerts *
	[ "$com1" == "mask" ] && [ "$com2" == "alerts" ] && ! [ -z "$com3" ] && com6=12
	#/mute mask resolves *
	[ "$com1" == "mask" ] && [ "$com2" == "resolves" ] && ! [ -z "$com3" ] && com6=13

	
	#/mute off
	[ "$com1" == "off" ] && [ -z "$com2" ] && echo "Mute OFF hc sys papi alerts resolves mask" > $fhome"mutes.txt" && com6=2
	#/mute off all
	[ "$com1" == "off" ] && [ "$com2" == "all" ] && echo "Mute OFF hc sys papi alerts resolves mask" > $fhome"mutes.txt" && com6=2
	#/mute off hc
	[ "$com1" == "off" ] && [ "$com2" == "hc" ] && echo "Mute OFF hc" > $fhome"mutes.txt" && com6=5 && cont1=18 && cont2="0"
	#/mute off sys
	[ "$com1" == "off" ] && [ "$com2" == "sys" ] && echo "Mute OFF sys" > $fhome"mutes.txt" && com6=5 && cont1=28 && cont2="0"
	#/mute off papi
	[ "$com1" == "off" ] && [ "$com2" == "papi" ] && echo "Mute OFF papi" > $fhome"mutes.txt" && com6=5 && cont1=29 && cont2="0"
	#/mute off alerts
	[ "$com1" == "off" ] && [ "$com2" == "alerts" ] && echo "Mute OFF alerts" > $fhome"mutes.txt" && com6=5 && cont1=30 && cont2="0"
	#/mute off alerts
	[ "$com1" == "off" ] && [ "$com2" == "resolves" ] && echo "Mute OFF resolves" > $fhome"mutes.txt" && com6=5 && cont1=31 && cont2="0"
	#/mute off mask alerts|resolves
	[ "$com1" == "off" ] && [ "$com2" == "mask" ] && [ "$com3" == "alerts" ] && echo "Mute OFF mask alerts" > $fhome"mutes.txt" && com6=5 && cont1=32 && cont2="0"
	[ "$com1" == "off" ] && [ "$com2" == "mask" ] && [ "$com3" == "resolves" ] && echo "Mute OFF mask resolves" > $fhome"mutes.txt" && com6=5 && cont1=34 && cont2="0"

	#/mute rm
	[ "$com1" == "mask" ] && [ "$com2" == "rm" ] && [ -z "$com3" ] && echo "Mute delete mask" > $fhome"mutes.txt" && com6=8
	#/mute rm alerts
	[ "$com1" == "mask" ] && [ "$com2" == "rm" ] && [ "$com3" == "alerts" ] && echo "Mute delete mask alerts" > $fhome"mutes.txt" && com6=11 && cont1=32 && cont2="0" && cont3=33 && cont4=""
	#/mute rm resolves
	[ "$com1" == "mask" ] && [ "$com2" == "rm" ] && [ "$com3" == "resolves" ] && echo "Mute delete mask resolves" > $fhome"mutes.txt" && com6=11 && cont1=34 && cont2="0" && cont3=35 && cont4=""
	
	#/mute on mask alerts
	if [ "$com6" -eq "3" ]; then
		com44=$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')
		if ! [ -z "$com44" ] && ! [ "$com44" == " " ]; then
		echo "Mute ON mask alerts" > $fhome"mutes.txt"
		com6=5 && cont1=32 && cont2="1"
		else
		echo "Mute no mask alerts" > $fhome"mutes.txt"
		com6=5 && cont1=32 && cont2="0"
		fi
	fi
	#/mute on mask resolves
	if [ "$com6" -eq "4" ]; then
		com44=$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')
		if ! [ -z "$com44" ] && ! [ "$com44" == " " ]; then
		echo "Mute ON mask resolves" > $fhome"mutes.txt"
		com6=5 && cont1=34 && cont2="1"
		else
		echo "Mute no mask resolves" > $fhome"mutes.txt"
		com6=5 && cont1=34 && cont2="0"
		fi
	fi
	#/mute mask alerts *
	if [ "$com6" -eq "12" ]; then
		cont1=33 
		cont2=$com3" "$com4" "$com5" "$com66" "$com7" "$com8" "$com9" "$com10
		cont2=$(echo $cont2 | sed 's/[ \t]*$//')
		echo "Mute mask alerts ["$cont2"]" > $fhome"mutes.txt"
		com6=5
	fi
	#/mute mask resolves *
	if [ "$com6" -eq "13" ]; then
		cont1=35 
		cont2=$com3" "$com4" "$com5" "$com66" "$com7" "$com8" "$com9" "$com10
		cont2=$(echo $cont2 | sed 's/[ \t]*$//')
		echo "Mute mask resolves ["$cont2"]" > $fhome"mutes.txt"
		com6=5
	fi
	if [ "$com6" -eq "1" ]; then
		com444=""
		com555=""
		echo "#!/bin/bash" > $fhome"1.sh"
		echo $fhome"to-config.sh" 18 1 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 28 1 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 29 1 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 30 1 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 31 1 >> $fhome"1.sh"
		! [ -z "$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')" ] && echo $fhome"to-config.sh" 32 1 >> $fhome"1.sh" && com444="[mask alerts]"
		! [ -z "$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')" ] && echo $fhome"to-config.sh" 34 1 >> $fhome"1.sh" && com555="[mask resolves]"
		chmod +rx $fhome"1.sh"
		$fhome"1.sh" &
		echo "Mute ON hc sys papi alerts resolves "$com444" "$com555 > $fhome"mutes.txt"
		com6=6
	fi
	if [ "$com6" -eq "2" ]; then
		echo "#!/bin/bash" > $fhome"1.sh"
		echo $fhome"to-config.sh" 18 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 28 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 29 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 30 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 31 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 32 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 34 0 >> $fhome"1.sh"
		chmod +rx $fhome"1.sh"
		$fhome"1.sh" &
		com6=6
	fi
	if [ "$com6" -eq "7" ]; then
		com44=$(sed -n 32"p" $ftb"sett.conf" | tr -d '\r')
		if [ "$com44" -eq "1" ]; then
			com444=$(sed -n 33"p" $ftb"sett.conf" | tr -d '\r')
			com555="Mute mask alerts ON ["$com444"]"
			else
			com555="Mute mask alerts OFF"
		fi
		com44=$(sed -n 34"p" $ftb"sett.conf" | tr -d '\r')
		if [ "$com44" -eq "1" ]; then
			com444=$(sed -n 35"p" $ftb"sett.conf" | tr -d '\r')
			com555=$com555", mask resolves ON ["$com444"]"
			else
			com555=$com555", mask resolves OFF"
		fi
		echo $com555 > $fhome"mutes.txt"
		com6=6
	fi
	if [ "$com6" -eq "8" ]; then
		echo "#!/bin/bash" > $fhome"1.sh"
		echo $fhome"to-config.sh" 32 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 33 "" >> $fhome"1.sh"
		echo $fhome"to-config.sh" 34 0 >> $fhome"1.sh"
		echo $fhome"to-config.sh" 35 "" >> $fhome"1.sh"
		chmod +rx $fhome"1.sh"
		$fhome"1.sh" &
		com6=6
	fi
	if [ "$com6" -eq "11" ]; then
		echo "#!/bin/bash" > $fhome"1.sh"
		echo $fhome"to-config.sh" $cont1 $cont2 >> $fhome"1.sh"
		echo $fhome"to-config.sh" $cont3 $cont4 >> $fhome"1.sh"
		chmod +rx $fhome"1.sh"
		$fhome"1.sh" &
		com6=6
	fi
	if [ "$com6" -eq "5" ]; then
		$fhome"to-config.sh" $cont1 $cont2 &
		com6=6
	fi


	if [ "$com6" -eq "6" ]; then
		otv=$fhome"mutes.txt"
		s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
	fi
	if [ "$com6" -eq "0" ]; then
		echo "no commands" > $fhome"mutes.txt"
		otv=$fhome"mutes.txt"
		s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
	fi
fi

if [[ "$text" == "/$com_health"* ]]; then						#on|off|mute >0 mute on|off
	echo $text | tr " " "\n" > $fhome"com_health.txt"
	local com1=""
	local com2=""
	local com3=""
	local com4=""
	local com5=""
	local com6=0
	local cont1=0
	local cont11=""
	local cont2=0
	local cont22=""
	com1=$(sed -n 2"p" $ftb"com_health.txt" | tr -d '\r')
	com2=$(sed -n 3"p" $ftb"com_health.txt" | tr -d '\r')
	com3=$(sed -n 4"p" $ftb"com_health.txt" | tr -d '\r')
	com4=$(sed -n 5"p" $ftb"com_health.txt" | tr -d '\r')
	
	[ "$mute_health_on" == "1" ] && com5="ON"
	[ "$mute_health_on" == "0" ] && com5="OFF"
	
	#/health
	if [ -z "$com1" ] && [ -z "$com2" ] && [ -z "$com3" ] && [ -z "$com4" ]; then
		[ "$health_on" -eq "1" ] && echo "Auto health check status ON every "$health_check"m mute "$com5 > $fhome"hc.txt"
		[ "$health_on" -eq "0" ] && echo "Auto health check status OFF" > $fhome"hc.txt"
		com6=5
	fi
	
	#/health on
	[ "$com1" == "on" ] && [ -z "$com2" ] && echo "Auto health check ON every 5m" > $fhome"hc.txt" && com6=4 && cont1=17 && cont11="5"
	#/health on mute on|off
	[ "$com1" == "on" ] && [ "$com2" == "mute" ] && [ "$com3" == "on" ] && echo "Auto health check ON every 5m mute ON" > $fhome"hc.txt" && com6=1 && cont1=17 && cont11="5" && cont2=18 && cont22="1"
	[ "$com1" == "on" ] && [ "$com2" == "mute" ] && [ "$com3" == "off" ] && echo "Auto health check ON every 5m mute OFF" > $fhome"hc.txt" && com6=1 && cont1=17 && cont11="5" && cont2=18 && cont22="0"
	
	#/health on 444
	[ "$com1" == "on" ] && [[ $com2 =~ ^[0-9]+$ ]] && [ "$com2" -gt "0" ] && [ -z "$com3" ] && echo "Auto health check ON every "$com2"m" > $fhome"hc.txt" && com6=4 && cont1=17 && cont11=$com2
	#/health on 444 * mute on|off
	[ "$com1" == "on" ] && [[ $com2 =~ ^[0-9]+$ ]] && [ "$com2" -gt "0" ] && [ "$com3" == "mute" ] && [ "$com4" == "on" ] && echo "Auto health check ON every "$com2"m mute ON" > $fhome"hc.txt" && com6=1 && cont1=17 && cont11=$com2 && cont2=18 && cont22="1"
	[ "$com1" == "on" ] && [[ $com2 =~ ^[0-9]+$ ]] && [ "$com2" -gt "0" ] && [ "$com3" == "mute" ] && [ "$com4" == "off" ] && echo "Auto health check ON every "$com2"m mute OFF" > $fhome"hc.txt" && com6=1 && cont1=17 && cont11=$com2 && cont2=18 && cont22="0"
	
	#/health off
	[ "$com1" == "off" ] && [ -z "$com2" ] && echo "Auto health check OFF" > $fhome"hc.txt" && com6=4 && cont1=17 && cont11="0"
	#/health off mute on|off
	[ "$com1" == "off" ] && [ "$com2" == "mute" ] && [ "$com3" == "on" ] && echo "Auto health check OFF mute ON" > $fhome"hc.txt" && com6=1 && cont1=17 && cont11="0" && cont2=18 && cont22="1"
	[ "$com1" == "off" ] && [ "$com2" == "mute" ] && [ "$com3" == "off" ] && echo "Auto health check OFF mute OFF" > $fhome"hc.txt" && com6=1 && cont1=17 && cont11="0" && cont2=18 && cont22="0"
	
	#/health mute
	[ "$com1" == "mute" ] && echo "Auto health mute status "$com5 > $fhome"hc.txt" && com6=5
	#/health mute on *
	[ "$com1" == "mute" ] && [ "$com2" == "on" ] && echo "Auto health mute ON" > $fhome"hc.txt" && com6=4 && cont1=18 && cont11="1"
	#/health mute off *
	[ "$com1" == "mute" ] && [ "$com2" == "off" ] && echo "Auto health mute OFF" > $fhome"hc.txt" && com6=4 && cont1=18 && cont11="0"
	
	if [ "$com6" -eq "1" ]; then
		echo "#!/bin/bash" > $fhome"2.sh"
		echo $fhome"to-config.sh" $cont1 $cont11 >> $fhome"2.sh"
		echo $fhome"to-config.sh" $cont2 $cont22  >> $fhome"2.sh"
		chmod +rx $fhome"2.sh"
		$fhome"2.sh" &
		com6=5
	fi
	
	if [ "$com6" -eq "4" ]; then
		$fhome"to-config.sh" $cont1 $cont11 &
		com6=5
	fi
	
	if [ "$com6" -eq "5" ]; then
		otv=$fhome"hc.txt"
		s_mute=$(sed -n 18"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
	fi
	if [ "$com6" -eq "0" ]; then
		echo "no commands" > $fhome"hc.txt"
		otv=$fhome"hc.txt"
		s_mute=$(sed -n 18"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
	fi
fi

if [[ "$text" == "/$com_papi"* ]]; then					#on|off|mute >0 mute on|off
	echo $text | tr " " "\n" > $fhome"com_papi.txt"
	local com1=""
	local com2=""
	local com3=""
	local com4=""
	local com5=""
	local com6=0
	local com7=""
	local com8=""
	local cont1=0
	local cont11=""
	local cont2=0
	local cont22=""
	
	com1=$(sed -n 2"p" $ftb"com_papi.txt" | tr -d '\r')
	com2=$(sed -n 3"p" $ftb"com_papi.txt" | tr -d '\r')
	com3=$(sed -n 4"p" $ftb"com_papi.txt" | tr -d '\r')
	com4=$(sed -n 5"p" $ftb"com_papi.txt" | tr -d '\r')
	
	com7=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
	[ "$com7" == "1" ] && com8="ON"
	[ "$com7" == "0" ] && com8="OFF"
	
	#/papi
	if [ -z "$com1" ] && [ -z "$com2" ] && [ -z "$com3" ] && [ -z "$com4" ]; then
		papi1=$(sed -n 25"p" $ftb"sett.conf" | tr -d '\r')
		if [ "$papi1" == "0" ]; then
			com5="OFF"
		else
			com5="ON every "$papi1"m"
		fi
		
		echo "Prometheus API alert "$com5" mute "$com8 > $fhome"papis.txt"
		com6=5
	fi
	
	#/papi on
	[ "$com1" == "on" ] && [ -z "$com2" ] && echo "Prometheus API alert ON every 5m" > $fhome"papis.txt" && com6=4 && cont1=25 && cont11="5"
	#/papi on mute on|off
	[ "$com1" == "on" ] && [ "$com2" == "mute" ] && [ "$com3" == "on" ] && echo "Prometheus API alert ON every 5m mute ON" > $fhome"papis.txt" && com6=1 && cont1=25 && cont11="5" && cont2=29 && cont22="1"
	[ "$com1" == "on" ] && [ "$com2" == "mute" ] && [ "$com3" == "off" ] && echo "Prometheus API alert ON every 5m mute OFF" > $fhome"papis.txt" && com6=1 && cont1=25 && cont11="5" && cont2=29 && cont22="0"

	#/papi on 444
	[ "$com1" == "on" ] && [[ $com2 =~ ^[0-9]+$ ]] && [ "$com2" -gt "0" ] && [ -z "$com3" ] && echo "Prometheus API alert ON every "$com2"m" > $fhome"papis.txt" && com6=4 && cont1=25 && cont11=$com2
	#/papi on 444 * mute on|off
	[ "$com1" == "on" ] && [[ $com2 =~ ^[0-9]+$ ]] && [ "$com2" -gt "0" ] && [ "$com3" == "mute" ] && [ "$com4" == "on" ] && echo "Prometheus API alert ON every "$com2"m mute ON" > $fhome"papis.txt" && com6=1 && cont1=25 && cont11=$com2 && cont2=29 && cont22="1"
	[ "$com1" == "on" ] && [[ $com2 =~ ^[0-9]+$ ]] && [ "$com2" -gt "0" ] && [ "$com3" == "mute" ] && [ "$com4" == "off" ] && echo "Prometheus API alert ON every "$com2"m mute OFF" > $fhome"papis.txt" && com6=1 && cont1=25 && cont11=$com2 && cont2=29 && cont22="0"
	
	#/papi off
	[ "$com1" == "off" ] && [ -z "$com2" ] && echo "Prometheus API alert OFF" > $fhome"papis.txt" && com6=4 && cont1=25 && cont11="0"
	#/papi off mute on|off
	[ "$com1" == "off" ] && [ "$com2" == "mute" ] && [ "$com3" == "on" ] && echo "Prometheus API alert OFF mute ON" > $fhome"papis.txt" && com6=1 && cont1=25 && cont11="0" && cont2=29 && cont22="1"
	[ "$com1" == "off" ] && [ "$com2" == "mute" ] && [ "$com3" == "off" ] && echo "Prometheus API alert OFF mute OFF" > $fhome"papis.txt" && com6=1 && cont1=25 && cont11="0" && cont2=29 && cont22="0"
	
	#/papi mute
	[ "$com1" == "mute" ] && echo "Prometheus API alert mute status "$com5 > $fhome"papis.txt" && com6=5
	#/papi mute on *
	[ "$com1" == "mute" ] && [ "$com2" == "on" ] && echo "Prometheus API alert mute ON" > $fhome"papis.txt" && com6=4 && cont1=29 && cont11="1"
	#/papi mute off *
	[ "$com1" == "mute" ] && [ "$com2" == "off" ] && echo "Prometheus API alert mute OFF" > $fhome"papis.txt" && com6=4 && cont1=29 && cont11="0"
	
	if [ "$com6" -eq "1" ]; then
		echo "#!/bin/bash" > $fhome"2.sh"
		echo $fhome"to-config.sh" $cont1 $cont11 >> $fhome"2.sh"
		echo $fhome"to-config.sh" $cont2 $cont22  >> $fhome"2.sh"
		chmod +rx $fhome"2.sh"
		$fhome"2.sh" &
		com6=5
	fi

	if [ "$com6" -eq "4" ]; then
		$fhome"to-config.sh" $cont1 $cont11 &
		com6=5
	fi

	if [ "$com6" -eq "5" ]; then
		otv=$fhome"papis.txt"
		s_mute=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
	fi
	if [ "$com6" -eq "0" ]; then
		echo "no commands" > $fhome"papis.txt"
		otv=$fhome"papis.txt"
		s_mute=$(sed -n 29"p" $ftb"sett.conf" | tr -d '\r')
		send_def
		send;
	fi
fi



if [[ "$text" == "/$com_del"* ]]; then
	$ftb"del.sh" $text	
	otv=$fhome"del.txt"
	s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
	send_def
	send;
fi

if [[ "$text" == "/$com_cd" ]]; then
	echo > $ftb"delete.txt"
	otv=$fhome"cd.txt"
	s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
	send_def
	send;
fi

if [ "$text" == "/$com_on" ]; then
	$fhome"to-config.sh" 3 1 &
	echo "Alerting mode ON" > $fhome"regim.txt"
	otv=$fhome"regim.txt"
	s_mute=$(sed -n 28"p" $fhome"sett.conf" | tr -d '\r')
	send_def
	send;
fi

if [ "$text" == "/$com_off" ]; then
	$fhome"to-config.sh" 3 0 &
	echo "Alerting mode OFF" > $fhome"regim.txt"
	otv=$fhome"regim.txt"
	s_mute=$(sed -n 28"p" $fhome"sett.conf" | tr -d '\r')
	send_def
	send;
fi

if [ "$text" == "/testmail" ]; then
	echo "Test abot2-"$bui" "$date1 > $fhome"mail.txt"
	echo "Testing send to mail" >> $fhome"mail.txt"
	$fhome"sendmail.sh"
	otv=$fhome"tmail.txt"
	s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')
	send_def
	send;
fi

logger "roborob otv="$otv
}


sender_queue ()
{
snu=$(sed -n 1"p" $sender_id | tr -d '\r')
snu=$((snu+1))
echo $snu > $sender_id
}

send1 () 
{
[ "$lev_log" == "1" ] && logger "send1 start"
#sys
[ "$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r')" == "1" ] && s_mute="1"

sender_queue

echo $fhsender2$snu".txt" > $fhome"sender.txt"
echo $s_bic >> $fhome"sender.txt"							#спец картинок в уведомлениях 0-2
echo $s_sty >> $fhome"sender.txt"							#показ спец картинок severity 0-6
echo $s_url >> $fhome"sender.txt"							#урл
echo $s_mute >> $fhome"sender.txt"							#mute

mv -f $otv $fhsender2$snu".txt"
mv -f $fhome"sender.txt" $fhsender1$snu".txt"

}

send_def ()
{
s_url=""
s_sty=0
s_bic=0
}

send ()
{
[ "$lev_log" == "1" ] && logger "send start"

dl=$(wc -m $otv | awk '{ print $1 }')
logger "send dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	sv=$((sv+1))
	echo "sv="$sv
	$ftb"rex.sh" $otv
	logger "obrezka"
	for (( i5=1;i5<=$sv;i5++)); do
		otv=$fhome"rez"$i5".txt"
		logger "obrezka "$fhome"rez"$i5".txt"
		send1;
		logger "to obrezka "$fhome"rez"$i5".txt"
		rm -f $fhome"rez"$i5".txt"
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

input ()  		
{
logger "input start"
$ftb"cucu1.sh"

if [ "$(cat $fhome"in.txt" | grep "\"ok\":true,")" ]; then	
	tinp_ok=$((tinp_ok+1))
	logger "input OK "$tinp_ok
else
	tinp_err=$((tinp_err+1))
	logger "input ERROR "$tinp_err":   "$(grep "curl:" $fhome"in_err.txt")
fi

[ "$lev_log" == "1" ] && logger "input exit"
}

starten_furer ()  				
{

again2="yes"
while [ "$again2" = "yes" ] #крутим, пока $again1 будет равно "yes"
do
$ftb"cucu1.sh"
if [ "$(cat $fhome"in.txt" | grep "\"ok\":true,")" ]; then	
	logger "start input OK"
	again2="no"
else
	logger "start input ERROR"
fi
sleep 1
done


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
mi=0
date1=`date '+ %d.%m.%Y %H:%M:%S'`
mi_col=$(cat $cuf"in.txt" | grep -c update_id | tr -d '\r')
logger "parce col mi_col ="$mi_col
upd_id=$(sed -n 1"p" $ftb"lastid.txt" | tr -d '\r')
logger "parce upd_id ="$upd_id

if [ "$mi_col" -gt "0" ]; then
for (( i=0;i<$mi_col;i++)); do
	mi=$(cat $ftb"in.txt" | jq ".result[$i].update_id" | tr -d '\r')
	[ "$lev_log" == "1" ] && logger "parce update_id=mi="$mi
	
	[ -z "$mi" ] && mi=0
	[ "$mi" == "null" ] && mi=0
	
	[ "$lev_log" == "1" ] && logger "parce cycle upd_id="$upd_id", i="$i", mi="$mi
	if [ "$upd_id" -ge "$mi" ] || [ "$mi" -eq "0" ]; then
		ffufuf=1
		else
		ffufuf=0
	fi
	[ "$lev_log" == "1" ] && logger "parce cycle ffufuf="$ffufuf
	
	if [ "$ffufuf" -eq "0" ]; then
		chat_id=$(cat $ftb"in.txt" | jq ".result[$i].message.chat.id" | sed 's/-/z/g' | tr -d '\r')
		[ "$lev_log" == "1" ] && logger "parce chat_id="$chat_id
		if [ "$(echo $chat_id1|sed 's/-/z/g'| tr -d '\r'| grep $chat_id)" ]; then
			[ "$lev_log" == "1" ] && logger "parse chat_id="$chat_id" -> OK"
			text=$(cat $ftb"in.txt" | jq ".result[$i].message.text" | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			[ "$lev_log" == "1" ] && logger "parse text="$text
			#echo $text > $home_trbot"t.txt"
			roborob;
			
			logger "parce ok"
		else
			logger "parce dont! chat_id="$chat_id" NOT OK"
		fi
	fi
	if [ "$ffufuf" -eq "1" ]; then
		logger "parce lastid >= mi"
	fi
done
[ "$ffufuf" -eq "0" ] && echo $mi > $ftb"lastid.txt" && logger "parce mi -> lastid.txt"
fi

[ "$lev_log" == "1" ] && logger "parce end"
}



#autohcheck ()
#{
#autohcheck_rez=$(curl -I -k -m 4 "$promapi" 2>&1 | grep -cE 'Failed')
#if [ "$autohcheck_rez" -eq "1" ]; then
#	logger "autohcheck prom api Failed"
#else
#	logger "autohcheck prom api OK"
#fi
#}


#health_check-------------
health_check_status ()
{
logger "health_check status"
health_check=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')

if [ "$health_on" -eq "0" ]; then
	[ "$health_check" -gt "0" ] && health_check_on
else
	[ "$health_check" -eq "0" ] && health_check_off
fi
}
health_check_start ()
{
health_check=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
if [ "$health_check" -gt "0" ]; then
	logger "health_check enable"
	health_check_on;
else
	logger "health_check disable"
	health_check_off;
fi
}
health_check_on ()
{
dhealth_check=`date -d "$RTIME $health_check min" '+ %Y%m%d%H%M%S'`
echo $dhealth_check > $fhome"dhealth_check.txt"
health_on=1
logger "health_check_on"
}
health_check_off ()
{
health_on=0
logger "health_check_off"
}
health_checking ()
{
logger "health_checking"
dtna1=$(echo $(date '+ %Y%m%d%H%M%S') | sed 's/z/-/g' | tr -d '\r')
dtna=$(sed -n 1"p" $fhome"dhealth_check.txt" | sed 's/z/-/g' | tr -d '\r')
logger " dtna="$dtna
logger "dtna1="$dtna1

if [ "$dtna1" -gt "$dtna" ]; then
	logger "dtna1="$dtna1" > dtna="$dtna
	bot_status;
	health_check_start;
else 
	logger ">"
fi
}
#health_check-------------


PID=$$
echo $PID > $fPID

logger ""
logger "start abot2 "$bui" lev_log="$lev_log
Init2;

#start number notify
! [ -f $ftb"id.txt" ] && echo $startid > $fhome"id.txt"

logger "chat_id1="$chat_id1
starten_furer;

#start
[ "$send_up_start" == "1" ] && s_mute=$(sed -n 28"p" $ftb"sett.conf" | tr -d '\r') && send_def && echo "Start "$bui > $fhome"start.txt" && otv=$fhome"start.txt" && send


#health_check start
[ "$health_on" -eq "1" ] && health_check_start;

kkik=0

while true
do
sleep $sec4
ffufuf1=0

tinp_ok1=$tinp_ok
[ "$opov" == "0" ] && input;
[ "$opov" == "0" ] && [ "$tinp_ok" -gt "$tinp_ok1" ] && parce;
health_check_status
[ "$health_on" -eq "1" ] && health_checking;
#[ "$regim" -eq "1" ] && [ "$health_on" -eq "1" ] && health_checking;

kkik=$(($kkik+1))
if [ "$kkik" -ge "$progons" ]; then
	Init2
	sumi=$((tinp_ok+tinp_err))
	echo $(echo "scale=2; $tinp_err/$sumi * 100" | bc) >> $fhome"err_accept.txt"
fi

done
rm -f $fPID




