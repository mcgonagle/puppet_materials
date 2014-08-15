#!/bin/sh
# $Id: user_throttle.sh,v 1.4 2008/07/28 18:41:45 rbraun Exp $
#
# Kick off sessions over the specified threshold (passed as first parameter)

. /etc/manhunt/source.sh

MAXUSERS=$1
LOG=$CARE_LOG
VERBOSITY=

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

CURRENT_OVER=0
NOW_ON=0

if [ "`$MYSQL -u $DBUSER -h $MHMASTERDBHOST -p$DBPASSWD $VERBOSITY $MANHUNTDB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database."
exit $ERROR
fi

CURRENT_OVER=$($MYSQL -u $DBUSER -h $MHMASTERDBHOST --password=$DBPASSWD $VERBOSITY $MANHUNTDB -e "select @MyCount:=count(*)-$MAXUSERS as '' from Sessions;")

# if greater than zero (i.e. more than 45,000 guys online), run the "kick out" query
if [ $CURRENT_OVER -gt 0 ]
then
     NOW_ON=$[ $MAXUSERS + $CURRENT_OVER]
#     echo "("`date`") USER THROTTLE SCRIPT: Script Disabled, or I would have marked.... $CURRENT_OVER for deletion!"  >> $LOG

     echo " -- ("`date`"marking $CURRENT_OVER for deletion, above $MAXUSERS" >> $LOG
     $MYSQL -u $DBUSER -h $MHMASTERDBHOST --password=$DBPASSWD $VERBOSITY $MANHUNTDB -e "UPDATE Sessions SET logout=1 WHERE type !='paid' AND logout!=1 ORDER BY lastLogin LIMIT $CURRENT_OVER;" >> $LOG

else
     NOW_ON=$[ $MAXUSERS + $CURRENT_OVER]
     echo " -- $NOW_ON men online now, under limit $MAXUSERS"  >> $LOG
fi

echo "FINISH $APPNAME `date`" >> $LOG
echo >> $LOG

exit 0;
