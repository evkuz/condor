#!/bin/bash

FULL_LIST="full_list.lst"
CONSTR="Machine_Type==\"JUNO\""
cp /dev/null $FULL_LIST
#condor_status -constraint $CONSTR | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++' | sed -e '/.*execute.*/d' | sed -e '/.*vm.*/d' > stat.lst

# Получаем эталонный массив из ruby-скрипта
IFS=$'\n'
vm_array+=($(./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "juno-local:n4TWA5xCuXh9U" \
| sed -e '/^$/d' | sed -e '/.*JUNO-Build.*/d' | cut -d ' ' -f2))

#| sed -e '/^$/d' | sed -e '/.*JUNO-Build.*/d'))
# | cut -d ' ' -f2))
# | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p'))
#juno-local:n4TWA5xCuXh9U
#NOvA:HCo67Jsm4

IFS=$'\n' sorted_vm_array=($(sort <<<"${vm_array[*]}"))
unset IFS

#echo "sorted_vm_array list:"
for index in ${!sorted_vm_array[*]}
do
#    printf "%4d: %s\n" $index ${sorted_vm_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
echo "${sorted_vm_array[$index]}" >> $FULL_LIST
done

