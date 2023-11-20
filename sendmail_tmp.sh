#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/abot2/
to_mail=$(sed -n 41"p" $fhome"sett.conf" | tr -d '\r')

if ! [ "$to_mail" == "" ]; then
for MADDR in $(echo $to_mail | tr " " "\n")
do
echo "send mail to "$MADDR
