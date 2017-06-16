#!/bin/bash

WORK_DIR="environment"
export PATH=$PATH:$PWD/$WORK_DIR/httpd/bin:$PWD/$WORK_DIR/php:$PWD/$WORK_DIR/mysql/bin:$PWD/$WORK_DIR/bin
export COMPOSER_PROCESS_TIMEOUT=2000

bash
