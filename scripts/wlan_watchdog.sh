#!/bin/sh
# set -x
export PATH='/media/mmc/scripts:/system/bin:/bin:/sbin:/usr/bin:/usr/sbin'

echo 'check default gateway'
gw_address=''
while [ -z "$gw_address" ]
do
    gw_address=$(route|grep default|awk '{print $2}')
    if [ -z "$gw_address" ];then
        sleep 1
    fi
done

echo 'Default Gateway Address'
echo "$gw_address"

echo 'start wlan watchdog'
count=0
while true
do
    ping -c 1 "$gw_address"
    if [ $? -eq 0 ]; then
        count=0
    else
        count=$((count+=1))
    fi
    if [ $count -ge 3 ] ; then
        echo 'wlan restart'
        ifconfig wlan0 down
        ifconfig wlan0 up
    else
        sleep 10
    fi
done
