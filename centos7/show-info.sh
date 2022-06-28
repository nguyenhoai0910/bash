#!/bin/bash
############################################
# Created by: reiji0910
############################################
#save file at /etc/profile.d/show-info.sh
echo "";
echo -n "IP: ";  hostname -I;
echo -n "Hostname: "; hostname;
echo "-------------------------"
top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'
free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
echo "";
