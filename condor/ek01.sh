#!/bin/bash
# Заполняем массив элементами из файла.
# Копируем в массив элементы из файла.

#$ IFS=$'\r\n' GLOBIGNORE='*' command eval  "XYZ=($(</etc/passwd))"
#$ echo "${XYZ[5]}"

vm_array=($(cat last_octet_list.txt))
IFS=$'\n\r' sorted_vm_array=("${vm_array[*]}")
unset IFS


echo "sorted_vm_array list:"

#IFS=$'\n'

#for index in ${!sorted_vm_array[*]}
for index in "${!sorted_vm_array[*]}"
do
echo "arr_index = ${index}, and the value is ${sorted_vm_array[$index]}"
#printf "%2d : %s\n" "$index" "${sorted_vm_array[$index]}"

#echo "$index :  ${sorted_vm_array[$index]}"
done

#echo "Total vm_array elemetns is  (${#sorted_vm_array[*]})"

#echo "${sorted_vm_array[@]}"

#IFS=$'\n' read -d '' -r -a lines < /nfs/condor/last_octet_list.txt
