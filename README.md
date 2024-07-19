## 制作镜像
docker build -t cobbler:2.8.5 .

## 服务参数cobbler.env

 #服务器IP地址

 SERVER_IP=xxx.xxx.xxx.xxx

 #装机后服务器的root密码

 ROOT_PASSWORD=xxxxxx

 #指定批量装机需要获取的IP地址段

 DHCP_RANGE=xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx

 #指定DHCP的网段

 DHCP_SUBNET=xxx.xxx.xxx

 #指定DHCP的网关

 DHCP_ROUTER=xxx.xxx.xxx.xxx

 #指定DHCP的DNS地址

 DHCP_DNS=xxx.xxx.xxx.xxx

 #指定web账户密码

 COBBLER_WEB_USER=xxxxx
 
 COBBLER_WEB_PASSWD=xxxxx

## 容器
docker-compose up -d
