#!/bin/sh
# $Id: MailFlow.sh,v 1.3 2008/08/05 19:19:17 sfrattura Exp $
# Created 8/06 by sfrattura

# Base Variables

. /etc/manhunt/source.sh


LOG=$CARE_LOG
VERBOSITY=-v

ERROR=1


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

$MYSQL -u $DBUSER -p$DBPASSWD -h $MAILDB0024_S $VERBOSITY $MESSAGEDB -e "call get_hr_mail_count()">> $LOG
$MYSQL -u $DBUSER -p$DBPASSWD -h $MAILDB2549_S $VERBOSITY $MESSAGEDB -e "call get_hr_mail_count()">> $LOG

echo "FINISH $APPNAME `date`" >> $LOG
