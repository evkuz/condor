#!/bin/bash

#
# 26.12.2018
# Переделываем скрипт на восстановление ВМ, ранее "вынутой" из кластера обратно на запуск задач.
# Т.е. удаляем символьную ссылку на 'condor_config.localhost_remove' и создаем заново ссылку на 'condor_config.localhost'
# для заданного массива узлов

#
# 30.11.2018
# ОБновим, теперь не надо создавать отдельный файл вида 'condor_config.localhost_186'
# Вместо этого создал на nfs файл condor_config.localhost_remove с опцией 'START=FALSE'
# И все узлы на отключение будут иметь ссылку не на 'condor_config.localhost', а на 'condor_config.localhost_remove'


# Получаем список узлов на исключение. В этом файле задается массив WNs_RESTORE_array
source ./wn_restore.cfg

ipadr_wn="10.93.221."
PATH_TO_WN_CONFIG="/nfs/condor/condor_etc/condor_config.localhost_"
PATH_TO_SYMLINK="/nfs/condor/condor-etc/condor_config.wn_221_"
CONFIG_REMOVE="/nfs/condor/condor-etc/condor_config.localhost_remove"
CONFIG_RESTORE="/nfs/condor/condor-etc/condor_config.localhost"

echo "WNs to restore:" # Выводим записи массива с их индексами
for index in ${!WNs_RESTORE_array[*]}
do
    printf "%4d: %s\n" $index ${WNs_RESTORE_array[$index]}
#echo "Host $HOSTNAME start at"
#date

#    ip_wn=$ipadr_wn${iparray[$index]}
#    ssh root@$ip_wn 'bash -s' < $SCRIPT_NAME
#    printf "  ip: %s\n" ${ip_wn}
done

# Выясняем правильно ли задан список узлов на ВОССТАНОВЛЕНИЕ

echo -n "Does the above WN's list TO RESTORE is correct ? (y/n) "

read item
case "$item" in
    y|Y) echo "We are going to continue soon"
 #        echo "SEE YOU"
 #       exit 0

#        echo "The symlink to remove is"
	for index in ${!WNs_RESTORE_array[*]}
	do
#	    printf "%4d: %s\n" $index ${WNs_RESTORE_array[$index]}
#            rm $PATH_TO_WN_CONFIG${WNs_RESTORE_array[$index]}
#            echo "1. Create config file $PATH_TO_WN_CONFIG${WNs_RESTORE_array[$index]}"
#            touch $PATH_TO_WN_CONFIG${WNs_RESTORE_array[$index]}
#            echo "DAEMON_LIST = MASTER, STARTD" >> $PATH_TO_WN_CONFIG${WNs_RESTORE_array[$index]}
#            echo "START=FALSE" >> $PATH_TO_WN_CONFIG${WNs_RESTORE_array[$index]}
            echo "3. The symlink to remove is"
            echo "$PATH_TO_SYMLINK${WNs_RESTORE_array[$index]}"

           # Удаляем текущую ссылку на конфиг
            rm $PATH_TO_SYMLINK${WNs_RESTORE_array[$index]}
            echo "4. create new symlink"
          # Создаем новую ссылку на конфиг для ЗАПУСКа задач
            NEWSYMLINK="ln -s $CONFIG_RESTORE $PATH_TO_SYMLINK${WNs_RESTORE_array[$index]}"
            echo "$NEWSYMLINK"
            ln -s $CONFIG_RESTORE $PATH_TO_SYMLINK${WNs_RESTORE_array[$index]}
            echo "5. Apply new settings on WN $ipadr_wn${WNs_RESTORE_array[$index]}"
            
	    ssh root@$ipadr_wn${WNs_RESTORE_array[$index]} "condor_reconfig"

#            ssh root@$ip_wn 'bash -s' < $SCRIPT_NAME
#            printf "  ip: %s\n" ${ip_wn}
        done
        ;;
    n|N) echo "The list is not correct so change the config file wn_off.cfg and start again"
         echo "The END"
         
        exit 0
        ;;
    *) echo "Ничего не ввели. Выполняем действие по умолчанию..."
        ;;
esac
