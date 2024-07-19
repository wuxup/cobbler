## 制作镜像
docker build -t cobbler:2.8.5 .

## 服务参数cobbler.env

 #服务器IP地址

 SERVER_IP=192.168.3.99

 #装机后服务器的root密码

 ROOT_PASSWORD=P@ssword

 #指定批量装机需要获取的IP地址段

 DHCP_RANGE=192.168.3.240 192.168.3.245

 #指定DHCP的网段

 DHCP_SUBNET=192.168.3.0

 #指定DHCP的网关

 DHCP_ROUTER=192.168.3.254

 #指定DHCP的DNS地址

 DHCP_DNS=192.168.1.9

 #指定web账户密码

 COBBLER_WEB_USER=cobbler
 COBBLER_WEB_PASSWD=cobbler

## 容器
docker-compose up -d