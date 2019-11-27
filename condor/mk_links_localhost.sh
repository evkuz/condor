#!/bin/bash

#Для всех WN Создаем символические ссылки на файл /nfs/condor/condor-etc/condor_config.localhost
#ln -s /root/real_file.sh /root/wn_221_186
SUBNET="222"

  for IP in $(seq 2 254); do    
  ln -s  /nfs/condor/condor-etc/condor_config.localhost /nfs/condor/condor-etc/condor_config.wn_${SUBNET}_${IP}
  done


