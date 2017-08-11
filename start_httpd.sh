#!/bin/bash

source "$PWD/.bashrc"

pushd environment/httpd > /dev/null
echo "httpd is now running [ctrl+c to exit]"
bin/httpd.exe
popd
