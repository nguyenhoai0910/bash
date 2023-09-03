#!/bin/bash
ll /etc/netplan/*-installer-config.yaml
read -p 'file: ' file
cat /etc/netplan/`$file`
sleep 5
read -p 'interface: ' interface
read -p `$interface`' address: ' address
read -p `$interface`' netmask (24): ' netmask
/bin/cat<<EOM >> /etc/netplan/`$file`
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      dhcp4: true
    $interface:
       addresses:
                - $address/$netmask
  version: 2
EOM
sleep 5
sudo netplan apply
