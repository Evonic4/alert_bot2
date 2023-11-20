#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/abot2/
fmail=$fhome"mail.txt"
bui=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
to_mail=$(sed -n 41"p" $fhome"sett.conf" | tr -d '\r')
MSUBJ=$(sed -n "1p" $fmail | tr -d '\r')
MBODY=$(sed -n "2p" $fmail | tr -d '\r')


function logger()
{
local date1=$(date '+ %Y-%m-%d %H:%M:%S')
echo $date1" sendmail_"$bui": "$1
}



if ! [ "$to_mail" == "" ]; then
for MADDR in $(echo $to_mail | tr " " "\n")
do
logger "send mail to "$MADDR

IFS=$'\x10'
su monitoring -c 'cd; echo $MBODY | mail -s $MSUBJ $MADDR' -s /bin/bash
unset IFS

done
else
	logger "to_mail is NULL"
fi
