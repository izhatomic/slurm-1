#!/bin/bash

if [[ -z $1 ]]; then
  site_name="mysite"
else
  site_name=$1
fi

yum install epel-release -y
yum install openssh-server openssh-clients -y
yum install docker docker-ce docker-compose

systemctl start docker
systemctl enable docker

# Создаем группу для доступа по SFTP
groupadd sftpg

mkdir /opt/www
mkdir /opt/www/${site_name}
mkdir /opt/www/${site_name}-db
chown -R root:root /opt/www
chmod -R 755 /opt/www

useradd -d /opt/www/${site_name} -p ftp123 ${site_name}
usermod -a -G sftpg ${site_name}
mkdir /opt/www/${site_name}/html
chown ${site_name}:${site_name} /opt/www/${site_name}/html

useradd -d /opt/www/${site_name}-db -p ftp321 ${site_name}-db
usermod -a -G sftpg ${site_name}-db

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
iptables -I INPUT -i eth0 -p tcp --dport 3306 -j DROP
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
rsync -av /tmp/wordpress/* /opt/www/${site_name}/html/

rm -rf /tmp/wp.tar.gz /tmp/wordpress

cp ./main/wp-config.php /opt/www/${site_name}/html/
chown nobody:nobody /opt/www/${site_name}/html/wp-config.php

mkdir -p /var/log/php
mkdir -p /var/log/mysql
chown -R root:dockerroot /var/log/nginx /var/log/php 
chown -R polkitd:polkitd /var/log/mysql

yum install letsencrypt -y
mkdir -p /opt/www/acme
letsencrypt certonly --webroot -w /opt/www/acme -d ${site_name}



cat > /etc/systemd/system/${site_name}.service <<EOF
[Unit]
Description=Service for ${site_name}
After=network.target
[Service]
Type=simple
ExecStart=docker-compose -f /root/slurm1/docker-compose.yml up
[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/${site_name}.service
systemctl daemon-reload
systemctl enable ${site_name}
