#!/bin/bash

sudo rpm -Uvh https://www.rdoproject.org/repos/rdo-release.rpm
sudo yum update -y
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
sudo yum install -y git
sudo yum install -y epel-release
sudo yum install -y python-pip
sudo yum install -y vim
sudo yum install -y telnet
sudo yum install -y python2-setuptools
sudo mv /home/centos/devstack_*.sh /opt/stack
