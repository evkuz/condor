#AGENT="wn_221_"


# Файл получаем из скрипта find
ARR_FILE=/nfs/condor/nodes_back.lst
DEST_FILE=/nfs/condor/nodes_back.lst_00
OUTPUT_FILE=/nfs/condor/output.txt
# Выполняем преобразование ip-адреса xxx.xxx.xxx.xxx из файла $ARR_FILE в FQDN вида xxx-xxx-xxx-xxx.jinr.ru
# Работаем с копией исходного файла ip

\cp -p $ARR_FILE $DEST_FILE

sed -i 's/\./-/g' $DEST_FILE
sed -i 's/$/\.jinr\.ru/' $DEST_FILE

iparray=($(cat $DEST_FILE))
#iparray=($(cat $ARR_FILE))
#ipadr_wn="10.93.221."

START_TIME="$(date)"

for index in ${!iparray[*]}
do
#    ip_wn=$ipadr_wn${iparray[$index]}
    condor_on -startd ${iparray[$index]} > $OUTPUT_FILE 2>&1

done

echo "Script started ad $START_TIME"
echo "Script  finished at $(date)"


