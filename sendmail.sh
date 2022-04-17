#!/bin/bash
#скрипт отправки почты
#1- путь/к/mail.txt в формате:
#а-тема
#б-тело письма
#в-вложения через пробел
#2- путь/к/list_mail.txt лист отправки с адресатами со второй строчки и далее
#пример:
#			echo "Прихожая от батареи c "$date2 > $fm
#			echo "Оповещение №1. Прихожая запитана от батареи, заряд составляет "$charge"%, TIMELEFT="$timeleft >> $fm
#			/root/scripts/mail/sendmail.sh "$fm"

fhome=/usr/share/abot2/

p1=$fhome"list_mail.txt"
p2=$fhome"mail.txt"


k1=$(wc -l $p1 | sed -r 's/ .+//' | sed 's/[ \t]*$//')	#кол-во строк
echo $k1


for (( i=2;i<=$k1;i++)); do
MSUBJ=$(sed -n "1p" $p2)
MBODY=$(sed -n "2p" $p2)
ATTACH=$(sed -n "3p" $p2 | tr -d '\r')
MADDR=$(sed -n $i"p" $p1 | tr -d '\r')

echo "отправка почты "$MADDR

if [ -z "$ATTACH" ]; then
echo $MBODY | mutt -s "$MSUBJ" $MADDR
else
echo $MBODY | mutt -s "$MSUBJ" -a $ATTACH -- $MADDR
fi

done








#ТАК работает:
#echo $MBODY | mutt -s "$MSUBJ" -a $ATTACH -- $MADDR
#где:
#MBODY = тело сообщения (например “сборка накрылась медным тазом с кодом ошибки $?”);
#MSUBJ = тема письма;
#ATTACH = список файлов для вложения через пробел после списка обязательно ставить заглушку –, иначе следующие аргументы будут восприняты как файлы.
#MADDR = собственно адрес получателя.

