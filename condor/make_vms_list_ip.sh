#!/bin/bash
# Скрипт выдает список ip у запущенных ВМ (HTCondor execute node) в облаке в виде "<ip>" .
# Нужно для выполнения других скриптов, работающих на всех узлах по этому списку.
# Далее это пригодится для выборки узлов из каждой партии.

NODE_LIST="/nfs/condor/nodes_for_edit.lst"
VM_LIST="/nfs/condor/vms_for_edit.lst"
touch $NODE_LIST
cp /dev/null $NODE_LIST

touch $VM_LIST
cp /dev/null $VM_LIST

cd /nfs/condor


# 18.11.2019 Это 3 столбца "vm_id | ip  | vm_name"
 
# 18.11.2019 Вывод скрипта в массив со строками вида "vm_id | ip | vm_name" .
# Удаляем поле id(1-е поле), получаем строку с 2 полями,  меняем в такой строке местами поля 2 и 1.

IFS=$'\n'
vm_array=($(./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
| cut -d ' ' -f2))
unset IFS

# Сортируем массивы одинаковым образом, чтобы сравнение элементов массива прошло корректно
# Отсортированные элементы помещаем в массив 'sorted_vm_array'
# Тут не важен вывод для пользователя, поэтому сортируем без опций, главное, чтобы оба массива одинаково

IFS=$'\n' sorted_vm_array=($(sort -n <<<"${vm_array[*]}"))
unset IFS

for index in ${!sorted_vm_array[*]}
#${!vm_array[*]}
# ${!sorted_vm_array[*]}
do
    echo "${sorted_vm_array[$index]}" >> $VM_LIST
done

rsync $VM_LIST 159.93.221.119:/root/script
