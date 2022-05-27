#!/bin/sh
############################################
# Name: add-swap.sh
#
# Created by: hoainh@vinahost.vn
############################################

echo -n "Enter quote swap: "
read quote
if [ $quote -gt 0 ] && [ $quote -lt 8 ]
then
  swap=`expr $quote \* 1024`
  k=k
  count=$swap$k
else
  count=2048k
fi
echo $count
echo ""

# Swap
dd if=/dev/zero of=/swapfile bs=1024 count=$count
mkswap /swapfile
swapon /swapfile
chown root:root /swapfile
chmod 0600 /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# Swappiness
echo "swappiness = 0: swap chi duoc dung khi RAM duoc su dung het"
echo "swappiness = 10: swap duoc su dụng khi RAM con 10%."
echo "swappiness = 60: gia tri mac dinh"
echo "swappiness = 100: swap duoc uu tien nhu la RAM."
echo -n "Enter swappiness: ";
read swappiness
echo "vm.swappiness = $swappiness" >> /etc/sysctl.conf
swapon -s
cat  /etc/sysctl.conf | grep "vm.swappines"
cat /proc/sys/vm/swappiness