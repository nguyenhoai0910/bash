#!/bin/sh
############################################
# Name: cpanel-ipmail.sh
#
# Created by: hoainh@vinahost.vn
############################################
echo -n "Enter IP-Check: > "
read IPCHECK
csf -g $IPCHECK
csf -dr $IPCHECK
#cat /var/log/maillog | grep `date -I` | grep $IPCHECK
grep $IPCHECK /var/log/maillog | grep "auth"