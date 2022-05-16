#/bin/bash
############################################
# Name: redis-master.sh
#
# Created by: hoainh@ocb.com.vn
############################################
#varible
user=`whoami`
path="/home/$user/redis-cluster-live/"
echo -n "enter ipmaster / ipslave: "; read ipmaster ipslave;
echo "ipmaster: $ipmaster , ipslave: $ipslave";
sleep 3 
echo "------------------\n"
echo -n "enter 3 list port master: "; read port1 port2 port3;
echo "port master: $port1 $port2 $port3"
sleep 3
echo "------------------\n"
echo -n "enter 3 list port slave: "; read port4 port5 port6;
echo "port slave: $port4 $port5 $port6";
sleep 7

#disable ufw
sudo ufw disable
sudo systemctl stop ufw &> /dev/null
sudo systemctl disable ufw &> /dev/null
echo "disable ufw is completed!"
sleep 2

#main
sudo apt install redis-server -y
sleep 15

mkdir -p $path
cd $path
mkdir -v $port1 $port2 $port3

for port in $port1 $port2 $port3
do
sudo tee -a $path/$port/redis.conf <<EOF
bind 0.0.0.0
protected-mode no
port $port
cluster-enabled yes
cluster-config-file nodes-$port.conf
cluster-node-timeout 5000
appendonly yes
daemonize yes
EOF
sleep 2

#start instance Redis
cd $path/$port/
redis-server $path/$port/redis.conf
sleep 2
done

echo "Install and config Redis master completed!"
sleep 2
