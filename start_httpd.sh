#!/bin/bash
WORK_DIR="environment"
export PATH=$PATH:$PWD/$WORK_DIR/httpd/bin:$PWD/$WORK_DIR/php:$PWD/$WORK_DIR/mysql/bin:$PWD/$WORK_DIR/bin
echo "httpd is now running [ctrl+c to exit]"

pushd environment/httpd > /dev/null
bin/httpd.exe
