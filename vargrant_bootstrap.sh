#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords

# Extra user and password to new created database
MYSQLPASSWORD='mysql1234567'
MYSQLUSER='datadev'
MAINDB='elitecloud'
# Main root password
PHPADMINPASSWORD='un2134h98n234fnv89Gweb31vA'
# Folder
PROJECTFOLDER='elite-cloud/public'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5
sudo apt-get install -y apache2

# install php 7.0.15-1
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y php7.0

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PHPADMINPASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PHPADMINPASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get -y install php7.0-mysql
sudo apt-get -y install php7.0-mbstring

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

# install php7.0 mcrypt
sudo apt-get -y install mcrypt php7.0-mcrypt

# creating database
mysql -uroot -p${PHPADMINPASSWORD} -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -uroot -p${PHPADMINPASSWORD} -e "CREATE USER ${MYSQLUSER}@localhost IDENTIFIED BY '${MYSQLPASSWORD}';"
mysql -uroot -p${PHPADMINPASSWORD} -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MYSQLUSER}'@'localhost';"
mysql -uroot -p${PHPADMINPASSWORD} -e "FLUSH PRIVILEGES;"

# restart apache
service apache2 restart
