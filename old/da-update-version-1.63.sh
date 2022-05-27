#!/bin/sh
############################################
# Name: da-update-version-1.63.sh
#
# Created by: hoainh@vinahost.vn
############################################
================================================
# older than minimal required for this version of CustomBuild (1.63)
cd /usr/local/directadmin
wget -O update.tar.gz 'http://files1.directadmin.com/963018346/packed_es70_64.tar.gz'
tar -xvzf update.tar.gz
./directadmin p
cd scripts
./update.sh
service directadmin restart


#================================================
# uid=1093,lid=173867
#/usr/local/directadmin/scripts/getLicense.sh 1093 173867 210.211.122.197
#/usr/local/directadmin/scripts/getLicense.sh auto
#wget --no-check-certificate -O update.tar.gz 'https://update.directadmin.com/cgi-bin/daupdate?redirect=ok&uid=1093&lid=173867'


