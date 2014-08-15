#!/bin/sh

PASS="Pdn1uL+p"
DBUSER="root"
CARE_USER=care
BIN=/usr/bin/mysql
HOST=localhost
LOG=/var/log/masterpurge.log
ERROR=1
PRESERVE="90 minute"

# Run as care.
if [ "$USER" != "$CARE_USER" ]
then
 echo "Must be $CARE_USER to run this script, you are $USER."
  exit $ERROR
fi

if [ "`$BIN -u $DBUSER -h $HOST -p$PASS -e 'show databases'`" == "" ]
then
echo "Cannot connect to database."
exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then
echo "Cannot write to logfile."
exit $ERROR
fi

echo `date` >> $LOG
$BIN -u $DBUSER -h $HOST --password=$PASS -vv -e "PURGE MASTER LOGS BEFORE DATE_SUB(NOW(),INTERVAL $PRESERVE);" >> $LOG
ls -lrth /var/log/mysql/*bin* >> $LOG
