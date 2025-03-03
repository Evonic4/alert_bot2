#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/abot2/
fPID=$fhome"h_pid.txt"

PID=$$
echo $PID > $fPID

while true; do (echo -e "HTTP/1.1 200 OK"; echo -e "Content-Type: application/json\n"; echo -e $(cat ${fhome}h.json | jq ".")"\n") | timeout 1 nc -l -p 9444; done

rm -f $fPID

