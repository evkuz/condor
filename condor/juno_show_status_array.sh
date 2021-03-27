#!/bin/bash

# Get list of IPs of all slots visible for condor CM
SOURCE_FILE="vms_fqdn.lst"
NODE_LIST="./nodes_for_edit.lst"
STATUS_LIST="./status.lst"

CREDEN_JUNO="juno-local:n4TWA5xCuXh9U"
CREDEN_EVKUZ="eVg_AleX"
CREDS_ARRAY=(${CREDEN_JUNO})
CONSTR="Machine_Type==\"JUNO\""

#Опустошаем
#touch $NODE_LIST
cp /dev/null $NODE_LIST
cp /dev/null $STATUS_LIST


unset IFS

status_array=($(condor_status -constraint $CONSTR | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++'))

# Сортируем массив 'status_array' помещаем вывод в массив 'sorted_status_array'
IFS=$'\n' sorted_status_array=($(sort <<<"${status_array[*]}"))
unset IFS


#echo "sorted_status_array list:"

for index in ${!sorted_status_array[*]}
do
#    printf "%4d: %s\n" $index ${sorted_status_array[$index]}

#echo "arr_index = $index, and the value is ${sorted_status_array[$index]}"
#    echo "$index   ${sorted_status_array[$index]}"
   FQDN=$(echo ${sorted_status_array[$index]})
# | sed -e 's/-/\./g' | sed -e 's/\.jinr\.ru//g')
   echo $FQDN >> $STATUS_LIST

done

cp -p $STATUS_LIST $SOURCE_FILE
# now make list of VMs ip
./convert_nodes_fqdn_2_ip.sh
#echo "Total status_array elemetns is $(($index + 1))"
echo "Done"

