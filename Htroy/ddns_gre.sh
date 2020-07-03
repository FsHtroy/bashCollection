#!/bin/bash
network_interface=$1
peer_ddns=$2
network_config_file='/etc/sysconfig/network-scripts/ifcfg-'${network_interface}
local_record=`cat ${network_config_file} | grep 'PEER_OUTER_IPADDR' | awk -F '=' '{print $2}'`
echo "Local Record:${local_record}"
dns_record=`dig @119.29.29.29 ${peer_ddns} +short`
echo "DNS Record:${dns_record}"
if [[ ${local_record} == ${dns_record} ]]; then
        echo "Record No Change.Exit."
        exit 0
fi
echo "Record Changed.Replacing."
sed -ri "/^PEER_OUTER_IPADDR=/cPEER_OUTER_IPADDR=${dns_record}" ${network_config_file}
new_record=`cat ${network_config_file} | grep 'PEER_OUTER_IPADDR' | awk -F '=' '{print $2}'`
echo "Res:${new_record} Restart interface.."
/sbin/ifdown ${network_interface}
/sbin/ifup ${network_interface}
echo "Done"
/usr/sbin/ip addr show ${network_interface}
