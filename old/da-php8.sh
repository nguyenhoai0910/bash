#!/bin/sh
############################################
# Name: da-php8.sh
#
# Created by: hoainh@vinahost.vn
############################################
echo "===================================="
echo "1: Update directadmin."
echo "2: Download lib install php7.4 php8.0."
echo "3: Install php for directadmin."
echo "===================================="
read -p "Enter a number between 1 and 3 inclusive > " character
case $character in
    1 ) echo "You entered one."
        cd /usr/local/directadmin/custombuild
        ./build update
        ;;
    2 ) echo "You entered two."
        cd /usr/local/directadmin/custombuild
        yum install epel-release -y
        yum -y install cmake
        yum -y install libpng libpng-devel libjpeg libjpeg-devel freetype freetype-devel recode recode-devel
        ./build icu
        ;;
    3 ) echo "You entered three."
        echo -n "Choose the php you want to install:<php1> <php2> <php3>"
        echo " (exam: 7.4 7.2 8.0)"
        php1=7.4 ; php2=7.2 ; php3=8.0
        read php1 php2 php3
        cd /usr/local/directadmin/custombuild
        ./build set php1_release $php1
        ./build set php2_release $php2
        ./build set php3_release $php3
        ./build php n
        ./build rewrite_confs
        ;;
    * ) echo "You did not enter a number between 1 and 3."
esac
