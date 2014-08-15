#!/bin/bash

. /etc/manhunt/source.sh

ROOT=/usr/local/src/manhunt
LOG=/var/log/dailydownload/current
LOG_DATE=/var/log/dailydownload/`date +%F`-DailyDownload.log
echo logtime >> ${LOG}
cd $ROOT/batch
/usr/local/zend/bin/php $ROOT/batch/dailyDownload.php
if [ "$?" = 0 ] ; then
    echo "DailyDownload was successful."
else
    echo "DailyDownload has complete Failure."
fi  

cp $LOG $LOG_DATE
