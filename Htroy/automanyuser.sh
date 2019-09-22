#!/bin/bash

yum_update() {
  yum update -y
}

yum_install() {
  yum install wget vim screen git epel-release net-tools curl mtr traceroute telnet -y
  yum makecache fast
  yum install htop bash-completion libsodium -y
  yum groupinstall "Development tools" -y
}

pip_install() {
  curl -fsSL https://bootstrap.pypa.io/get-pip.py|python
}

systemctl_firewall() {
  systemctl disable firewalld
  systemctl disable iptables
  systemctl stop firewalld
  systemctl stop iptables
}

write_rclocal() {
  chmod +x /etc/rc.d/rc.local
  sed -i '$i\chattr -i /serverspeeder/etc/apx* && /serverspeeder/bin/serverSpeeder.sh uninstall -f
 && wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh' /etc/rc.local
}

change_kernel() {
  rpm -ivh http://soft.91yun.pw/ISO/Linux/CentOS/kernel/kernel-3.10.0-229.1.2.el7.x86_64.rpm --force
}

yum_update
yum_install
pip_install
systemctl_firewall
write_rclocal
change_kernel
