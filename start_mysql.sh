#!/bin/bash

WORK_DIR="environment"
export PATH=$PATH:$PWD/environment/httpd/bin:$PWD/environment/php:$PWD/environment/mysql/bin:$PWD/environment/bin
echo "mysqld is now running [ctrl+c to exit]"

## start mysqld
pushd $WORK_DIR/mysql/bin > /dev/null
./mysqld.exe -u root --log_syslog=0
popd

