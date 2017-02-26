FROM php:7.0-apache

RUN docker-php-ext-install pdo pdo_mysql
RUN a2enmod rewrite

RUN rm /etc/apache2/sites-available/000-default.conf
RUN echo '\n\
<VirtualHost *:80>\n\
    DocumentRoot "/var/www/elite-cloud/app/public"\n\
    <Directory "/var/www/elite-cloud/app/public">\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>\n'\
>> /etc/apache2/sites-available/000-default.conf

RUN mkdir /var/www/elite-cloud

RUN echo "\n\
<?php\n\
\$config['db']['host'] = 'db';\n\
\$config['db']['user'] = 'root';\n\
\$config['db']['pass'] = '123456';\n\
\$config['db']['datb'] = 'elitecloud';\n\
">> /var/www/elite-cloud/config-update.php

EXPOSE 80
EXPOSE 443