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
service iptables save

sudo yum -y install vim

echo "127.0.0.1 local" >> /etc/hosts

echo "Welcome, vagrant." > /etc/motd

mkdir /home/vagrant/sync/conf.d > /dev/null 2>&1
chmod -R 777 /home/vagrant/sync/conf.d
chmod -R g+s /home/vagrant/sync/conf.d

cat <<EOF >> /etc/httpd/conf/httpd.conf
ServerName local:80
ServerName local:443
NameVirtualHost *:80
NameVirtualHost *:443
Include /home/vagrant/sync/conf.d/*.conf
EOF

cat <<EOF > /home/vagrant/sync/conf.d/local.conf
<VirtualHost *:80>
    DocumentRoot /home/vagrant/sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/home/vagrant/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
    <Directory "/home/vagrant/sync/conf.d">
        Order Deny,Allow
        Deny from All
    </Directory>
    <Directory "/home/vagrant/sync/mysql.data">
        Order Deny,Allow
        Deny from All
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    DocumentRoot /home/vagrant/sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/home/vagrant/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
    <Directory "/home/vagrant/sync/conf.d">
        Order Deny,Allow
        Deny from All
    </Directory>
    <Directory "/home/vagrant/sync/mysql.data">
        Order Deny,Allow
        Deny from All
    </Directory>
</VirtualHost>
EOF

chkconfig httpd --add
chkconfig httpd on --level 2345
service httpd start

mkdir /home/vagrant/sync/mysql.data > /dev/null 2>&1
chmod -R 777 /home/vagrant/sync/mysql.data
chmod -R g+s /home/vagrant/sync/mysql.data

cat <<EOF > /etc/my.cnf
[mysqld]
datadir=/home/vagrant/sync/mysql.data
socket=/home/vagrant/sync/mysql.data/mysql.sock
user=mysql
symbolic-links=0
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

chown -R mysql:mysql /home/vagrant/sync/mysql.data
ln -s /home/vagrant/sync/mysql.data/mysql.sock /var/lib/mysql/mysql.sock
ln -s /home/vagrant/sync/mysql.data/mysql /var/lib/mysql/mysql
chown -R mysql:mysql /var/lib/mysql

mkdir /home/vagrant/sync/mysql.data/ib_log
mv /home/vagrant/sync/mysql.data/ib_logfile* /home/vagrant/sync/mysql.data/ib_log
cp /home/vagrant/sync/mysql.data/ib_log/* /home/vagrant/sync/mysql.data
chkconfig mysqld --add
chkconfig mysqld on --level 2345
service mysqld start
rm -rf /home/vagrant/sync/mysql.data/ib_log

mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; UPDATE mysql.user SET Password = PASSWORD('vagrant') WHERE User='root'; FLUSH PRIVILEGES;" > /dev/null 2>&1

cd /home/vagrant/sync
tar cvfp /tmp/home/vagrant/sync_local.tgz conf.d/local.conf
tar cvfp /tmp/home/vagrant/sync_mysql.tgz mysql.data/ib* mysql.data/ib_logfile* mysql.data/ibdata* mysql.data/mysql/ mysql.data/performance_schema/ mysql.data/test/

chkconfig sendmail --add
chkconfig sendmail on --level 2345
service sendmail start

chkconfig httpd --add
chkconfig httpd on --level 2345
service httpd start

cat <<EOF > /etc/startup.sh
chkconfig httpd --add
chkconfig httpd on --level 2345
service httpd restart
mkdir /home/vagrant/sync/mysql.data/ib_log
mv /home/vagrant/sync/mysql.data/ib_logfile* /home/vagrant/sync/mysql.data/ib_log
cp /home/vagrant/sync/mysql.data/ib_log/* /home/vagrant/sync/mysql.data
chkconfig mysqld --add
chkconfig mysqld on --level 2345
service mysqld restart
rm -rf /home/vagrant/sync/mysql.data/ib_log
chkconfig sendmail --add
chkconfig sendmail on --level 2345
service sendmail restart
EOF

cat <<EOF > /etc/init/vagrant-mounted.conf
start on vagrant-mounted
exec sudo sh /etc/startup.sh
EOF

cat <<EOF > /etc/netfix.sh
rm -f /etc/udev/rules.d/70-persistent-net.rules
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
EOF

sh /etc/netfix.sh
