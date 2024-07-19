#!/bin/bash

set -ex

ROOT_PASSWD=${ROOT_PASSWD:-cobbler}
SERVER_IP=${SERVER_IP:-192.168.3.99}
HOST_HTTP_PORT=${HOST_HTTP_PORT:-80}
COBBLER_WEB_USER=${COBBLER_WEB_USER:-cobbler}
COBBLER_WEB_PASSWD=${COBBLER_WEB_PASSWD:-cobbler}
COBBLER_WEB_REALM=${COBBLER_WEB_REALM:-Cobbler}

#htdigest -c /etc/cobbler/users.digest "Cobbler Web Access" cobbler
printf "%s:%s:%s\n" "${COBBLER_WEB_USER}" "${COBBLER_WEB_REALM}" "$( printf "%s:%s:%s" "${COBBLER_WEB_USER}" "${COBBLER_WEB_REALM}" "${COBBLER_WEB_PASSWD}" | md5sum | awk '{print $1}' )" > "/etc/cobbler/users.digest"
if [ "${COBBLER_WEB_USER}" != "cobbler" ] && [ "${COBBLER_WEB_USER}" != "admin" ]
then
    echo "${COBBLER_WEB_USER} = \"\"" >> /etc/cobbler/users.conf
fi

PASSWORD=`openssl passwd -1 -salt hLGoLIZR $ROOT_PASSWORD`
sed -i "s/^server: 127.0.0.1/server: $SERVER_IP/g" /etc/cobbler/settings
sed -i "s/^next_server: 127.0.0.1/next_server: $SERVER_IP/g" /etc/cobbler/settings
sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings
sed -i 's/manage_rsync: 0/manage_rsync: 1/g' /etc/cobbler/settings
sed -i "s#^default_password.*#default_password_crypted: \"$PASSWORD\"#g" /etc/cobbler/settings
sed -i -e "/^http_port:/ s/:.*$/: ${HOST_HTTP_PORT}/" /etc/cobbler/settings
sed -i "s/192.168.1.0/$DHCP_SUBNET/" /etc/cobbler/dhcp.template
sed -i "s/192.168.1.5/$DHCP_ROUTER/" /etc/cobbler/dhcp.template
sed -i "s/192.168.1.1;/$DHCP_DNS;/" /etc/cobbler/dhcp.template
sed -i "s/192.168.1.100 192.168.1.254/$DHCP_RANGE/" /etc/cobbler/dhcp.template
sed -i "s/^#ServerName www.example.com:80/ServerName localhost:80/" /etc/httpd/conf/httpd.conf
sed -i "s/service %s restart/supervisorctl restart %s/g" /usr/lib/python2.7/site-packages/cobbler/modules/sync_post_restart_services.py
sed -i -e "/disable/ s/yes/no/" /etc/xinetd.d/tftp
sed -i -e "/^@dists/ s/@dists/#@dists/" /etc/debmirror.conf
sed -i -e "/^@arches/ s/@arches/#@arches/" /etc/debmirror.conf

rm -rf /run/httpd/*
/usr/sbin/apachectl
/usr/bin/cobblerd

cobbler sync
#cobbler get-loaders

pkill cobblerd
pkill httpd
rm -rf /run/httpd/*
        
echo "Running supervisord"
/usr/bin/supervisord -c /etc/supervisord.conf
