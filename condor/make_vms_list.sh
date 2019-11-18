#!/bin/bash
# Скрипт выдает только список запущенных ВМ (HTCondor execute node)  в облаке.
# Нужно для выполнения других скриптов, работающих на всех узлах по этому списку.
NODE_LIST="/nfs/condor/nodes_for_edit.lst"
touch $NODE_LIST
cp /dev/null $NODE_LIST

cd /nfs/condor
#./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
#\ | sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt

#cat ek_vms_list.txt | \
# sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt

# && less last_octet_list.txt
#sed -i '/^$/d' ek_vms_list.txt
#sed -i '/.*Stash.*/d' ek_vms_list.txt
#cat ek_vms_list.txt | cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt
# && less vms_list.txt

#./find_slot_sorted.sh



# Получаем эталонный массив из ruby-скрипта
vm_array=($(./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
 | sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p'))


# Сортируем массивы одинаковым образом, чтобы сравнение элементов массива прошло корректно
# Отсортированные элементы помещаем в массив 'sorted_vm_array'
# Тут не важен вывод для пользователя, поэтому сортируем без опций, главное, чтобы оба массива одинаково
IFS=$'\n' sorted_vm_array=($(sort -n <<<"${vm_array[*]}"))
unset IFS

#touch $NODE_LIST
#cp /dev/null  ./last_octet_list.txt
#echo "sorted_vm_array list:"
for index in ${!sorted_vm_array[*]}
do
#    printf "%4d: %s\n" $index ${sorted_vm_array[$index]} > last_octet_list.txt
    echo "${sorted_vm_array[$index]}" >> $NODE_LIST
#echo "arr_index = $index, and the value is ${status_array[$index]}"
done

rsync $NODE_LIST 159.93.221.119:/root/script
