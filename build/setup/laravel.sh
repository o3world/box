sh /etc/netfix.sh

cd /tmp

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod 755 /usr/local/bin/composer

curl -sS http://laravel.com/laravel.phar -o /usr/local/bin/laravel
chmod 755 /usr/local/bin/laravel

cat <<EOF > /sync/conf.d/laravel.local.conf
<VirtualHost *:80>
    DocumentRoot /sync/laravel/public
    ServerName laravel.local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/sync/laravel/public">
        Options +FollowSymLinks
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^ index.php [L]
    </Directory>
</VirtualHost>
EOF

cd /sync
rm -rf laravel
/usr/local/bin/composer self-update
/usr/local/bin/laravel new laravel
cd laravel
rm -rf vendor
/usr/local/bin/composer update
chmod -R 777 /sync/laravel
chmod -R g+s /sync/laravel

cd /sync
tar cvfp /tmp/sync_laravel.tgz conf.d/laravel.local.conf laravel/
