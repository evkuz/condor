#!/bin/bash

# Решаем проблему с неправыльной symlink для файла /etc/condor/condor_config

# Направляем выво wn_startd_peaceful.sh в файл output.txt
# Далее работаем с файлом output.txt

SOURCE="/nfs/condor/output.txt"
DEST="/nfs/condor/output.txt_00"
#\cp -p $SOURCE $DEST

# Удаляем строки, не содержащие Can't find address for master
#sed -i '/.*Can.*/!d' $DEST
# Получаем список хостов, где проблема с symlink
# Теперь из этого списка удаляем строки, содержащие слово 'master'

#sed -i '/.*master.*/d' $DEST

# Получили список строк вида Can't find address for 10-93-221-170.jinr.ru
# Выделяем 5-е поле в каждой строке, остальные удаляем.

cat $DEST | sed -e '/.*Can.*/!d' | sed -e '/.*master.*/d' | cut -d ' ' -f5 | sed -e 's/-/\./g' | sed -e 's/\(^.*\)\(.jinr.ru\)/\1/' > ready_lst

