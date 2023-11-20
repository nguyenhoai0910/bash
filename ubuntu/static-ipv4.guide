hoainh@hoainh:~$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         192.168.153.2   0.0.0.0         UG    100    0        0 ens33
10.0.0.0        0.0.0.0         255.255.255.0   U     0      0        0 ens34
192.168.153.0   0.0.0.0         255.255.255.0   U     100    0        0 ens33
192.168.153.2   0.0.0.0         255.255.255.255 UH    100    0        0 ens33

hoainh@hoainh:~$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      dhcp4: true
      routes:
        - to: default
          via: 192.168.153.2
    ens34:
       addresses:
                - 10.0.0.11/24
  version: 2
