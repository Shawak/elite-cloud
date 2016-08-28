# elite-cloud

### Requirements

* Apache2
* MySQL
* PHP

### Installing
 
 Run the following commands:
 
    apt-get install unzip
    cd /var/www
    git clone -b develop https://github.com/elitepvpers-community/elite-cloud elite-cloud
    chmod -R 777 elite-cloud
    cd elite-cloud
    ./composer.phar install
    mysql -u root -p < elitecloud.sql
    
Now enter your mysql root passwort and you are done!
  
### Updating

    cd /var/www/elite-cloud
    git reset --hard
    git pull
    chmod -R 777 /var/www/elite-cloud
    ./composer.phar install
  
### License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
