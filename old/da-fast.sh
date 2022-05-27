#!/bin/sh
############################################
# Name: da-fast.sh
#
# Created by: hoainh@vinahost.vn
############################################
/usr/local/directadmin/scripts/set_permissions.sh all
cd /usr/local/directadmin/custombuild
./build set_fastest
./build version
/usr/local/directadmin/directadmin c | grep -i 'version='