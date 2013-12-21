#!/bin/bash

bridge_status=`cat .bridge_status.txt`
if [ "$bridge_status" == "down" ]
then
sudo ifconfig eth0 0.0.0.0
sudo ifconfig usb0 0.0.0.0
sudo brctl addbr br0
sudo brctl addif br0 eth0
sudo brctl addif br0 usb0
sudo ifconfig br0 up
sudo dhclient br0 
echo "up" > .bridge_status.txt
elif [ "$bridge_status" == "up" ]
then
sudo ifconfig eth0 down
sudo ifconfig usb0 down
sudo ifconfig br0 down
sudo brctl delbr br0
sudo ifconfig eth0 up
sudo dhclient eth0
echo "down" > .bridge_status.txt
else
sudo ifconfig eth0 0.0.0.0
sudo ifconfig usb0 0.0.0.0
sudo brctl addbr br0
sudo brctl addif br0 eth0
sudo brctl addif br0 usb0
sudo ifconfig br0 up
sudo dhclient br0 
echo "up" > .bridge_status.txt
fi