#!/bin/sh
# $Id: BreakThruEmail.sh,v 1.2 2008/11/20 19:33:56 sfrattura Exp $
#


. /etc/manhunt/source.sh

PASS=${DBPASSWD}
USER=${DBUSER}
DB=${MANHUNTDB}
HOST=${DWHOST2}
LOG=${CARE_LOG}


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

/usr/bin/mysql -u $DBUSER -h $HOST -p$DBPASSWD $DB  -s -e "select uid, username, email, created from Users where date(created) = date(now()-interval 1 day) and email like '%@breakthru.com%'" | tee --append $LOG

echo FINISH $APPNAME `date` >> $LOG
echo >> $LOG

exit 0;
