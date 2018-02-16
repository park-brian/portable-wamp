#!/bin/bash

WORK_DIR="environment"
CONFIG_DIR="configuration"
DOWNLOADS_DIR="$WORK_DIR/downloads"
WEB_DIR="web"

HTTPD_VERSION="2.4.29"
MYSQL_VERSION="8.0.4-rc"
PHP_VERSION="7.1.9"

HTTPD_ARCHIVE="httpd-${HTTPD_VERSION}-o110g-x64-vc14.zip"
MYSQL_ARCHIVE="mysql-${MYSQL_VERSION}-winx64.zip"
PHP_ARCHIVE="php-${PHP_VERSION}-Win32-VC14-x64.zip"

declare -A FILE_ARCHIVE_MAP=(
  [$HTTPD_ARCHIVE]="httpd"
  [$MYSQL_ARCHIVE]="mysql"
  [$PHP_ARCHIVE]="php"
)

declare -A FILE_URLS=(
  [$HTTPD_ARCHIVE]="http://www.apachehaus.com/downloads/${HTTPD_ARCHIVE}"
  [$MYSQL_ARCHIVE]="https://dev.mysql.com/get/Downloads/MySQL-8.0/${MYSQL_ARCHIVE}"
  [$PHP_ARCHIVE]="http://windows.php.net/downloads/releases/archives/${PHP_ARCHIVE}"
)

declare -A FILE_EXTRACT_PATHS=(
  [$HTTPD_ARCHIVE]="Apache24"
  [$MYSQL_ARCHIVE]="mysql-${MYSQL_VERSION}-winx64"
  [$PHP_ARCHIVE]=""
)


echo "Windows Apache MySQL PHP (WAMP)"
echo
echo "This script will download and extract the following 64-bit components to the current directory: "
echo " - httpd ${HTTPD_VERSION}"
echo " - mysql ${MYSQL_VERSION}"
echo " - php ${PHP_VERSION}"
echo

mkdir -p "$DOWNLOADS_DIR" "$CONFIG_DIR"
for COMPONENT in httpd mysql php
do
  rm -rf "$DOWNLOADS_DIR/$COMPONENT"
  rm -rf "$WORK_DIR/$COMPONENT"
  mkdir -p "$WORK_DIR/$COMPONENT"
done

## ensure all files have been downloaded
for FILE in "${!FILE_URLS[@]}"; do
  FILEPATH="$DOWNLOADS_DIR/$FILE"

  if [ ! -e "$FILEPATH" ]; then
    URL=${FILE_URLS[$FILE]}
    echo -e "[DOWNLOAD] $FILE [FROM] $URL \n"
    curl -L "$URL" -o "$FILEPATH"
    echo
  else
    echo "[FILE EXISTS] $FILEPATH"
  fi
done

echo

## extract files to the appropriate directories
for FILE in "${!FILE_EXTRACT_PATHS[@]}"; do
  FILEPATH="$DOWNLOADS_DIR/$FILE"
  COMPONENT="${FILE_ARCHIVE_MAP[$FILE]}"
  EXTRACT_PATH="$DOWNLOADS_DIR/$COMPONENT/${FILE_EXTRACT_PATHS[$FILE]}"

  echo "[UNZIP] $FILEPATH [->] ${DOWNLOADS_DIR}/${COMPONENT}"
  unzip -u -q "$FILEPATH" -d "${DOWNLOADS_DIR}/${COMPONENT}"

  echo "[MV] $EXTRACT_PATH [->] ${WORK_DIR}/${COMPONENT}"
  mv -T "$EXTRACT_PATH" "${WORK_DIR}/${COMPONENT}"

  rm -rf "$DOWNLOADS_DIR/$COMPONENT"

  echo
done

## copy default overrides
echo "[COPY] $CONFIG_DIR/* [->] $WORK_DIR/"
cp -rf $CONFIG_DIR/* "$WORK_DIR/"
echo

## initialize mysql
echo "[INITIALIZE] mysqld.exe --initialize-insecure --log_syslog=0"
pushd "$WORK_DIR/mysql/bin" > /dev/null
./mysqld.exe --initialize-insecure --log_syslog=0
echo
popd > /dev/null


## create web dir
if [ ! -d $WEB_DIR ]; then
  echo "[INITIALIZE] mkdir $WEB_DIR/"
  mkdir -p "$WEB_DIR"
  echo '<?php phpinfo();' > "$WEB_DIR/index.php"
  echo
fi

## install composer
echo "[DOWNLOAD] composer.phar [FROM] https://getcomposer.org/composer.phar"
pushd "$WORK_DIR/bin" > /dev/null
curl -L -o composer https://getcomposer.org/composer.phar
echo
popd > /dev/null
