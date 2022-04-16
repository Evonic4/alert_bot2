#!/bin/bash

fhome=/usr/share/abot2/
fcache=$fhome"cache/1/"


while true 
do

nc -l -p 9087 > $fcache"1.xt"
head -n 7 $fcache"1.xt" | tail -n 1 | jq '.'
echo ""
echo ""
echo ""
echo ""
echo ""

sleep 1

done


