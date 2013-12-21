#!/bin/bash
echo "Erasing old configuration"
sudo route del default
sudo ifconfig tap0 down
sudo ifconfig eth0 down
sudo ifconfig br0 down
sudo brctl delbr br0
sleep 1
 
echo "Creating virtual interface"
sudo chown chris /dev/sdc1
sudo tunctl -t tap0 -u afrodeity
sleep 1
echo "Creating bridge interface"
sudo brctl addbr br0
sleep 1
echo "Making physical interface promiscuous"
sudo ifconfig eth0 0.0.0.0 promisc
sleep 1
echo "Binding bridge to physical interface"
sudo brctl addif br0 eth0
sleep 1
#sudo ifconfig br0 10.255.203.34 netmask 255.255.255.0
echo "Configuring IP address"
sudo ifconfig br0 198.206.186.210 netmask 255.255.255.0
# sudo dhclient br0 # The new way!
sleep 1
echo "Binding bridge to virtual interface"
sudo brctl addif br0 tap0
sleep 1
echo "Enabling virtual interface"
sudo ifconfig tap0 up
sleep 1
#sudo route add default gw 10.255.203.254
echo "Adding default route"
sudo route add default gw 198.206.186.254
echo "All done!"
