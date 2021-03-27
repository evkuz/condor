#ОБъединяем в скрипт

cp /dev/null vms_fqdn.lst
nano vms_fqdn.lst
./convert_nodes_fqdn_2_ip.sh
rsync -a nodes_for_edit.lst 159.93.221.119:/root/script

echo "Done"
