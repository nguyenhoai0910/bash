#!/bin/sh
############################################
# Name: da-brute.sh
#
# Created by: hoainh@vinahost.vn
############################################
#install brute force
cd ~
wget -O csf-bfm-install.sh https://raw.githubusercontent.com/poralix/directadmin-bfm-csf/master/install.sh
chmod 700 csf-bfm-install.sh
./csf-bfm-install.sh

#export ip brute
cat /usr/local/directadmin/data/admin/brute_log_entries.list | cut -d= -f5 | sed 's/\&.*//' | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e | sed 's/ /\n/g' | sort -n | uniq > ip.brute.force.txt

#add.ip.brute.force.sh
csf -a 123.30.108.100 &>/dev/null
csf -a 125.212.220.68 &>/dev/null
for i in `more ip.brute.force.txt `
do
if grep "$i" /etc/csf/csf.deny
then
 echo " [$i] is in already in the deny file /etc/csf/csf.deny"
else
echo $i >> blocked_ips.txt
csf -d $i
fi
done
