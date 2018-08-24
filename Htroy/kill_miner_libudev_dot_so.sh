#!/bin/bash
echo -e "
#================================================
# Description: Remove the Miner(libudev.so)
# Tested system: Centos 7
# Version: 1.0
# Author: Htroy
# Blog:   https://blog.htroy.com
# Github: https://github.com/FsHtroy
# 2018.8.17
#================================================
"

#pre load
VIRUS_P=$1

check_root() {
	[[ "`id -u`" != "0" ]] && echo -e "You must be root user !" && exit 1
}

main() {
	kill -stop `pgrep ${VIRUS_P}` 
	rm -f /usr/bin/${VIRUS_P}
	#/etc/cron.hourly/gcc.sh
	find /etc/cron* -name "gcc.sh" -exec rm {} \;
	find /etc/init.d/ -name "*${VIRUS_P}*" -exec rm {} \;
	find /etc/rc* -name "*${VIRUS_P}*" -exec rm {} \;
	pkill ${VIRUS_P}
	rm -f /lib/libudev.so /lib/libudev.so.6
}

introduce() {
	echo -e "
Please top to find a ten words process and copy the name
Then run 
\"bash kill_miner_libudev_dot_so.sh YOUR_MINER_PROCESS_NAME\"
" && exit 1
}

if [[ "${VIRUS_P}" == "" ]]; then
	introduce
fi

read -n 1 -s -r -p "Press any key to continue or ctrl+c to exit"

echo -e "Please run top and ensure the miner don't start again.
Then backup all your data and reinstall this system!!"