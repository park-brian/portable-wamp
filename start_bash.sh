#!/bin/bash

WORK_DIR="environment"
export PATH=$PWD/$WORK_DIR/httpd/bin:$PWD/$WORK_DIR/php:$PWD/$WORK_DIR/mysql/bin:$PWD/$WORK_DIR/bin:$PATH
export COMPOSER_PROCESS_TIMEOUT=2000

bash --init-file /etc/profile