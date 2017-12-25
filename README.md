## Portable WAMP
A portable Windows-Apache-MySQL-PHP environment based on mintty (git bash)

### Current Versions
 - Apache HTTP Server 2.4.29
 - MySQL 8.0.3-rc
 - PHP 7.1.9

### Getting Started
```sh
git clone https://github.com/park-brian/portable-wamp
cd portable-wamp
./setup.sh
```

If git bash has been set as the default file handler for `.sh` files, you may double-click on each of the scripts to start each component (or just use bash shell). A `start_bash.sh` script is also provided that launches git bash with each of the components in the path (including php composer). To exit from httpd and mysqld, use `ctrl+c`. 
