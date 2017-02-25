# elite-cloud

### Installing using vargrant

    git clone -b develop https://github.com/elitepvpers-community/elite-cloud elite-cloud
    vagrant up
    vagrant ssh
    cd /var/www/elite-cloud
    composer install
    mysql -u root -p < elitecloud.sql
    
Now enter your mysql root passwort and you are done!

### Installing (linux)

Install Apache, PHP7, MySQL and Composer

    apt-get install unzip
    cd /var/www
    git clone -b develop https://github.com/elitepvpers-community/elite-cloud elite-cloud
    chmod -R 777 elite-cloud
    cd elite-cloud
    composer install
    mysql -u root -p < elitecloud.sql

### Updating

    cd /var/www/elite-cloud
    git reset --hard
    git pull
    chmod -R 777 /var/www/elite-cloud
    composer install

### Configure

You may enter personal data/passwords into a `config-update.php` file to overwrite the `config.php` this way to prevent uploading them during development.

### License
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
