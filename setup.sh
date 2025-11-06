#!/bin/bash
set -ex

# name|url|subfolder
RESOURCES=(
    "httpd|https://www.apachelounge.com/download/VS17/binaries/httpd-2.4.65-250724-Win64-VS17.zip|Apache24"
    "mysql|https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.43-winx64.zip|mysql-8.0.43-winx64"
    "php|https://windows.php.net/downloads/releases/archives/php-8.4.13-Win32-vs17-x64.zip|"
)

mkdir -p environment/{archive,bin}

for r in "${RESOURCES[@]}"; do
    IFS='|' read -r name url sub <<< "$r"
    
    zip="environment/archive/$(basename "$url")"
    dir="environment/$name"
    
    # Download
    [ -f "$zip" ] || { echo "Downloading $url"; curl -fL "$url" -o "$zip"; }
    
    # Extract
    echo "Extracting to $dir"
    mkdir -p "$dir"
    if [ -n "$sub" ]; then
        unzip -qo "$zip" "$sub/*" -d "$dir" && mv "$dir/$sub"/* "$dir"/ && rmdir "$dir/$sub"
    else
        unzip -qo "$zip" -d "$dir"
    fi
    
    # Copy config
    [ -d "default-configuration/$name" ] && cp -r "default-configuration/$name"/* "$dir"/
done

# Initialize MySQL
echo "Initializing MySQL"
./environment/mysql/bin/mysqld --default-authentication-plugin=mysql_native_password --initialize-insecure || true

# Download Composer
echo "Downloading Composer"
curl -fL https://getcomposer.org/composer-stable.phar -o environment/bin/composer.php

echo "
Setup complete. Set a password for MySQL root user.

Next steps:
- start_httpd.bat
- start_mysqld.bat
- start_mysql_client.bat  
- shell.bat"