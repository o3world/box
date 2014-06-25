sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

date > /etc/vagrant_box_build_time

yum -y install wget

mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

cd /tmp
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

yum --enablerepo=remi -y update
yum --enablerepo=remi -y install nfs-utils rpcbind nano screen httpd mysql mysql-server php php-mysql php-gd php-xml php-mbstring php-mcrypt sendmail git-core nodejs npm
yum -y clean all

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod 755 /usr/local/bin/composer
composer self-update

curl -sS http://laravel.com/laravel.phar -o /usr/local/bin/laravel
chmod 755 /usr/local/bin/laravel

echo "127.0.0.1 local" >> /etc/hosts

echo "Welcome, Vagrant." > /etc/motd

chkconfig nfs --add
chkconfig nfs on --level 2345
service nfs start

chkconfig nfslock --add
chkconfig nfslock on --level 2345
service nfslock start

chkconfig rpcbind --add
chkconfig rpcbind on --level 2345
service rpcbind start

iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
service iptables save

mkdir /sync > /dev/null 2>&1

mkdir /sync/conf.d > /dev/null 2>&1

cat <<EOF >> /etc/httpd/conf/httpd.conf
ServerName local:80
ServerName local:443
NameVirtualHost *:80
NameVirtualHost *:443
Include /sync/conf.d/*.conf
EOF

cat <<EOF > /sync/conf.d/local.conf
<VirtualHost *:80>
    DocumentRoot /sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
    <Directory "/sync/conf.d">
        Order Deny,Allow
        Deny from All
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    DocumentRoot /sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
    <Directory "/sync/conf.d">
        Order Deny,Allow
        Deny from All
    </Directory>
</VirtualHost>
EOF

cat <<EOF > /sync/info.php
<?php phpinfo( );
EOF

cat <<EOF > /etc/start_httpd.sh
chkconfig httpd --add
chkconfig httpd on --level 2345
service httpd start
EOF

sh /etc/start_httpd.sh

cat <<EOF > /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
symbolic-links=0
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

cat <<EOF > /etc/start_mysql.sh
chkconfig mysqld --add
chkconfig mysqld on --level 2345
service mysqld start
EOF

sh /etc/start_mysql.sh

mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; UPDATE mysql.user SET Password = PASSWORD('vagrant') WHERE User='root'; FLUSH PRIVILEGES;" > /dev/null 2>&1

cd /sync
tar cvfp /tmp/sync_local.tgz conf.d/local.conf info.php

cat <<EOF > /etc/start_sendmail.sh
chkconfig sendmail --add
chkconfig sendmail on --level 2345
service sendmail start
EOF

sh /etc/start_sendmail.sh

cat <<EOF > /etc/start.sh
sudo sh /etc/start_httpd.sh
sudo sh /etc/start_mysql.sh
sudo sh /etc/start_sendmail.sh
EOF

cat <<EOF > /etc/init/vagrant-mounted.conf
start on vagrant-mounted
exec sudo sh /etc/start.sh
EOF

cat <<EOF > /etc/netfix.sh
rm -f /etc/udev/rules.d/70-persistent-net.rules
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
EOF

sh /etc/netfix.sh
