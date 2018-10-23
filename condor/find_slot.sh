#!/bin/bash

# Скрипт будет сравнивать вывод condor_status с эталонным списком ВМ
# и выдавать пропавший slot

# Тут доступны отладочные сообщения
Part_1=(6 13 21 66 75 80 88 115 119 127 130 133 134 135)
Part_2=(14 20 24 26 27 28 34 78 84 85 86 87 113 114 117 131)
Part_3=(157 158 160 161 162 163 165 167 168 176 178 180 183 184 188 189 190 191 192 193)
Part_4=(5 129 145 146 166 169 170 171 172 173 174 175 177 179 181 182 185 186 187 195)
vm_array=(${Part_1[*]} ${Part_2[*]} ${Part_3[*]} ${Part_4[*]})

echo "vm_array list:"
for index in ${!vm_array[*]}
do
    printf "%4d: %s\n" $index ${vm_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
done
echo "Total vm_array elemetns is $index"
echo ""
echo ""


# -g сортировка по общему числовому значению
IFS=$'\n' sorted_vm_array=($(sort -g <<<"${vm_array[*]}"))
unset IFS

echo "sorted_vm_array list:"
for index in ${!sorted_vm_array[*]}
do
    printf "%4d: %s\n" $index ${sorted_vm_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
done
echo "Total sorted_vm_array elemetns is $index"
echo ""
echo ""




status_array=($(condor_status | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++' | sed -e '/.*execute.*/d'))
#condor_status | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++' | sed -e '/.*execute.*/d'

echo "status_array list:"

for index in ${!status_array[*]}
do
    printf "%4d: %s\n" $index ${status_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
done
echo "Total status_array elemetns is $index"
