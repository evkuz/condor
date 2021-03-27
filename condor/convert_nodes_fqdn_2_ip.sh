#!/bin/bash

# Выполняем обратное преобразование
SOURCE_FILE="vms_fqdn.lst"
RESULT_FILE="nodes_for_edit.lst"

touch $RESULT_FILE
cp /dev/null $RESULT_FILE

iparray=($(cat $SOURCE_FILE))

for index in ${!iparray[*]}
do
   FQDN=$(echo ${iparray[$index]} | sed -e 's/-/\./g' | sed -e 's/\.jinr\.ru//g')
  echo $FQDN >> $RESULT_FILE
done
echo "Done"
