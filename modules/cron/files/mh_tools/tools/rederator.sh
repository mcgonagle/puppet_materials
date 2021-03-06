#!/bin/bash

PURPOSE=${1}

## Will do this one later.
COLOR=${2}

APP_YML_FILE="/usr/local/src/manhunt/apps/${PURPOSE}/config/app.yml"
APP_YML_DIR="/usr/local/src/manhunt/apps/${PURPOSE}/config/"
MANHUNT_DIR='/usr/local/src/manhunt'
MANHUNT_CONFIG_PHP='/etc/config.php'

echo Checking ${APP_YML_FILE}...

if [ ! -e "${APP_YML_FILE}" ]; then
  echo "${APP_YML_FILE} not found."
  exit
fi

cd ${APP_YML_DIR}
sed -i 's/im01.manhunt.net, im02.manhunt.net, im03.manhunt.net/red-chat01.qa.manhunt.net/g' $APP_YML_FILE
sed -i 's/209.67.254.143/192.168.200.59/g' $APP_YML_FILE
sed -i 's/cache07.waltham/red-cache01.qa/g' $APP_YML_FILE
sed -i 's/cache06.v4.waltham/red-cache01.qa/g' $APP_YML_FILE
sed -i 's/maindb00.v4.waltham/red-maindb.qa/g' $APP_YML_FILE
sed -i 's/mainro00.v4.waltham/red-mainro.qa/g' $APP_YML_FILE
sed -i 's/cache08.waltham/red-cache01.qa/g' $APP_YML_FILE
sed -i 's/mailshard01.waltham/red-mail01.qa/g' $APP_YML_FILE
sed -i 's/mailshard02b.waltham/red-mail02.qa/g' $APP_YML_FILE
sed -i 's/mailshard03b.waltham/red-mail03.qa/g' $APP_YML_FILE
sed -i 's/mailshard04b.waltham/red-mail04.qa/g' $APP_YML_FILE
sed -i 's/trackdb00.v4.waltham/red-trackdb.qa/g' $APP_YML_FILE

## This is a dumb hack.  Alex knows about this.  He should fix it.  
## He says he will.  RSN.

cp $MANHUNT_CONFIG_PHP $MANHUNT_DIR/config/config.php

## Symfony cc

cd $MANHUNT_CONFIG
symfony cc