#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#переменные
fhome=/usr/share/abot2/
fhsender=$fhome"sender/"
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
fstat=$fhome"stat/"
fPID=$fhome"sender_pid.txt"
log=$fhsender"sender_log.txt"
sender_list=$fhome"sender_list.txt"
fpost_home=/home/en/fetchmail/
fpost_new=/home/en/fetchmail/mail/new/
fpost_cur=/home/en/fetchmail/mail/cur/
fpost_tmp=/home/en/fetchmail/mail/tmp/


function Init2() 
{
logger "Init2"
#rm -rf $fhsender
mkdir -p $fhsender1
mkdir -p $fhsender2

em=$(sed -n 8"p" $fhome"sett.conf" | tr -d '\r')
if [ "$em" -eq "1" ]; then
	smtp_hostname=$(sed -n 36"p" $fhome"sett.conf" | tr -d '\r')
	smtp_sport=$(sed -n 37"p" $fhome"sett.conf" | tr -d '\r')
	smtp_user=$(sed -n 38"p" $fhome"sett.conf" | tr -d '\r')
	smtp_pass=$(sed -n 39"p" $fhome"sett.conf" | tr -d '\r')
	! [ "$smtp_hostname" == "" ] && ! [ "$smtp_sport" == "" ] && ! [ "$smtp_user" == "" ] && ! [ "$smtp_pass" == "" ] && smtp_content;
fi

startid=$(sed -n 9"p" $fhome"sett.conf" | tr -d '\r')
#start number notify
! [ -f $fhome"id.txt" ] && echo $startid > $fhome"id.txt"

ssec1=$(sed -n 10"p" $fhome"sett.conf" | tr -d '\r')
logger "ssec1="$ssec1
bui=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
token=$(sed -n "1p" $fhome"sett.conf" | tr -d '\r')
proxy=$(sed -n 5"p" $fhome"sett.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $fhome"sett.conf" | tr -d '\r')
sty=$(sed -n 20"p" $fhome"sett.conf" | tr -d '\r')
ssec=$(sed -n 12"p" $fhome"sett.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
chat_id=$(sed -n "2p" $fhome"sett.conf" | sed 's/z/-/g' | tr -d '\r')
pushg=$(sed -n 48"p" $fhome"sett.conf" | tr -d '\r')

chm=$(sed -n 40"p" $fhome"sett.conf" | tr -d '\r')
local fpool=$(sed -n 42"p" $fhome"sett.conf" | tr -d '\r')
local fport=$(sed -n 43"p" $fhome"sett.conf" | tr -d '\r')
local fproto=$(sed -n 44"p" $fhome"sett.conf" | tr -d '\r')
local fuser=$(sed -n 45"p" $fhome"sett.conf" | tr -d '\r')
local fpass=$(sed -n 46"p" $fhome"sett.conf" | tr -d '\r')
local fssl=$(sed -n 47"p" $fhome"sett.conf" | tr -d '\r')
if [ "$chm" -eq "1" ]; then
	cp -f $fhome"fetchmail.txt" $fpost_home"fetchmail.conf"
	echo "poll "$fpool >> $fpost_home"fetchmail.conf"
	echo "port "$fport >> $fpost_home"fetchmail.conf"
	echo "proto "$fproto >> $fpost_home"fetchmail.conf"
	echo "user \""$fuser"\"" >> $fpost_home"fetchmail.conf"
	echo "password \""$fpass"\"" >> $fpost_home"fetchmail.conf"
	echo $fssl >> $fpost_home"fetchmail.conf"
	
	echo "keep" >> $fpost_home"fetchmail.conf"
	echo "mda \"/usr/bin/procmail -m /home/en/fetchmail/procmail.conf\"" >> $fpost_home"fetchmail.conf"
	
	chown -R en:en $fpost_home
	#chown -R en:en $fpost_home"fetchmail.conf"
	#chown -R en:en $fpost_home"procmail.conf"
	chmod 700 $fpost_home"fetchmail.conf"
fi

kkik=0

#stat
sendok=$(sed -n 1"p" $fstat"stat_tok_out.txt" | tr -d '\r')
senderr=$(sed -n 1"p" $fstat"stat_terr_out.txt" | tr -d '\r')

integrity;		#только под рутом(
}


smtp_content()
{
logger "smtp_content"
echo "hostname="$smtp_hostname > /etc/ssmtp/ssmtp.conf
echo "FromLineOverride=NO" >> /etc/ssmtp/ssmtp.conf
echo "AuthUser="$smtp_user >> /etc/ssmtp/ssmtp.conf
echo "AuthPass="$smtp_pass >> /etc/ssmtp/ssmtp.conf
echo "AuthMethod=LOGIN" >> /etc/ssmtp/ssmtp.conf
echo "mailhub="$smtp_sport >> /etc/ssmtp/ssmtp.conf
echo "rewriteDomain="$smtp_hostname >> /etc/ssmtp/ssmtp.conf
echo "UseTLS=YES" >> /etc/ssmtp/ssmtp.conf
echo "Debug=YES" >> /etc/ssmtp/ssmtp.conf
echo "TLS_CA_File=/etc/ssl/certs/ca-certificates.crt" >> /etc/ssmtp/ssmtp.conf
chmod 640 /etc/ssmtp/ssmtp.conf

echo "root:"$smtp_user":"$smtp_sport > /etc/ssmtp/revaliases
echo "monitoring:"$smtp_user":"$smtp_sport >> /etc/ssmtp/revaliases
chmod 640 /etc/ssmtp/ssmtp.conf
}


integrity ()
{
logger "integrity<<<<<<<<<<<<<<<<<<<"

local ab3p=""
local trbp=""
local hcp=""
#ab3p=$(ps af | grep $(sed -n 1"p" $fhome"abot3_pid.txt" | tr -d '\r') | grep abot3.sh | awk '{ print $1 }')
#trbp=$(ps af | grep $(sed -n 1"p" $fhome"trbot_pid.txt" | tr -d '\r') | grep trbot.sh | awk '{ print $1 }')
ab3p=$(ps axu| awk '{ print $2 }' | grep $(sed -n 1"p" $fhome"abot3_pid.txt"))
trbp=$(ps axu| awk '{ print $2 }' | grep $(sed -n 1"p" $fhome"trbot_pid.txt"))
hcp=$(ps axu| awk '{ print $2 }' | grep $(sed -n 1"p" $fhome"hchecker_pid.txt"))

logger "ab3p="$ab3p
logger "trbp="$trbp
logger "hcp="$hcp

[ -z "$trbp" ] && logger "starter trbot.sh" && $fhome"trbot.sh" &
[ -z "$ab3p" ] && logger "starter abot3.sh" && $fhome"abot3.sh" &
[ -z "$hcp" ] && logger "starter hchecker.sh" && $fhome"hchecker.sh" &
}



function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" sender_"$bui": "$1

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
	logger "sender url1="$url1"<"
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

sleep $ssec1
done

#sums=$((sendok+senderr))
#[ "$sums" -gt "0" ] && echo $(echo "scale=2; $senderr/$sums * 100" | bc) > $fhome"err_send.txt"
echo $sendok > $fstat"stat_tok_out.txt"
echo $senderr > $fstat"stat_terr_out.txt"

fi


}

#pravka_teg () 
#{
#"<b>" "</b>" " >" все конечные теги дб ОБЯЗАТЕЛЬНо!
#sed 's/ >/B000000000003/g' $mess_path > $fhome"sender_pravkateg_b3.txt"
#sed 's/<b>/B000000000001/g' $fhome"sender_pravkateg_b3.txt" > $fhome"sender_pravkateg_b1.txt"
#sed 's/<\/b>/B000000000002/g' $fhome"sender_pravkateg_b1.txt" > $fhome"sender_pravkateg_b2.txt"
#sed 's/</ /g' $fhome"sender_pravkateg_b2.txt" > $fhome"sender_pravkateg1.txt"
#sed 's/>/ /g' $fhome"sender_pravkateg1.txt" > $fhome"sender_pravkateg2.txt"
#sed 's/B000000000001/<b>/g' $fhome"sender_pravkateg2.txt" > $fhome"sender_pravkateg_b01.txt"
#sed 's/B000000000002/<\/b>/g' $fhome"sender_pravkateg_b01.txt" > $fhome"sender_pravkateg_b02.txt"
#sed 's/B000000000003/ >/g' $fhome"sender_pravkateg_b02.txt" > $fhome"sender_pravkateg_b03.txt"
#cp -f $fhome"sender_pravkateg_b03.txt" $mess_path
#}


directly () {
logger " "
logger "sender directly"
#[ "$(grep -c "<" $mess_path)" -gt "0" ] || [ "$(grep -c ">" $mess_path)" -gt "0" ] && pravka_teg

IFS=$'\x10'
text=$(cat $mess_path)
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

cat $fhome"out2.txt"
cat $fhome"out2_err.txt"

}








PID=$$
echo $PID > $fPID
logger "sender start"
cp -f $fhome"settings.conf" $fhome"sett.conf"

#stat init
echo 0 > $fstat"stat_alert_in.txt"
echo 0 > $fstat"stat_terr_in.txt"
echo 0 > $fstat"stat_terr_out.txt"
echo 0 > $fstat"stat_tok_out.txt"

Init2;

pushg_port=$(echo $pushg | awk -F ":" '{ print $2 }'| tr -d '\r')
logger "sender pushg_port="$pushg_port
if [ "$pushg_port" == "9044" ] || [ "$pushg_port" == "9045" ] || [ "$pushg_port" == "9046" ] || [ "$pushg_port" == "9047" ] || [ "$pushg_port" == "9048" ] || [ "$pushg_port" == "9049" ] || [ "$pushg_port" == "9050" ]; then
	logger "sender start local pushgateway"
	cp -f $fhome"0.sh" $fhome"start_pg.sh"
	echo "su pushgateway -c '/usr/local/bin/pushgateway --web.listen-address=0.0.0.0:${pushg_port}' -s /bin/bash 1>/dev/null 2>/dev/null &" >> $fhome"start_pg.sh"
	chmod +rx $fhome"start_pg.sh"
	$fhome"start_pg.sh"
fi
sleep 1

while true
do
sleep 1
sender;
kkik=$(($kkik+1))
[ "$kkik" -ge "$progons" ] && Init2

done



rm -f $fPID

