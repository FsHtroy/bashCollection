#!/bin/bash
echo -e "
#================================================
# Description: For Centos7 Install SSR manyuser
# Version: 1.0
# Author: Htroy
# Blog:   https://blog.htroy.com
# Github: https://github.com/FsHtroy
#================================================
"

check_root() {
	[[ "`id -u`" != "0" ]] && echo -e "You must be root user !" && exit 1
}

prepare() {
	echo -e "Get base env"
	yum update -y
	yum install wget screen git net-tools -y
	yum groupinstall "Development tools" -y
	wget https://bootstrap.pypa.io/get-pip.py
	python get-pip.py
	mkdir manyuser_install
	cd manyuser_install
}

install_libsodium() {
	echo -e "Installing libsodium"
	wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz
	tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
	./configure && make -j2 && make install
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
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
	echo -e "
# Config
NODE_ID = ${nodeid}


# hour,set 0 to disable
SPEEDTEST = 6
CLOUDSAFE = 1
ANTISSATTACK = 0
AUTOEXEC = 0

MU_SUFFIX = 'zhaoj.in'
MU_REGEX = '%5m%id.%suffix'

SERVER_PUB_ADDR = '127.0.0.1'  # mujson_mgr need this to generate ssr link
API_INTERFACE = 'modwebapi'  # glzjinmod, modwebapi

WEBAPI_URL = '${panelurl}'
WEBAPI_TOKEN = '${mukey}'

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
}

normal_install() {
	read -p "Your nodeid:" nodeid
	read -p "Your mukey:" mukey
	read -p "Your panel url:" panelurl
	check_root
	prepare
	install_libsodium
	get_server
	set_config
}

echo -e "1.normal install(No supervisor)"
read -p "Your choice:" function

while [[ ! "${function}" =~ ^[1-1]$ ]]
	do
		echo -e "Error!"
		read -p "Your choice:" function
	done

if [[ "${function}" == "1" ]]; then
	normal_install
elif [[ "${function}" == "2" ]]; then
	status
else
	uninstall
fi