#!/bin/bash
echo -e "
#================================================
# Description: For Centos7 First boot
# Version: 1.0
# Author: Htroy
# Blog:   https://blog.htroy.com
# Github: https://github.com/FsHtroy
# 2018.8.17
#================================================
"

check_root() {
	[[ "`id -u`" != "0" ]] && echo -e "You must be root user !" && exit 1
}

yum_install() {
	yum -y update
	yum -y install wget vim screen git net-tools epel-release
	#Collect epel-release 
	yum -y update
	if [[ "${1}" == "1" ]]; then
		yum -y groupinstall "Development tools"
	elif [[ "${1}" == "2" ]]; then
		echo -e "Skip install Development tools group"
	fi
}

pip_install() {
	mkdir pip_install
	cd pip_install
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python get-pip.py
}

check_root

echo -e "This script will install:
By yum:wget vim screen git net-tools epel-release & "Development tools" group
By script:python-pip"

echo -e "1.Install "Development tools" group"
echo -e "2.Without "Development tools" group"
read -p "Your choice:" function

while [[ ! "${function}" =~ ^[1-2]$ ]]
	do
		echo -e "Error!"
		read -p "Your choice:" function
	done

read -n 1 -s -r -p "Press any key to continue or ctrl+c to exit"

yum_install ${function}
pip_install


echo -e "Finish!"
