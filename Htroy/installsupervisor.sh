#!/bin/bash
echo -e "
#================================================
# Description: For Centos7 Install supervisor
# Version: 1.0
# Author: Htroy
# Blog:   https://blog.htroy.com
# Github: https://github.com/FsHtroy
# 2018.2.15
#================================================
"

#pre load
pip=$1
web=$2
user=$3
password=$4

check_root() {
	[[ "`id -u`" != "0" ]] && echo -e "You must be root user !" && exit 1
}

install_pip() {
	if [[ "$pip" != "installed"]]; then
		wget https://bootstrap.pypa.io/get-pip.py
		python get-pip.py
	fi
}

pip_install_supervisor() {
	pip install supervisor
	mkdir /etc/supervisor
	mkdir /etc/supervisor/config.d
}

set_supervisor_config() {
	wget https://raw.githubusercontent.com/FsHtroy/bashCollection/master/Htroy/supervisor/supervisord.conf
	mv supervisord.conf /etc/supervisor/supervisord.conf
	if [[ "${web}" != "n"]]; then
		echo -e "[inet_http_server]
port=0.0.0.0:9001
username=${user}
password=${password}" > /etc/supervisor/supervisord.conf
	fi
}

set_service() {
	wget https://raw.githubusercontent.com/FsHtroy/bashCollection/master/Htroy/supervisor/supervisor.service
	mv supervisor.service /lib/systemd/system/supervisor.service
	chmod 766 /lib/systemd/system/supervisor.service
	systemctl enable supervisor.service
	systemctl daemon-reload
	wget https://raw.githubusercontent.com/FsHtroy/bashCollection/master/Htroy/supervisor/supervisor
	mv supervisor /etc/rc.d/init.d/supervisor
	chmod 755 /etc/rc.d/init.d/supervisor
	chkconfig supervisor on
	service supervisor start
}

install() {
	if [[ "${user}" == "" ]]; then
		read -p "Your web user name:" user
		read -p "Your web user password:" password
	fi
	check_root
	install_pip
	pip_install_supervisor
	set_supervisor_config
	set_service
}
install