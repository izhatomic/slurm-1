#!/bin/bash

if [[ -z $1 ]]; then
  site_name="mysite"
else
  site_name=$1
fi

yum install epel-release -y
yum install openssh-server openssh-clients -y

# Создаем группу для доступа по SFTP
groupadd sftpg

# Создаем пользователей для доступа к файлам сайта и БД
useradd -g sftpg ${site_name}
useradd -g sftpg mysqldb

# Создаем каталоги для сайта и БД
mkdir -p /opt/www/${site_name}
mkdir -p /opt/www/mysqldb
chown -R root:sftpg /opt/www/${site_name}
chown -R root:sftpg /opt/www/mysqldb

# Создаем настройки для пользователей SFTP
cat>>/etc/ssh/sshd_config<<EOF
Match Group sftpg
     ChrootDirectory /opt/www/%u
     ForceCommand internal-sftp
EOF

systemctl restart sshd

yum install nginx -y
rm /etc/nginx/nginx.conf /etc/nginx/conf.d/* /etc/nginx/default.d/*
cp ./main/nginx.conf /etc/nginx/
cp ./main/conf.d/* /etc/nginx/conf.d/

cat > /usr/bin/set_nginx_iptables.sh <<EOF
#!/bin/bash
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
EOF

chmod +x /usr/bin/set_nginx_iptables.sh
/usr/bin/set_nginx_iptables.sh

cat > /etc/systemd/system/set_nginx_iptables.service <<EOF
[Unit]
Description=Set iptables for NGINX
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/set_nginx_iptables.sh
[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/set_nginx_iptables.service
systemctl daemon-reload
systemctl enable set_nginx_iptables.service

systemctl reload nginx.service

wget -O /tmp/wp.tar.gz -c http://wordpress.org/latest.tar.gz
tar -xzvf /tmp/wp.tar.gz -C /tmp/

Копируем в папку веб-сервера:
rsync -av /tmp/wordpress/* /opt/www/${site_name}/

rm -rf /tmp/wp.tar.gz /tmp/wordpress

cp ./main/wp-config.php

mkdir -p /var/log/php
mkdir -p /var/log/mysql
chown -R root:dockerroot /var/log/nginx /var/log/php 
chown -R root:polkitd /var/log/mysql

yum install letsencrypt -y
mkdir -p /opt/www/acme
letsencrypt certonly --webroot -w /opt/www/acme -d ${site_name}
