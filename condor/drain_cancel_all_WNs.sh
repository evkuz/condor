#!/bin/bash
# make "condor_drain -graceful" for all worknodes in the pool

SOURCE_FILE="vms_fqdn.lst"

iparray=($(cat $SOURCE_FILE))

for index in ${!iparray[*]}
do
     condor_drain -cancel ${iparray[$index]}
done
echo "Done"

