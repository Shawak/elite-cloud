# elite-cloud

### Requirements:
* vagrant
* git

### Installing:
Run the following commands:

    git clone git@gitlab.com:elitepvpers-external/elite-cloud.git
    vagrant up
    vagrant ssh
    cd /var/www/app/
    composer install
    cd ..
    cd dump
    mysql -u root -p < *dump*.sql

Now enter your mysql root passwort and you are done!

### Updating:

    cd /var/www/app
    git reset --hard
    git pull
    chmod -R 777 /var/www/app
    composer install

### Configure:

You may enter personal data/passwords into a `config-update.php` file to overwrite the `config.php` this way to prevent uploading them during development.

### License
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
