#!/bin/bash 

echo 'centos' | passwd --stdin centos

useradd clouder 
echo 'clouder' | passwd --stdin clouder

cp -a /etc/sudoers /etc/sudoers.bak 
echo "clouder  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers 

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

systemctl restart sshd

for NUM in $(seq 2 7); do mv /etc/sysconfig/network-scripts/ifcfg-eth${NUM} /etc/sysconfig/network-scripts/ifcfg-eth${NUM}.bak; done
systemctl restart network

systemctl disable firewalld 
systemctl stop firewalld

ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
