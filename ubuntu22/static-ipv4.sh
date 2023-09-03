

# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      dhcp4: true
    ens34:
       addresses:
                - 10.0.0.11/24
  version: 2


sudo netplan apply
