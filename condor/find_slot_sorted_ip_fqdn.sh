#!/bin/bash

# Скрипт будет сравнивать вывод condor_status с эталонным списком ВМ
# и выдавать пропавший slot


NODE_LIST="./nodes_for_edit.lst"
FULL_LIST="./full_list.lst"
STATUS_LIST="./status.lst"

CREDEN_NOVA="NOvA:HCo67Jsm4"
CREDEN_JUNO="juno-local:n4TWA5xCuXh9U"
CREDEN_EVKUZ="eVg_AleX"
CREDS_ARRAY=(${CREDEN_JUNO})
#${CREDEN_NOVA}
CONSTR="Machine_Type==\"JUNO\""

#Опустошаем
#touch $NODE_LIST
cp /dev/null $NODE_LIST
cp /dev/null $FULL_LIST
cp /dev/null $STATUS_LIST

# А это общий массив ВМ, состоящий из всех 4 партий
#vm_array=(${Part_1[*]} ${Part_2[*]} ${Part_3[*]} ${Part_4[*]})

#cd /nfs/condor
#./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
# | sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt

#list_of_vms="last_octet_list.txt"
#vm_array=($(cat $list_of_vms))

for index in ${!CREDS_ARRAY[*]}
do

# Получаем эталонный массив из ruby-скрипта
# Исключаем узлы TEST и JUNO-Build-Server, тогда файл full_list.lst содержит только искомые узлы
IFS=$'\n'
vm_array+=($(./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials ${CREDS_ARRAY[$index]} \
| sed -e '/^$/d' | sed -e '/.*JUNO-Build.*/d' | sed -e '/.*TEST.*/d' | cut -d ' ' -f2))
# | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p'))
#juno-local:n4TWA5xCuXh9U
#NOvA:HCo67Jsm4

# Сортируем массивы одинаковым образом, чтобы сравнение элементов массива прошло корректно
# Отсортированные элементы помещаем в массив 'sorted_vm_array'
# Тут не важен вывод для пользователя, поэтому сортируем без опций, главное, чтобы оба массива одинаково
IFS=$'\n' sorted_vm_array=($(sort <<<"${vm_array[*]}"))
unset IFS

#echo "sorted_vm_array list:"
for index in ${!sorted_vm_array[*]}
do
#    printf "%4d: %s\n" $index ${sorted_vm_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
echo "${sorted_vm_array[$index]}" >> $FULL_LIST
done
#echo "Total sorted_vm_array elemetns is $index"
#echo ""
#echo ""

# Теперь формируем массив узлов, который виден через condor_status
# из имени слота вида wn_221_xxx.jinr.ru вырезаем 'xxx'
# Берем первое поле вывода condor_status, вырезаем все, кроме последнего октета ip, удаляем повторяющиеся элементы, удаляем execute хосты - не члены CPN
# Вывод этой команды и помещаем в массив 'status_array'

done # CREDS_ARRAY


#30.12.2019 Теперь FQDN имеет вид XXX-XXX-XXX-XXX.jinr.ru где XXX - октеты ip-адреса.

status_array=($(condor_status -constraint $CONSTR | cut -d ' ' -f1 | sed -n 's/^slot[0-9]@//p' | awk '!seen[$0]++' | sed -e '/.*execute.*/d' | sed -e '/.*vm.*/d'))
# | sed -n 's/\(^wn_\)\(.*\)\(.jinr.ru\)/\2/p'))

# Сортируем массив 'status_array' помещаем вывод в массив 'sorted_status_array'
IFS=$'\n' sorted_status_array=($(sort <<<"${status_array[*]}"))
unset IFS


#echo "sorted_status_array list:"

for index in ${!sorted_status_array[*]}
do
#    printf "%4d: %s\n" $index ${sorted_status_array[$index]}
#echo "arr_index = $index, and the value is ${status_array[$index]}"
echo "${sorted_status_array[$index]}" >> $STATUS_LIST
done

# Приводим к единому виду содержимое массивов.
# Так, чтобы элементы массива status_array имели такой же формат как в массиве vm_array
sed -i 's/-/./g' $STATUS_LIST
sed -i 's/\(^.*\)\(.jinr.ru\)/\1/' $STATUS_LIST
#Создаем массив заново в нужном формате
status_array=($(cat $STATUS_LIST))
# Сортируем массив 'status_array' помещаем вывод в массив 'sorted_status_array'
IFS=$'\n' sorted_status_array=($(sort <<<"${status_array[*]}"))
unset IFS

result=$index+1
echo "Total status_array elemetns is $result"

# 30.12.2019 Теперь надо сравнивать ip вида xxx.xxx.xxx.xxx и FQDN вида XXX-XXX-XXX-XXX.jinr.ru
# При этом каждая часть ip xxx должна быть равна соответствующей части FQDN XXX.


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

