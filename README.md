# elite-cloud

### Requirements

* Apache2
* MySQL
* PHP

### Installing
 
 Go to /var/www and run the following commands:
 
    apt-get install unzip
    git clone -b develop https://github.com/elitepvpers-community/elite-cloud elite-cloud.de
    cd elite-cloud.de
    chmod -R 777 .
    ./composer.phar install
    mysql -u root -p < elitecloud.sql
  
### Updating

    git pull
    ./composer.phar install
  
### License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
