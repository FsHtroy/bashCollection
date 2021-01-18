#!/bin/bash
echo -e "
#================================================
# Description: For Centos7 Fast init
# Version: 1.0
# Author: Htroy
# Blog:   https://blog.htroy.com
# Github: https://github.com/FsHtroy
# 2020.11.20
#================================================
"

check_root() {
	[[ "`id -u`" != "0" ]] && echo -e "You must be root user !" && exit 1
  mkdir ~/init
}

yum_install() {
	echo -e "yum update and install software"
	yum update -y
  yum install wget vim screen git epel-release net-tools mtr curl traceroute telnet tcpdump nmap nc bind-utils iperf3 -y
  yum makecache fast
  yum install bash-completion htop strongswan bird bird6 wireguard-tools -y
  yum groupinstall "Development tools" -y
}

install_proxychains() {
  cd ~/init
  mkdir proxychains-ng
  cd ~/init/proxychains-ng
  wget http://ftp.barfooze.de/pub/sabotage/tarballs/proxychains-ng-4.14.tar.xz
  xz -d proxychains-ng-4.14.tar.xz
  tar xvf proxychains-ng-4.14.tar
  cd ~/init/proxychains-ng/proxychains-ng-4.14
  ~/init/proxychains-ng/proxychains-ng-4.14/configure --prefix=/usr --sysconfdir=/etc
  make
  make install
  make install-config
  sed -i 's#9050#1080#g' /etc/proxychains.conf
  sed -i 's#socks4#socks5#g' /etc/proxychains.conf
}

install_shadowsocks() {
  cd ~/init
  mkdir shadowsocks
  cd shadowsocks
  wget https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo
  cp librehat-shadowsocks-epel-7.repo /etc/yum.repos.d
  yum makecache fast
  yum install shadowsocks-libev -y
  echo -e "{
    \"server\":\"${ss_server}\",
    \"server_port\":${ss_port},
    \"local_port\":1080,
    \"password\":\"${ss_passwd}\",
    \"timeout\":60,
    \"method\":\"${ss_method}\"
}" > /etc/shadowsocks-libev/config.json
  systemctl enable shadowsocks-libev-local@config
  systemctl start shadowsocks-libev-local@config
}

read -p "Proxy Server:" ss_server
read -p "Proxy Port:" ss_port
read -p "Proxy Password:" ss_passwd
read -p "Proxy Method:" ss_method
read -p "Press enter to start"
check_root
yum_install
install_proxychains
install_shadowsocks
echo -e "Finish!"
