#!/bin/bash

source /etc/profile

WORK_DIR="environment"
export PATH=$PWD/$WORK_DIR/httpd/bin:$PWD/$WORK_DIR/php:$PWD/$WORK_DIR/mysql/bin:$PWD/$WORK_DIR/bin:$PATH
[[ -d $PWD/web/vendor/bin ]] && export PATH=$PATH:$PWD/web/vendor/bin
export COMPOSER_PROCESS_TIMEOUT=2000

