#!/bin/bash

source "$PWD/.bashrc"

## start mysqld
echo "mysqld is now running [ctrl+c to exit]"
mysqld.exe -u root --console --default-authentication-plugin=mysql_native_password
