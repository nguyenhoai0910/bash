#!/bin/bash
DOMAIN=$1
relay ()
{
	echo "$DOMAIN:mail-out.$DOMAIN" >> /etc/mailhelo
}
mailserver ()
{
	su - zimbra -c "ldap start"
	su - zimbra -c "postfix start"
	su - zimbra -c "zmcontrol start"
	HOSTNAME=mail.$DOMAIN
	hostnamectl set-hostname $HOSTNAME
	echo $HOSTNAME > /etc/hostname
	echo "$IP $HOSTNAME" >> /etc/hosts
	sed -i "s/mailsv.vinahost.vn/$HOSTNAME/g" /opt/zimbra/conf/custom_header_checks
	su - zimbra -c "ldap stop"
	su - zimbra -c "/opt/zimbra/libexec/zmsetservername -n $HOSTNAME"
	sed -i "s/mailsv.vinahost.com/$HOSTNAME/g" /opt/zimbra/conf/nginx/includes/nginx.conf.web
	su - zimbra -c "zmprov -l rd mailsv.vinahost.com $HOSTNAME"
	su - zimbra -c 'zmcontrol restart'
	su - zimbra -c "zmprov createDomain $DOMAIN"
	su - zimbra -c "zmprov ca admin@$DOMAIN ceTYKHQj zimbraIsAdminAccount TRUE"
	su - zimbra -c "/opt/zimbra/libexec/zmdkimkeyutil -a -d $DOMAIN" > /root/$DOMAIN-dkim.txt
	#su - zimbra -c 'zmloggerhostmap -d mailsv mailsv.vinahost.com'
	#su - zimbra -c 'zmloggerhostmap -d mailsv.vinahost.com mailsv.vinahost.com'
	#su - zimbra -c 'zmloggerhostmap -d mailsv.vinahost.com mailsv.vinahost.com'
	echo "@reboot su - zimbra -c su - zimbra -c 'zmloggerhostmap -d mailsv mailsv.vinahost.com';su - zimbra -c 'zmloggerhostmap -d mailsv.vinahost.com mailsv.vinahost.com';su - zimbra -c 'zmloggerhostmap -d mailsv.vinahost.com mailsv.vinahost.com'; :>/var/spool/cron/root" >> /var/spool/cron/root
	reboot now
}

if [ $# -ne 1 ];
then
	echo "USAGE: ./mailserver-setup.sh sub.example.com"
else
	IP=`curl -s https://ip.vinahost.vn`

	if [ $IP = "125.212.217.228" ];
	then
		relay
	else
		mailserver
	fi
fi
