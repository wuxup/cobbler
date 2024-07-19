FROM centos:7.3.1611

MAINTAINER zuler

RUN rm -rf /etc/yum.repos.d/*.repo
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
COPY epel-7.repo /etc/yum.repos.d/epel-7.repo
RUN yum clean all && \
    yum makecache

ADD cobbler-* /
RUN yum -y localinstall cobbler-2.8.5-6.el7.x86_64.rpm cobbler-web-2.8.5-6.el7.noarch.rpm  
RUN yum -y install tftp-server dhcp openssl supervisor pykickstart httpd debmirror fence-agents file wget curl syslinux which 

RUN systemctl enable rsyncd
COPY supervisord/conf.ini /etc/supervisord.d/conf.ini
COPY supervisord/supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh
VOLUME [ "/var/www/cobbler", "/var/lib/tftpboot", "/var/lib/cobbler/config", "/var/lib/cobbler/collections", "/var/lib/cobbler/backup" ]
ENTRYPOINT /start.sh
