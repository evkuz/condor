#!/bin/bash


vm_array=($(cat last_octet_list.txt))
IFS=$'\n' sorted_vm_array=($(sort <<<"${vm_array[*]}"))
unset IFS



status_array=($(condor_status | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++' | sed -e '/.*execute.*/d' | sed -n 's/\(^wn_221_\)\(.*\)\(.jinr.ru\)/\2/p'))

# Сортируем массив 'status_array' помещаем вывод в массив 'sorted_status_array'
IFS=$'\n' sorted_status_array=($(sort <<<"${status_array[*]}"))
unset IFS


echo "sorted_status_array list:"

for index in ${!sorted_vm_array[*]}
do
#    printf "%4d: %s\n" $index ${sorted_status_array[$index]}

#echo "arr_index = $index, and the value is ${sorted_status_array[$index]}"

    echo "${sorted_vm_array[$index]}   ${sorted_status_array[$index]}"
done

echo "Total status_array elemetns is $(($index + 1))"


differ=$(echo ${sorted_vm_array[@]} ${sorted_status_array[@]} | tr ' ' '\n' | sort | uniq -u)

IFS=$'\n'
sorted_differ=($(sort <<<"${differ[*]}"))
unset IFS

echo "The differ array has $((${#differ[*]})) number of elements"

for index in ${!sorted_differ[*]}
do
  echo "node  ${sorted_differ[$index]}"
done

