#!/bin/bash

# Get list of IPs of all slots visible for condor CM

RESULT_FILE="drain.lst"

touch $RESULT_FILE
cp /dev/null $RESULT_FILE

unset IFS

status_array=($(condor_status | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++'))

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
   echo $FQDN >> $RESULT_FILE

done

#echo "Total status_array elemetns is $(($index + 1))"
echo "Done"

