#!/bin/bash
# make "condor_drain -graceful" for all worknodes in the pool
# 02/07/2020
# Т.к. список узлов берется из файла, то можно регулировать число узлов.
#
#05.11.2020
# Нужен именно список FQDN, а не ip,  о чем говорит имя файла со списком.
SOURCE_FILE="vms_fqdn.lst"

iparray=($(cat $SOURCE_FILE))

for index in ${!iparray[*]}
do
     condor_drain -graceful ${iparray[$index]}
done
echo "Done"

