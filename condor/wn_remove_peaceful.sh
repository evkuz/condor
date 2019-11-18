#!/bin/bash


AGENT="wn_221_"


# Файл получаем из скрипта find
ARR_FILE=./nodes_for_edit.lst

iparray=($(cat $ARR_FILE))
ipadr_wn="10.93.221."

START_TIME="$(date)"

for index in ${!iparray[*]}
do
date
    ip_wn=$ipadr_wn${iparray[$index]}
    condor_off -startd -peaceful  $AGENT${iparray[$index]}.jinr.ru
done

echo "Script started ad $START_TIME"
echo "Script  finished at $(date)"

