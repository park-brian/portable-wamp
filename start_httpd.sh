#!/bin/bash
export PATH=$PATH:$PWD/environment/httpd/bin:$PWD/environment/php:$PWD/environment/mysql/bin:$PWD/environment/bin
echo "httpd is now running [ctrl+c to exit]"

pushd environment/httpd > /dev/null
bin/httpd.exe
