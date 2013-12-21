#!/bin/bash --
#
# Random MAC adress changer
# http://www.360percents.com
#
#

if [ "$UID" -eq "0" ]
then
	oldmac=`ifconfig -a | grep HWaddr | grep eth0 | awk '{print $NF}'`
	echo "Old mac adress: $oldmac"
	newmac=`echo $RANDOM$RANDOM | md5sum | sed -r 's/(..)/\1:/g; s/^(.{17}).*$/\1/;'`
	sudo ifconfig eth0 down
	sudo /etc/init.d/networking stop > /dev/null
	sudo ifconfig eth0 hw ether $newmac
	sudo /etc/init.d/networking start > /dev/null
	sudo ifconfig eth0 up
	sudo dhclient	
	echo "New mac adress: $newmac"
	
else
  echo "You need to be root to run this script. run: sudo $0"
fi
