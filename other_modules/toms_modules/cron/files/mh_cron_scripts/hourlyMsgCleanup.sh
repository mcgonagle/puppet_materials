#!/bin/sh
# $Id: hourlyMsgCleanup.sh,v 1.6 2008/07/09 21:01:55 tmcgonagle Exp $

. /etc/manhunt/source.sh

HOSTS="$MAILDB0024 $MAILDB2549"
LOG=${CARE_LOG}
ERROR=1
VERBOSITY=-vv
#VERBOSITY=

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

# get the uid and # over 500 that user is, for Inbox and Sent, who haven't had activity in the last 10 minutes
# (haven't changed their mailboxes and/or had new messages put there)

for host in $HOSTS
do
  if [ "`$MYSQL -u $DBUSER -h $host -p$DBPASSWD $MESSAGEDB -e 'show databases'`" == "" ]
  then
  echo "Cannot connect to $MESSAGEDB on $host"
  exit $ERROR
  fi

  for row in `$MYSQL -u $DBUSER -p$DBPASSWD -h $host $MESSAGEDB -e "SELECT concat(uid,',',totalMsgs-LEAST(totalMsgs,500),',',totalSent-LEAST(totalSent,500)) FROM MessageTotals WHERE (totalMsgs>500 or totalSent>500) AND modified < NOW() - INTERVAL 10 MINUTE"`
  do
  uid=`echo $row | cut -f1 -d,`
  overInbox=`echo $row | cut -f2 -d,`
  overSent=`echo $row | cut -f3 -d,`

  lastTwo=`echo $uid | perl -nle 'm/(..$)/;print $1'`
  if [ -e $lastTwo ]
  then
  lastTwo=0`echo $uid | perl -nle 'm/(.$)/;print $1'`
  fi 

if [ "$overInbox" != "'" ]  
then
  if [ $overInbox -gt 0 -a $lastTwo = "00" ]
  then
  $MYSQL -u $DBUSER -p$DBPASSWD -h $host $MESSAGEDB $VERBOSITY -e "delete Table1 from Inbox_$lastTwo Table1 join (select msgid FROM Inbox_$lastTwo WHERE toUid=$uid ORDER BY modified desc LIMIT 500, $overInbox) as Table2 using(msgid);" >> $LOG
  $MYSQL -u $DBUSER -p$DBPASSWD -h $host $MESSAGEDB $VERBOSITY -e "UPDATE MessageTotals SET totalMsgs=500 WHERE uid=$uid" >> $LOG
  fi
fi

if [ "$overSent" != "'" ]  
then
  if [ $overSent -gt 0 -a $lastTwo = "00" ]
  then
  $MYSQL -u $DBUSER -p$DBPASSWD -h $host $MESSAGEDB $VERBOSITY -e "delete Table1 from Sent_$lastTwo Table1 join (select sentmsgid from Sent_$lastTwo WHERE fromUid=$uid ORDER BY modified desc LIMIT 500, $overSent) as Table2 using(sentmsgid);" >> $LOG
  $MYSQL -u $DBUSER -p$DBPASSWD -h $host $MESSAGEDB $VERBOSITY -e "UPDATE MessageTotals SET totalSent=500 WHERE uid=$uid" >> $LOG
  fi
fi
  done
done

echo FINISH $APPNAME `date` >> $LOG
