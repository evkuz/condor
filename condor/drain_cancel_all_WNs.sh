#!/bin/bash
# make "condor_drain -cancel" for all worknodes in the pool

SOURCE_FILE="vms_fqdn.lst"
OUTPUT_FILE="result_of_ddrain_cancel.txt"

iparray=($(cat $SOURCE_FILE))

for index in ${!iparray[*]}
do
     condor_drain -cancel ${iparray[$index]} > $OUTPUT_FILE
done
echo "Done"

