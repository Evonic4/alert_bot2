#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/abot2/
fmail=$fhome"mail.txt"

smtp_user=$(sed -n 38"p" $fhome"sett.conf" | tr -d '\r')
to_mail=$(sed -n 41"p" $fhome"sett.conf" | tr -d '\r')
MSUBJ=$(sed -n "1p" $fmail | tr -d '\r')
MBODY=$(sed -n "2p" $fmail | tr -d '\r')

if ! [ "$to_mail" == "" ]; then
for MADDR in $(echo $to_mail | tr " " "\n")
do
echo "send mail to "$MADDR

IFS=$'\x10'
printf '%s\n' "Subject: "$MSUBJ \
   "" \
   $MBODY \
   "----" |
sendmail -f $smtp_user -t $MADDR
unset IFS

done
else
	echo "to_mail is NULL"
fi
