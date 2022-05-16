#/bin/bash
############################################
# Name: reconfig-redis-master.sh
#
# Created by: hoainh@ocb.com.vn
############################################
#varible
user=`whoami`
echo $user
while [ $user = 'root' ]
do
        echo -n "enter user: "; read user;
        echo "user: $user \n"; sleep 3;
done
netstat -aplt|grep redis |head -10
sleep 10

echo -n "enter 3 list port master: "; read port1 port2 port3;
echo "port master: $port1 $port2 $port3 \n"
sleep 3

path=/home/$user/redis-cluster/
echo "$path \n"

for port in $port1 $port2 $port3
do
sudo kill -9 $(sudo lsof -t -i:$port)
echo "kill redis cluster $port \n"
done

#main
for port in $port1 $port2 $port3
do
cd $path/$port/
find . -type f -not -name 'redis.conf' -delete
echo "\n delete file on redis cluster $port except redis.conf \n"
redis-server $path/$port/redis.conf
sleep 2
done

echo "Reconfig Redis master completed!"
