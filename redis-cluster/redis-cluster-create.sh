#/bin/bash
############################################
# Name: redis-cluster-create.sh
#
# Created by: hoainh@ocb.com.vn
############################################
#varible
user=`whoami`
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

# create cluster Redis
redis-cli --cluster create $ipmaster:$port1 $ipmaster:$port2 $ipmaster:$port3 $ipslave:$port4 $ipslave:$port5 $ipslave:$port6 \
--cluster-replicas 1
sleep 5

# test cluster
echo -n "Do you want test cluster? (y/n) "; read ques;
while [ $ques = 'y' ]
do
        echo -n "enter port test: "; read port;
        echo "port: $port"; sleep 3;
        redis-cli -c -p $port;
		sleep 1
		
        echo -n "Do you want test cluster? (y/n)"; read ques;
done
