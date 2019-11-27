#!/bin/bash

# Скрипт будет сравнивать вывод condor_status с эталонным списком ВМ
# и выдавать пропавший slot

# Все ВМ, являющиеся узлами condor pool NOvA (CPN), работают на серверах из 4 партий поставки.
# Ниже эти ВМ рассортированы по массивам, в зависимости от номера партии поставки.
# число в массиве означает последний октет в ip адресе ВМ 10.93.221.xxx
# т.е. '6' означает ip=10.93.221.6
# В итоге получаем 4 массива ip для 4 партий серверов

NODE_LIST="./nodes_for_edit.lst"

#Опустошаем
#touch $NODE_LIST
cp /dev/null $NODE_LIST

# Комментим за ненадобностью, нужно было для тестов
#Part_1=(6 13 21 66 75 80 88 115 119 127 130 133 134 135)
#Part_2=(14 20 24 26 27 28 34 78 84 85 86 87 113 114 117 131)
#Part_3=(157 158 160 161 162 163 165 167 168 176 178 180 183 184 188 189 190 191 192 193)
#Part_4=(5 129 145 146 166 169 170 171 172 173 174 175 177 179 181 182 185 186 187 195)

# А это общий массив ВМ, состоящий из всех 4 партий
#vm_array=(${Part_1[*]} ${Part_2[*]} ${Part_3[*]} ${Part_4[*]})

#cd /nfs/condor
#./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
# | sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt

#list_of_vms="last_octet_list.txt"
#vm_array=($(cat $list_of_vms))

# Получаем эталонный массив из ruby-скрипта
vm_array=($(./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
 | sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2))
# | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p'))


# Сортируем массивы одинаковым образом, чтобы сравнение элементов массива прошло корректно
# Отсортированные элементы помещаем в массив 'sorted_vm_array'
# Тут не важен вывод для пользователя, поэтому сортируем без опций, главное, чтобы оба массива одинаково
IFS=$'\n' sorted_vm_array=($(sort <<<"${vm_array[*]}"))
unset IFS

#echo "sorted_vm_array list:"
#for index in ${!sorted_vm_array[*]}
#do
#    printf "%4d: %s\n" $index ${sorted_vm_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
#done
#echo "Total sorted_vm_array elemetns is $index"
#echo ""
#echo ""

# Теперь формируем массив узлов, который виден через condor_status
# из имени слота вида wn_221_xxx.jinr.ru вырезаем 'xxx'
# Берем первое поле вывода condor_status, вырезаем все, кроме последнего октета ip, удаляем повторяющиеся элементы, удаляем execute хосты - не члены CPN
# Вывод этой команды и помещаем в массив 'status_array'
status_array=($(condor_status | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++' | sed -e '/.*execute.*/d' | sed -n 's/\(^wn_\)\(.*\)\(.jinr.ru\)/\2/p'))

# Сортируем массив 'status_array' помещаем вывод в массив 'sorted_status_array'
IFS=$'\n' sorted_status_array=($(sort <<<"${status_array[*]}"))
unset IFS


echo "sorted_status_array list:"

for index in ${!sorted_status_array[*]}
do
    printf "%4d: %s\n" $index ${sorted_status_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
done

result=$index+1
echo "Total status_array elemetns is $result"

# Сравниваем массивы, разницу помещаем в массив 'differ'
# Создаем строку из элементов обоих массивов, меняем в этой строке пробел на перевод строки, вырезаем из этой строки
# только единожды встреченные элементы (уникальные), помещаем в массив
# Делаем проверку, если в массиве нуль элементов, то пишем, что все ОК, если есть разница в элементах - выводим эту разницу.
differ=$(echo ${sorted_vm_array[@]} ${sorted_status_array[@]} | tr ' ' '\n' | sort | uniq -u)

#SUBTRACTION=$((2-1))
#echo " The math subtraction 2 - 1 is ${SUBTRACTION}"

echo "The differ array has $((${#differ[*]})) number of elements"


IFS=$'\n'
sorted_differ=($(sort <<<"${differ[*]}"))
unset IFS

#echo "The differ array has $((${#sorted_differ[*]})) number of elements"
#echo "The absent worknodes are :"

for index in ${!sorted_differ[*]}
do
  echo "${sorted_differ[$index]}" >> $NODE_LIST
done

#Сохраняем на хост VM119
#rsync /nfs/condor/nodes_for_edit.lst 159.93.221.119:/root/script

# Один элемент массива всегда есть - это сам массив, т.е. область памяти, где начинается массив, 
# это его же нулевой индекс.
#if [ ${#differ[*]} -gt 1 ]
#  then
#  echo "The absent worknodes are :"
#  echo "${differ}"
#  else 
#    echo "There is no WNs to add. Don't worry, be happy !"
#fi

