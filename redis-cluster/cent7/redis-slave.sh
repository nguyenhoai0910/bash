############################################
# Name: redis-slave.sh
#
# Created by: hoainh@ocb.com.vn
############################################
#varible
user=`whoami`
path="/home/$user/redis-cluster-live/"
echo -n "enter 3 list port master: "; read port1 port2 port3;
echo "port master: $port1 $port2 $port3"
sleep 3
echo "------------------\n"
echo -n "enter 3 list port slave: "; read port4 port5 port6;
echo "port slave: $port4 $port5 $port6";
sleep 7

#disable ufw
sudo systemctl stop firewalld &> /dev/null
sudo systemctl disable firewalld &> /dev/null
echo "disable firewalld is completed!"
sleep 2

#main
sudo yum install epel-release -y
sudo yum install redis -y
sleep 15

mkdir -p $path
cd $path
mkdir -v $port4 $port5 $port6

for port in $port4 $port5 $port6
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

echo "Install and config Redis slave completed!"
sleep 2
