#!/bin/bash
# Скрипт convert_nodes_ip_2_fqdn.sh конвертирует ip-адрес
#  вида ххх.ххх.ххх.ххх в FQDN 
#  вида xxx-xxx-xxx-xxx.jinr.ru

SOURCE_FILE="nodes_for_edit.lst"
RESULT_FILE="vms_fqdn.lst"

touch $RESULT_FILE
cp /dev/null $RESULT_FILE

iparray=($(cat $SOURCE_FILE))

for index in ${!iparray[*]}
do
   FQDN=$(echo ${iparray[$index]} | sed -e 's/\./-/g').jinr.ru
  echo $FQDN >> $RESULT_FILE
done
echo "Done"

