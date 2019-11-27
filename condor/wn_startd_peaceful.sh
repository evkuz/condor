AGENT="wn_221_"


# Файл получаем из скрипта find
ARR_FILE=/nfs/condor/nodes_back.lst
# nodes_back.lst
iparray=($(cat $ARR_FILE))
ipadr_wn="10.93.221."

START_TIME="$(date)"

for index in ${!iparray[*]}
do
date
    ip_wn=$ipadr_wn${iparray[$index]}
    condor_on -startd $AGENT${iparray[$index]}.jinr.ru
done

echo "Script started ad $START_TIME"
echo "Script  finished at $(date)"


