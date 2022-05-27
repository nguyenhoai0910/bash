#!/bin/sh
############################################
# Name: da-wordpress.sh
#
# Created by: hoainh@vinahost.vn
############################################

#Download file from wordpress
wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xf wordpress.tar.gz
mv wordpress/* .

#Permission file folder
user=`pwd|cut -d '/' -f 3`
chown -R $user:$user * .htaccess* &>/dev/null

#Export result
echo "Install wordpress last version finish!"

# Create user database
echo -n "Enter Database: "; read database;
echo -n "Enter User_db: "; read user_db;
echo -n "Enter Password_db: "; read password_db;
echo -n "Enter Host_db: "; read host_db;
#echo "db=$database user=$user_db password=$password_db host=$host_db"

database="$(echo $database|tr -d '[[:space:]]')"
user_db="$(echo $user_db|tr -d '[[:space:]]')"
password_db="$(echo $password_db|tr -d '[[:space:]]')"
host_db="$(echo $host_db|tr -d '[[:space:]]')"
echo "db=$database user=$user_db password=$password_db host=$host_db"

commands="CREATE DATABASE \`${database}\`;CREATE USER '${user_db}'@'${host_db}' IDENTIFIED BY '${password_db}';GRANT USAGE ON *.* TO '${user_db}'@'${host_db}' IDENTIFIED BY '${password_db}';GRANT ALL privileges ON \`${database}\`.* TO '${user_db}'@'${host_db}';FLUSH PRIVILEGES;SHOW DATABASES;SHOW GRANTS FOR '$user_db'@'${host_db}';SELECT user,host FROM mysql.user;SHOW WARNINGS;"
echo "${commands}" | /usr/bin/mysql
