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
  sed -i '$i\chattr -i /serverspeeder/etc/apx* && /serverspeeder/bin/serverSpeeder.sh uninstall -f && wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh' /etc/rc.local
}

change_kernel() {
  rpm -ivh http://soft.91yun.pw/ISO/Linux/CentOS/kernel/kernel-3.10.0-229.1.2.el7.x86_64.rpm --force
}

get_server() {
	cd /usr/local
	git clone https://github.com/FsHtroy/shadowsocksr-manyuser-mod.git
	mv shadowsocksr-manyuser-mod shadowsocks
	cd shadowsocks
	pip install cymysql
	pip install -r requirements.txt
	chmod +x *.sh
	cp config.json user-config.json
	touch userapiconfig.py
}

set_config() {
	echo -e "# Config
NODE_ID = ${NODEID}
# hour,set 0 to disable
SPEEDTEST = 6
CLOUDSAFE = 1
ANTISSATTACK = 0
AUTOEXEC = 0
MU_SUFFIX = 'zhaoj.in'
MU_REGEX = '%5m%id.%suffix'
SERVER_PUB_ADDR = '127.0.0.1'  # mujson_mgr need this to generate ssr link
API_INTERFACE = 'modwebapi'  # glzjinmod, modwebapi
WEBAPI_URL = '${PANEL}'
WEBAPI_TOKEN = '${MUKEY}'
# mudb
MUDB_FILE = 'mudb.json'
# Mysql
MYSQL_HOST = '127.0.0.1'
MYSQL_PORT = 3306
MYSQL_USER = 'ss'
MYSQL_PASS = 'ss'
MYSQL_DB = 'shadowsocks'
MYSQL_SSL_ENABLE = 0
MYSQL_SSL_CA = ''
MYSQL_SSL_CERT = ''
MYSQL_SSL_KEY = ''
# API
API_HOST = '127.0.0.1'
API_PORT = 80
API_PATH = '/mu/v2/'
API_TOKEN = 'abcdef'
API_UPDATE_TIME = 60
# Manager (ignore this)
MANAGE_PASS = 'ss233333333'
# if you want manage in other server you should set this value to global ip
MANAGE_BIND_IP = '127.0.0.1'
# make sure this port is idle
MANAGE_PORT = 23333
" > userapiconfig.py
wget https://github.com/FsHtroy/bashCollection/raw/master/Htroy/shadowsocks.service
mv -f shadowsocks.service /usr/lib/systemd/system
systemctl enable shadowsocks
}

while getopts "i:p:m" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
        i)
			NODEID="$OPTARG" 
			;;
        p)
			PANEL="$OPTARG"
			;;
        m)
			MUKEY="$OPTARG"
			;;
        \?)
			echo "unkonw argument"
			exit 1
		;;
    esac
done

yum_update
yum_install
pip_install
systemctl_firewall
write_rclocal
change_kernel
get_server
set_config
