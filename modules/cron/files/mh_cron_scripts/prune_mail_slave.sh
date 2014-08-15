#!/bin/sh
# $Id: prune_mail_slave.sh,v 1.4 2009/08/11 14:33:02 mjapher Exp $
# Created 8/07 by mjapher

# Base Variables

. /etc/manhunt/source.sh


LOG=$CARE_LOG
VERBOSITY=-v

ERROR=1

SHARD=$1

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

$MYSQL -u $V4_USER -p$V4_PW -h $SHARD $VERBOSITY $V4_MAILDB -e "call mail_pruner()">> $LOG

echo "FINISH $APPNAME `date`" >> $LOG
