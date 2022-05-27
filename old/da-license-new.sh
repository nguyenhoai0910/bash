#!/bin/sh
############################################
# Created by: hoainh@vinahost.vn
############################################
if grep -Fxq "ethernet_dev=eth0:100" /usr/local/directadmin/conf/directadmin.conf
then
ethernet_dev=eth0:100
else
cat /usr/local/directadmin/conf/directadmin.conf |grep "ethernet_dev="
echo -n "Enter name network: "; read ethernet_dev
fi
ifdown $ethernet_dev; rm -f /tmp/license.key; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://210.211.122.197/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /bin/systemctl restart  directadmin.service
echo -e "DEVICE=$ethernet_dev\nONBOOT=yes\nIPADDR=210.211.122.197\nNETMASK=255.255.255.192" > /etc/sysconfig/network-scripts/ifcfg-$ethernet_dev; ifup $ethernet_dev &>/dev/null
chattr +ia /etc/sysconfig/network-scripts/ifcfg-$ethernet_dev
systemctl restart directadmin
