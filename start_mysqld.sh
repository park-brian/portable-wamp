#!/bin/bash

WORK_DIR="environment"
export PATH=$PATH:$PWD/$WORK_DIR/httpd/bin:$PWD/$WORK_DIR/php:$PWD/$WORK_DIR/mysql/bin:$PWD/$WORK_DIR/bin
echo "mysqld is now running [ctrl+c to exit]"

## start mysqld
pushd $WORK_DIR/mysql/bin > /dev/null
./mysqld.exe -u root --log_syslog=0
popd

