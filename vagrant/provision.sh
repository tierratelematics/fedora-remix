#!/bin/sh
echo I am provisioning...
sed -i s/us/it/ /etc/vconsole.conf
sed -i s/dhcp/static/ /etc/sysconfig/network-scripts/ifcfg-eth1
sudo echo "IPADDR=$1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
sudo echo "PREFIX=24" >> /etc/sysconfig/network-scripts/ifcfg-eth1
sudo echo "GATEWAY=172.28.128.2" >> /etc/sysconfig/network-scripts/ifcfg-eth1
sudo echo "DNS1=8.8.8.8" >> /etc/sysconfig/network-scripts/ifcfg-eth1
sudo echo "$1 $2" >> /etc/hosts
sudo echo "$2" > /etc/hostname
sudo systemctl restart NetworkManager
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/\#PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
echo I am installing python...
sudo dnf install -y python python3-dnf yum
echo I am rebooting...
sudo shutdown -r now
