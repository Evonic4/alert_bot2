#!/bin/bash

f1=/usr/share/abot2/


cd $f1
perl -pi -e "s/\r\n/\n/" ./*.txt
perl -pi -e "s/\r\n/\n/" ./*.sh
chmod +rx ./*.sh
