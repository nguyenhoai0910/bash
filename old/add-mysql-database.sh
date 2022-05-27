#!/bin/sh
############################################
# Name: add-mysql-database.sh
#
# Created by: hoainh@vinahost.vn
############################################

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

# Create Mysql
# Case 1
mysql -e "DROP DATABASE IF EXISTS $database;"
mysql -e "CREATE DATABASE $database;"
mysql -e "USE $database ;"
mysql -e "CREATE USER '$user_db'@'${host_db}' IDENTIFIED BY '$password_db';"
mysql -e "GRANT ALL PRIVILEGES ON $database.* TO '$user_db'@'${host_db}';"
#mysql -e "GRANT ALL PRIVILEGES ON  *.* to '$user_db'@'${host_db}' WITH GRANT OPTION;"
mysql -e "GRANT USAGE ON *.* TO '$user_db'@'${host_db}' IDENTIFIED BY '$password_db';"
#mysql -e "GRANT USAGE ON *.* TO '$user_db'@'%' IDENTIFIED BY '$password_db';"

mysql -e "FLUSH PRIVILEGES;"
mysql -e " SHOW DATABASES;"
mysql -e "SHOW GRANTS FOR '$user_db'@'${host_db}';"
mysql -e "SELECT user,host FROM mysql.user;"
mysql -e "SHOW WARNINGS;"

#Drop user &  database
#mysql -e "DROP DATABASE $database ;"
#mysql -e "DROP USER $user_db@${host_db} ;"


## Case 2
#commands="CREATE DATABASE \`${database}\`;CREATE USER '${user_db}'@'${host_db}' IDENTIFIED BY '${password_db}';GRANT USAGE ON *.* TO '${user_db}'@'${host_db}' IDENTIFIED BY '${password_db}';GRANT ALL privileges ON \`${database}\`.* TO '${user_db}'@'${host_db}';FLUSH PRIVILEGES;"
#
#echo "${commands}" | /usr/bin/mysql
