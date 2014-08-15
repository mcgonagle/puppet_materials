#!/bin/sh
# Base Variables

. /etc/manhunt/source.sh

# YOU SHOULD ALTER THESE VARIABLES
#### note: % sign at end for wildcard search!  Can be in front too!
subject="%Private PIX Unlocked!%"
fromUid=753682
beginDate='2008-12-22 09:00'


# DO NOT TOUCH VARIABLES BELOW.  THEY ARE STANDARD!
TESTBIN=$MYSQL
DB=$MESSAGEDB
PASS=$DBPASSWD
USER=$DBUSER
LOG=$CARE_LOG
HOSTS="$MAILDBHOSTS_S"
VERBOSITY=-vv
ERROR=1


for h in $HOSTS
do
if [ "`$TESTBIN -u $DBUSER -h $h -p$PASS $DB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database."
exit $ERROR
fi
done


if [ "`touch $LOG`" != "" ]
then
echo "Cannot write to logfile."
exit $ERROR
fi


echo "START $APPNAME `date`" >> $LOG
for h in $HOSTS
do
echo "deleting from $h  -- `date`" >> $LOG

  # all tables that match Inbox should have old records deleted
  for t in `$TESTBIN -u $DBUSER -h $h -p$PASS $DB -e 'show tables'`
  do
    for i in `echo $t | /bin/awk '/Inbox/ {print $1}'`
    do
    $TESTBIN -u $USER -h $h -p$PASS $DB $VERBOSITY -e "delete from $i where subject like '$subject' and fromUid=$fromUid and date>='$beginDate'"  >> $LOG
    done
  done
done # end of go through hosts

echo "END $APPNAME `date`" >> $LOG
exit 0

