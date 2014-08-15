#!/bin/sh
# $Id: davesmail_dump.sh,v 1.3 2008/08/05 19:19:17 sfrattura Exp $
# Created 7/08 by rbraun

# Base Variables

. /etc/manhunt/source.sh

LOG=$CARE_LOG
VERBOSITY=-v

ERROR=1

# Parameter is number of days to retain

DAYS_RETAIN=$1

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
echo "START $APPNAME `date`" >> $LOG

$MYSQL -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST $VERBOSITY -e "DELETE FROM DavesMail WHERE DATE(whn) < DATE(NOW() - INTERVAL $DAYS_RETAIN DAY)" admin >> $LOG

echo "FINISH $APPNAME `date`" >> $LOG
