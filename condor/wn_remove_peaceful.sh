#!/bin/bash


AGENT="wn_"


# Файл получаем из скрипта find
ARR_FILE=/nfs/condor/nodes_for_edit.lst

iparray=($(cat $ARR_FILE))
#ipadr_wn="10.93.221."

START_TIME="$(date)"

for index in ${!iparray[*]}
do
#    ip_wn=$ipadr_wn${iparray[$index]}
	ip_wn=${iparray[$index]}
	SUBN=$(echo $ip_wn | cut -d'.' -f3)
	NUM=$(echo $ip_wn | cut -d'.' -f4)
#	FQDN="wn_"${SUBN}"_"${NUM}".jinr.ru"
        FQDN=${iparray[$index]}
	condor_off -startd -peaceful $FQDN
#        echo ${iparray[$index]}
done

echo "Script started ad $START_TIME"
echo "Script  finished at $(date)"

