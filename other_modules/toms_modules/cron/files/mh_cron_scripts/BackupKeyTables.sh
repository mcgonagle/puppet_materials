#!/bin/sh
# $Id: BackupKeyTables.sh,v 1.7 2009/01/16 21:14:25 sfrattura Exp $

#written by Sandro 2-5-2008 to backup the tables I will most likely
# need to do Cust Service restores

. /etc/manhunt/source.sh

LOG=$CARE_LOG
HOST=${DWHOST}
KEYBACKUPDIR=/var/backup/KeyTables


TABLES="Access BuddyList BlockedNotes SavedSearches SavedSearchItems Users HighScores NetLoginHistory"

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
 echo "Must be care to run this script."
  exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then
echo "Cannot write to logfile."
exit $ERROR
fi

echo START $APPNAME `date` >> $LOG

if [ "`$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB -e 'show tables'`" == "" ]
then
echo "Cannot connect to database beyotch."
exit $ERROR
fi

echo START BackupKeyTables `date` >> $LOG

# MYSQLDUMP the tables
for TABLE in $TABLES
do
  $MYSQLDUMP -h $HOST -u $DBUSER --password=$DBPASSWD --skip-opt $MANHUNTDB $TABLE | gzip > $KEYBACKUPDIR/$TABLE.sql.gz
  echo " -- Table $TABLE dumped at `date +%H:%M:%S`" >> $LOG
done

echo FINISH $APPNAME `date` >> $LOG
echo >> $LOG
