#!/bin/bash

cd /nfs/condor
#./list_vms.rb --hostname cloud.jinr.ru --port 11366 --path "/RPC2" --no-ssl-verify --credentials "NOvA:HCo67Jsm4" \
#\ | sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt

cat ek_vms_list.txt | \
 sed -e '/^$/d' | sed -e '/.*Stash.*/d' |  cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt
# && less last_octet_list.txt
#sed -i '/^$/d' ek_vms_list.txt
#sed -i '/.*Stash.*/d' ek_vms_list.txt
#cat ek_vms_list.txt | cut -d ' ' -f2 | sed -n 's/\(^10.93.221.\)\(.*\)/\2/p' > last_octet_list.txt
# && less vms_list.txt

#./find_slot_sorted.sh

