#!/bin/bash
############################################
# Created by: reiji0910
############################################
# save file at /root/add-ipv4.sh
# des: 2 network card, ens33 ip public, ens34 ip private, i want add ip static for ens34.
# replace ifcfg-ens34, config ip to your network
cat /etc/sysconfig/network-scripts/ifcfg-ens34|grep BOOTPROTO
sed -i s/BOOTPROTO=dhcp/BOOTPROTO=static/g /etc/sysconfig/network-scripts/ifcfg-ens34 &> /dev/null
sed -i s/ONBOOT=no/ONBOOT=yes/g /etc/sysconfig/network-scripts/ifcfg-ens34 &> /dev/null
cat /etc/sysconfig/network-scripts/ifcfg-ens34|grep BOOTPROTO
sleep 2
sed -i '/IPADDR/d' /etc/sysconfig/network-scripts/ifcfg-ens34
sed -i '/NETMASK/d' /etc/sysconfig/network-scripts/ifcfg-ens34
sed -i '/GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-ens34
sed -i '/DNS1/d' /etc/sysconfig/network-scripts/ifcfg-ens34
sleep 3
/bin/cat<<EOM >> /etc/sysconfig/network-scripts/ifcfg-ens34
IPADDR=192.168.56.10
NETMASK=255.255.255.0
GATEWAY=192.168.56.2
DNS1=8.8.8.8
EOM
systemctl restart network &> /dev/null
echo "";
echo -n "IP: ";  hostname -I;
echo -n "Hostname: "; hostname;
echo "-------------------------"
