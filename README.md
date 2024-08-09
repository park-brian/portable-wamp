## Portable WAMP

A portable Windows-Apache-MySQL-PHP environment

### Current Versions

- Apache HTTP Server 2.4.62
- MySQL Community Server 8.0.39
- PHP 8.3.9

### Getting Started

```sh
git clone https://github.com/park-brian/portable-wamp
cd portable-wamp
cscript setup.js # for git bash, use `winpty cscript setup.js`
```

### Further Instructions

After setup completes, you should update your mysql root password (by default, the root user is created without a password).
To do so, launch the mysql client (start_mysql_client.bat), and enter:

```sql
SET PASSWORD = 'my_password';
```

If you need to connect to a MS SQL Database, the `pdo_sqlsrv` php extension is included and enabled. However, the user must also install [Microsoft's ODBC Driver 17 for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-2017).

### Script Listing

Note: You may launch the scripts below by double-clicking on them if your system associates .bat files with powershell.exe or cmd.exe.

| Script Name            | Purpose                                                     |
| ---------------------- | ----------------------------------------------------------- |
| setup.js               | Sets up environment (launch with cscript)                   |
| shell.bat              | Launches shell with apache, mysql, and php binaries in path |
| start_httpd.bat        | Starts Apache http server                                   |
| start_mysqld.bat       | Starts MySQL server                                         |
| start_mysql_client.bat | Starts MySQL command-line client                            |

### File Locations

| Description                      | Location                          |
| -------------------------------- | --------------------------------- |
| Apache HTTP Server Configuration | environment/httpd/conf/httpd.conf |
| Apache HTTP Server Logs          | environment/httpd/logs            |
| MySQL Server Configuration       | environment/mysql/my.ini          |
| PHP Configuration                | environment/php/php.ini           |

### Drupal Quickstart

```sh
# Launch a shell which has the composer binary in its path
shell.bat

# Use composer to create a drupal website under the web/ folder
rmdir web
composer create-project drupal/recommended-project web

# The recommended-project template creates the Drupal root under web/web/, so we should set this as the new DocumentRoot.
# We can do this by uncommenting the following VirtualHost under environment/httpd/conf/extra/httpd-vhosts.conf
# <VirtualHost *:80>
#     DocumentRoot "../../web/web"
#     <Directory "../../web/web">
#         Options Indexes FollowSymLinks
#         AllowOverride All
#         Require all granted
#     </Directory>
# </VirtualHost>

# Next, start the httpd server
start_httpd.bat
```
