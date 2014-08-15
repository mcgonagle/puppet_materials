#!/bin/sh
# email_sessions.sh
# $Id: email_sessions.sh,v 1.1 2008/07/03 19:40:51 rbraun Exp $
#
. /etc/manhunt/source.sh

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
 echo "Must be care to run this script."
  exit $ERROR
fi

if [ "`$MYSQL -u $DBUSER -h $MHMASTERDBHOST -p$DBPASSWD $MANHUNTDB -e 'show databases'`" == "" ]
then
echo "Cannot connect to uid database."
exit $ERROR
else
OUT=`$MYSQL -u $DBUSER -h $MHMASTERDBHOST -p$DBPASSWD $MANHUNTDB -e "select count(uid) as 'men online' from Sessions where logout!=1"`
fi
echo `date`
echo $OUT
