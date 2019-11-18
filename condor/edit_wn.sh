#!/bin/bash

# 12.10.2018 уже 70 узлов
# 05.12.2017 уже 50 узлов


#Выполнение скрипта на всех wn
#

#SCRIPT_NAME="/root/script/change_route.sh"
#SCRIPT_NAME="install_puppet_agent.sh"
#SCRIPT_NAME="remove_old_puppet.sh"
#SCRIPT_NAME="/root/script/push_puppet.sh"
#SCRIPT_NAME="/root/script/downgrade_xrootd.sh"
#SCRIPT_NAME="/root/script/change_runinterval.sh"
#SCRIPT_NAME="add_mu2e_VO_to_cluster.sh"
#SCRIPT_NAME="/root/script/ce_script/reconfig_condor.sh"

#SCRIPT_NAME="update_osg_33_to_34.sh"
#SCRIPT_NAME="/root/script/change_environment_sed.sh"
#SCRIPT_NAME="/root/script/start_service_not_running.sh"


#COMMAND_NAME="yum -y install libgomp"
#COMMAND_NAME="date"
#COMMAND_NAME="puppet cert clean"

#COMMAND_NAME="service rsyslog restart" # Нужно, чтобы узлы не слетали с синхронизации puppet
#COMMAND_NAME="puppet agent -t" # Для восстановления синхронизации
COMMAND_NAME="condor_reconfig"

# "init 6" Нужно, когда ВМ не синхронизирована с мастером, и обращается к нему с "чужим" hostname
#COMMAND_NAME="init 6" # Совсем перегружать необязательно, достаточно перезапустить rsyslog !!!

# restore runinterval to default value
#COMMAND_NAME="sed -i '/^runinterval.*/d' /etc/puppetlabs/puppet/puppet.conf" # Восстанавливаем runinterval до значения по умолчанию


AGENT="wn_221_"

# Всего их 50шт., поэтому если некоторые надо исключить, то также редактируем значение wn_count


# Это полный массив узлов

#iparray=(  4   6  14  24  26  27  28  34  84  85
#          86  87 113 127 129 130 157 158 160 161
#         162 163 165 167 168 169 170 171 172 173
#         174 175 176 177 178 179 180 181 182 183
#         184 185 186 187 188 189 190 191 192 193)

# Массив узлов из Партии №1
# Part_1 = (169, 170, 171, 172, 173, 174, 175, 177, 179, 181, 182, 185, 186, 187)

# А это массив узлов из Партии №2
# Part_2 = (113, 4, 6, 14, 24, 26, 27, 28, 34, 84, 85, 86, 87, 127, 129, 130)


# Это исключаемые узлы 
# exclude=(14 127 129 130)

#iparray=(  2   4  6   24  26  27  28  34  84
#          85  86  87 157 158 160 161
#         162 163 165 167 168 169 170 171 172 173
#         174 175 176 177 178 179 180 181 182 183
#         184 185 186 187 188 189 190 191 192 193)

#18.10.2018
#iparray=(6 14 26 28 115 120 166 168 169 170 171 179 184 185)
#iparray=(75 127 129 130 171 175 185 191 192 195)
#iparray=(171 175 191 192 185) # runinterval restore except 195
#iparray=(80 84)




#wn_count=5
#ARR_FILE=/root/last_octet_list.txt

# Файл получаем из скрипта find
ARR_FILE=./nodes_for_edit.lst

iparray=($(cat $ARR_FILE))
ipadr_wn="10.93.221."

###############################  Old school :) ###################################
#i=0
# while [ $i -lt $wn_count ]
#do
#ip_wn=$ipadr_wn${iparray[i]}

#ssh root@$ip_wn 'bash -s' < $SCRIPT_NAME
#ssh root@$ip_wn "$COMMAND_NAME"

#i=$[$i+1]
#done
########################### END of old school ###################################

echo "Array items and indexes:" # Выводим записи массива с их индексами
sleep 2
START_TIME="$(date)"

for index in ${!iparray[*]}
do
#    printf "%4d: %s\n" $index ${iparray[$index]}
echo "Host $AGENT${iparray[$index]}.jinr.ru start at"
date
    ip_wn=$ipadr_wn${iparray[$index]}
#    ssh root@$ip_wn 'bash -s' < $SCRIPT_NAME
    ssh root@$ip_wn $COMMAND_NAME 
    sleep 1
#    printf "  ip: %s\n" ${ip_wn}
done

echo "Script started ad $START_TIME"
echo "Script  finished at $(date)"
#date


#  ${arr[*]} # Все записи в массиве
#  ${!arr[*]}# Все индексы в массиве
#  ${#arr[*]}# Количество записей в массиве
#  ${#arr[0]}# Длина первой записи (нумерация с нуля)
