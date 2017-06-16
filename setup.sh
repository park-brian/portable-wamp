#!/bin/bash

WORK_DIR="environment"
TEMP_DIR="$WORK_DIR/temp"
OVERRIDES_DIR="$WORK_DIR/overrides"
HTDOCS_DIR="htdocs"

HTTPD_VERSION="2.4.25"
MYSQL_VERSION="5.7.17"
PHP_VERSION="7.1.6"

HTTPD_ARCHIVE="httpd-${HTTPD_VERSION}-x64-vc14-r1.zip"
MYSQL_ARCHIVE="mysql-${MYSQL_VERSION}-winx64.zip"
PHP_ARCHIVE="php-${PHP_VERSION}-Win32-VC14-x64.zip"

declare -A FILE_ARCHIVE_MAP=(
  [$HTTPD_ARCHIVE]="httpd"
  [$MYSQL_ARCHIVE]="mysql"
  [$PHP_ARCHIVE]="php"
)

declare -A FILE_URLS=(
  [$HTTPD_ARCHIVE]="http://www.apachehaus.com/downloads/${HTTPD_ARCHIVE}"
  [$MYSQL_ARCHIVE]="https://downloads.mysql.com/archives/get/file/${MYSQL_ARCHIVE}"
  [$PHP_ARCHIVE]="http://windows.php.net/downloads/releases/${PHP_ARCHIVE}"
)

declare -A FILE_EXTRACT_PATHS=(
  [$HTTPD_ARCHIVE]="Apache24"
  [$MYSQL_ARCHIVE]="mysql-5.7.17-winx64"
  [$PHP_ARCHIVE]=""
)


echo "Windows Apache MySQL PHP (WAMP)"
echo
echo "This script will download and extract the following 64-bit components to the current directory: "
echo " - httpd ${HTTPD_VERSION}"
echo " - mysql ${MYSQL_VERSION}"
echo " - php ${PHP_VERSION}"
echo

mkdir -p $TEMP_DIR $OVERRIDES_DIR
for COMPONENT in httpd mysql php bin
do
  rm -rf "$TEMP_DIR/$COMPONENT"
  rm -rf "$WORK_DIR/$COMPONENT"
  mkdir -p "$WORK_DIR/$COMPONENT"
done

## ensure all files have been downloaded
for FILE in "${!FILE_URLS[@]}"; do
  FILEPATH="$TEMP_DIR/$FILE"

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
  FILEPATH="$TEMP_DIR/$FILE"
  COMPONENT="${FILE_ARCHIVE_MAP[$FILE]}"
  EXTRACT_PATH="$TEMP_DIR/$COMPONENT/${FILE_EXTRACT_PATHS[$FILE]}"

  echo "[UNZIP] $FILEPATH [->] ${TEMP_DIR}/${COMPONENT}"
  unzip -u -q $FILEPATH -d "${TEMP_DIR}/${COMPONENT}"

  echo "[MV] $EXTRACT_PATH [->] ${WORK_DIR}/${COMPONENT}"
  mv -T "$EXTRACT_PATH" "${WORK_DIR}/${COMPONENT}"

  echo
done

## copy default overrides
echo "[COPY] $OVERRIDES_DIR/* [->] $WORK_DIR/"
cp -rf $OVERRIDES_DIR/* "$WORK_DIR/"


## initialize mysql
echo "[INITIALIZE] mysqld.exe --initialize-insecure --log_syslog=0"
pushd $WORK_DIR/mysql/bin > /dev/null
winpty mysqld.exe --initialize-insecure --log_syslog=0
popd


## create htdocs dir
echo "[INITIALIZE] mkdir htdocs"
mkdir -p htdocs
echo '<?php phpinfo();' > htdocs/index.php


