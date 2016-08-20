#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
MYSQLPASSWORD='my123456'
PHPADMINPASSWORD='php123456'
PROJECTFOLDER=''
DATABASE='elite-cloud'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# upgrade from php 5.5.9 to 5.6.16-3
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PHPADMINPASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PHPADMINPASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get -y install php5-mysql

# install mssql
sudo apt-get -y install php5-mssql

# install phpmyadmin and give password(s) to installer
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPADMINPASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PHPADMINPASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPADMINPASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/${PROJECTFOLDER}"
    <Directory "/var/www/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# install php5 mcrypt
sudo apt-get install php5-mcrypt
sudo cd /etc/php5/mods-available
sudo ln -sf ../conf.d/mcrypt.ini .
sudo php5enmod mcrypt


# restart apache
service apache2 restart


sudo chmod 755 ./var/www/composer.phar
sudo chmod -R 777 /var/www/
sudo mysql -uroot -p$PHPADMINPASSWORD -e "create database elite_cloud"
sudo mysql -u root -p$PHPADMINPASSWORD elite_cloud < /var/www/elite-cloud.sql