#!/bin/bash
## Script for automatic initial setting for DirectAdmin
## Author : Vinahost Inc.
## Path : /usr/local/src/vina_vps.sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

indicator_process()
{
    INTERVAL=1
    TCOUNT="0"

    while true
    do
        ((TCOUNT++))
        case ${TCOUNT} in
            "1") echo -en "-\b"
            sleep ${INTERVAL}
            ;;
            "2") echo -en '\\'"\b"
            sleep ${INTERVAL}
            ;;
            "3") echo -en "/\b"
            sleep ${INTERVAL}
            ;;
            "4") echo -en "-\b"
            sleep ${INTERVAL}
            ;;
            *) TCOUNT="0"
            ;;
        esac
    done
}

networking_change()
{
    if [[ $(cat /etc/redhat-release | grep -o "release 6") && ${OS} -eq 6 ]];then
        if [[ ! -z ${IP} && ! -z ${NETMASK} && ! -z ${GATEWAY} && $(ip addr | grep -o "eth0") ]];then
            echo "-- CentOS 6"
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=${IP}
NETMASK=${NETMASK}
GATEWAY=${GATEWAY}
DNS1=8.8.8.8
DNS2=8.8.4.4
EOF

            service network restart &> /dev/null
            echo "--> Cau hinh card mang eth0 hoan tat."
            echo
            sleep 2
        else
            echo "- Cac gia tri nhap vao khong hop le. Thoat"
            echo
            exit 0
        fi

    elif [[ $(cat /etc/redhat-release | grep -o "release 7") && ${OS} -eq 7 ]];then
        if [[ ! -z ${IP} && ! -z ${NETMASK} && ! -z ${GATEWAY} && $(ip addr | grep -o "eth0") ]];then
                    echo "-- CentOS 7"
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=${IP}
NETMASK=${NETMASK}
GATEWAY=${GATEWAY}
DNS1=8.8.8.8
DNS2=8.8.4.4
EOF

#cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0:100
#DEVICE=eth0:100
#IPADDR=210.211.122.199
#NETMASK=255.255.255.192
#EOF

#cat << EOF > /etc/systemd/system/eth0100.service
#[Unit]
#Description=Directadmin Interface eth0:100
#After=directadmin.service
#[Service]
#ExecStart=/usr/sbin/ifup eth0:100
#Type=oneshot
#[Install]
#WantedBy=multi-user.target
#EOF

#sed -i '7 a\Wants=eth0100.service' /etc/systemd/system/directadmin.service
#            systemctl daemon-reload
            systemctl restart network &> /dev/null
            echo "--> Cau hinh card mang eth0 va eth0:100 hoan tat."
            echo
            sleep 2
        else
            echo "-- Cac gia tri nhap vao khong hop le. Thoat"
            echo
            exit 0
        fi
    fi

}

system_pass_change()
{

## Change password for user admin and root
cat << EOF > ${TEMP_FILE}
admin:${PASS2}
EOF

    if [ -f ${TEMP_FILE} ];then
        chpasswd -c SHA512 < ${TEMP_FILE}
        sleep 2
    fi

    ## Update password for user admin in DA file
    /usr/bin/perl -pi -e 's/adminpass=(.*)/adminpass='${PASS2}'/' /usr/local/directadmin/scripts/setup.txt
}

mysql_pass_change()
{

mysql -e "SET PASSWORD FOR da_admin@localhost = '$PASS3'" &> /dev/null

cat << EOF > /root/.my.cnf
[client]
user=da_admin
password=${PASS3}
EOF

cat << EOF > /usr/local/directadmin/conf/mysql.conf
user=da_admin
passwd=${PASS3}
EOF

}

da_initial_change()
{
    ## Swap change main ip to new ip
    ##/usr/local/directadmin/scripts/ipswap.sh 123.30.136.208 ${IP} &> /dev/null
    # /usr/local/directadmin/scripts/ipswap.sh 123.30.136.194 ${IP} &> /dev/null
    # sleep 1

    ## Change local host name info in direct admin configuration
    /usr/local/directadmin/scripts/hostname.sh ${HOST_NAME} ${IP}
    /usr/bin/perl -pi -e 's/servername=(.*)/servername='${HOST_NAME}'/' /usr/local/directadmin/conf/directadmin.conf
    sleep 1

    if [[ ${OS} -eq 6 ]];then
    ## Restart nginx, httpd and restart get new license DA on CentOS 6
        /etc/init.d/nginx restart &> /dev/null ; /etc/init.d/httpd restart &> /dev/null ; /etc/init.d/directadmin restart &> /dev/null
        rm -f /tmp/license.key; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -q -O /tmp/license.key.gz http://123.30.136.208/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key
        /etc/init.d/nginx restart &> /dev/null ; /etc/init.d/httpd restart &> /dev/null ; /etc/init.d/directadmin restart &> /dev/null
    fi

    if [[ ${OS} -eq 7 ]];then
        ## Restart nginx, httpd and restart get new license DA on CentOS 7
        systemctl restart nginx && systemctl restart httpd
    	ifdown eth0:100; rm -f /tmp/license.key; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://210.211.122.199/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; ifup eth0:100; /bin/systemctl restart  directadmin.service
    fi

    echo "--> Hoan tat cai dat buoc 2 ."
    echo
}

end_script()
{
    if [ -f /usr/local/src/vina_vps.sh ];then
        echo
        echo '---=> Script /root/vina_vps.sh se bi xoa trong vong 3 giay ke tiep.'
        sleep 3
        rm -f /usr/local/src/vina_vps.sh
    fi

    if [ -f /usr/local/src/vps_vina.sh ];then
        echo
        echo '---=> Script /root/vps_vina.sh se bi xoa trong vong 3 giay ke tiep.'
        sleep 3
        rm -f /usr/local/src/vina_vps.sh
    fi

    echo "========================  ===  ================================="
    echo '---=> He thong se tu dong reboot lai trong vong 5 giay ke tiep.'
    echo '---=> Vui long doi reboot lai va kiem tra cac thong tin lien quan.'
}

## MAIN FUNCTION ##
if [[ $1 -ne 1 && $1 -ne 2 ]];then

    echo "- Sai cau truc lenh."
    echo "Syntax: "
    echo "Buoc 1: Cau hinh Networking interface."
    echo " $0 1"
    echo
    echo "Buoc 2: Cau hinh he thong va DirectAdmin"
    echo " $0 2"
    echo "- Vui long thu lai."
    echo
    exit 0
elif [[ $1 -eq 1 || $1 -eq 2 ]];then
    if [[ $# -gt 1 ]];then
        echo "- Sai cau truc lenh."
        echo "Syntax: "
        echo "Buoc 1: Cau hinh Networking interface."
        echo " $0 1"
        echo
        echo "Buoc 2: Cau hinh he thong va DirectAdmin"
        echo " $0 2"
        echo "- Vui long thu lai."
        echo
        exit 0
    fi
fi

if [[ $1 -eq "1" ]];then
    echo "+ BUOC 1 : CAU HINH NETWORKING INTERFACE +"
    echo "- VUI LONG NHAP THONG TIN CHINH XAC HOAN TOAN - CAN THAN"
    echo "-> Luu y : hostname neu de gia tri rong, mac dinh se la dang > kvm.x.x.x.x < hoac > vps.x.x.x.x < "
    read -p "--+ Main IP : " IP
    read -p "--+ Netmask : " NETMASK
    read -p "--+ Gateway : " GATEWAY

    while [[ -z ${IP} || -z ${NETMASK} || -z ${GATEWAY} ]]
    do
            echo "Vui long nhap lai"
            read -p "--+ Main IP : " IP
            read -p "--+ Netmask : " NETMASK
            read -p "--+ Gateway : " GATEWAY
    done

    ## Check version of OS. CentOS.
    OS=0

    if [[ $(cat /etc/redhat-release | grep -o "release 6") ]];then
        OS=6
    elif [[ $(cat /etc/redhat-release | grep -o "release 7") ]];then
        OS=7
    fi

    networking_change

    echo
    echo "--> Vui long ket noi SSH vao VPS nay, ${IP}, de tiep tuc cau hinh."
    echo
    sleep 3
    exit 0

fi

if [[ $1 -eq "2" ]];then

    ## Check OS System version CentOS
    OS=0

    if [[ $(cat /etc/redhat-release | grep -o "release 6") ]];then
        OS=6
    elif [[ $(cat /etc/redhat-release | grep -o "release 7") ]];then
        OS=7
    fi

    echo "HE THONG DANG KHOI TAO THONG TIN DIRECTADMIN..."
    # PASS1=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 15 | tr -d '\n'; echo)
    PASS2=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 15 | tr -d '\n'; echo)
    PASS3=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 15 | tr -d '\n'; echo)
    TEMP_FILE=/root/default-directadmin-info.txt
    
    ## Get information of network interface base on OS
    if [[ ${OS} -eq 6 ]];then
        if [[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]];then
            IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep "IPADDR" | awk -F'=' '{print $2}')
        elif [[ -f /etc/sysconfig/network-scripts/ifcfg-venet0:0 ]];then
            IP=$(cat /etc/sysconfig/network-scripts/ifcfg-venet0:0 | grep "IPADDR" | awk -F'=' '{print $2}')
        fi

    fi
    if [[ ${OS} -eq 7 ]];then
        if [[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]];then
            IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep "IPADDR" | awk -F'=' '{print $2}')
        elif [[ -f /etc/sysconfig/network-scripts/ifcfg-venet0:0 ]];then
            IP=$(cat /etc/sysconfig/network-scripts/ifcfg-venet0:0 | grep "IPADDR" | awk -F'=' '{print $2}')
        fi
    fi

    ## Input Hostname Information
    HOST_NAME=$(/usr/bin/hostname)
    if [ -z ${HOST_NAME} ];then
        if [[ -f /etc/sysconfig/network-scripts/ifcfg-venet0:0 ]];then
            HOST_NAME=vps.${IP}
        elif [[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 || -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]];then
            HOST_NAME=kvm.${IP}
        fi
    fi
    

    ## Start Fix eth0:100
	# xoa sub-interface
        ip addr del 210.211.122.197/25 dev eth0
        # tat ARP check
        sed -i '276,280 {s/^/#/}' /etc/sysconfig/network-scripts/ifup-eth
        # swap IP
        /usr/local/directadmin/scripts/ipswap.sh 210.211.122.199 ${IP} &> /dev/null

    cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0:100
DEVICE=eth0:100
IPADDR=210.211.122.199
NETMASK=255.255.255.192
EOF

cat << EOF > /etc/systemd/system/eth0100.service
[Unit]
Description=Directadmin Interface eth0:100
After=directadmin.service
[Service]
ExecStart=/usr/sbin/ifup eth0:100
Type=oneshot
[Install]
WantedBy=multi-user.target
EOF

	## End Fix eth0:100

#sed -i '7 a\Wants=eth0100.service' /etc/systemd/system/directadmin.service
#       systemctl daemon-reload
#	systemctl restart network &> /dev/null
/usr/sbin/ifdown eth0:100
/usr/sbin/ifup eth0:100
    
    ## Process change MySQL settings pass
    mysql_pass_change
    sleep 1

    ## Process change System settings pass
    system_pass_change
    sleep 1

    ## Process change DA settings pass
    da_initial_change
    sleep 1
	
    ## FTP Change Admin Password
    UUID=`id -u admin`
    UGID=`id -g admin`
    echo `awk -F[:] '$1 == "admin" {print $2 }' /etc/shadow` > /home/admin/.shadow
    echo "admin:`cat /home/admin/.shadow`:${UUID}:${UGID}:system:/home/admin:/bin/false" > /etc/proftpd.passwd
    /usr/bin/pure-pw mkdb /etc/pureftpd.pdb -f /etc/proftpd.passwd
    echo "Da cap nhat password FTP cho Admin"
	## End FTP UPDATE
	
    echo
    echo "-- VUI LONG GHI LAI THONG TIN MAT KHAU --" | tee -a ${TEMP_FILE}
    echo "==========================================" | tee -a ${TEMP_FILE}
    echo "Here is info password" | tee -a ${TEMP_FILE}
    echo "- URL: http://${IP}:2222" | tee -a ${TEMP_FILE}
    # echo "- User System: root - Pass: ${PASS1}" | tee -a ${TEMP_FILE}
    echo "- User DA: admin - Pass: ${PASS2}" | tee -a ${TEMP_FILE}
    echo "- User MySQL: da_admin - Pass: ${PASS3}" | tee -a ${TEMP_FILE}
    echo
    echo "-- Thong tin mat khau luu tai : ${TEMP_FILE} "
    echo "-- Hay xoa file ${TEMP_FILE} sau khi da luu lai thong tin xong"

    ## End script for some last tasks.
    end_script

fi

exit 0