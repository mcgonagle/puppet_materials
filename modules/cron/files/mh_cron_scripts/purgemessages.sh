#!/bin/sh
# purgemessages.sh
# $Id: purgemessages.sh,v 1.6 2008/08/06 16:51:22 sfrattura Exp $
#
. /etc/manhunt/source.sh

HOSTS=$MAILDBHOSTS
LOG=$CARE_LOG
VERBOSITY=-vv
UIDDB=$MANHUNTDB
UIDHOST=$MHMASTERDBHOST

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
if [ "`$MYSQL -u $DBUSER -h $UIDHOST -p$DBPASSWD $UIDDB -e 'show databases'`" == "" ]
then
echo "Cannot connect to uid database." | mail -s "purge failed, cannot connect to uid database" $MHMONITOR
exit $ERROR
else 
OUT=`$MYSQL -u $DBUSER -h $UIDHOST -p$DBPASSWD $UIDDB -e "select uid from Users where type in ('org','ipn') "`
fi

fooey='$2';
orgs=0;

for l in $OUT
do
add=`echo $l | /bin/awk '/[0-9]/ { print $fooey } '`
if [ "$add" != "" ]
then
orgs=`echo "$orgs,$add"`
fi 
done
 
for h in $HOSTS 
do
if [ "`$MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database." | mail -s "purge message script cannot connect to $MESSAGEDB on $HOSTS" $MHMONITOR
exit $ERROR
fi
done

if [ "`touch $LOG`" != "" ]
then 
echo "Cannot write to logfile." | mail -s "purge message script can't write to $LOG" $MHMONITOR
exit $ERROR
fi

echo START `date` >> $LOG
echo ORGS=$orgs >> $LOG


for h in $HOSTS
do
  # all tables that match Sent and Inbox should have old records deleted
  for t in `$MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB -e 'show tables'`
  do
    for i in `echo $t | /bin/awk '/Inbox/ {print $1}'`
    do
    $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB -vv -e "delete from $i where date < DATE_SUB(NOW(),INTERVAL ${INTERVAL_DAY} DAY) and toUid not in ($orgs);" >> $LOG
    echo $i `date` >> $LOG
#     # prepopulate MessageTotals 
#     $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB $VERBOSITY -e "REPLACE INTO MessageTotals (uid,totalMsgs,unreadMsgs,totalSent,unreadSent,totalSaved) SELECT toUid,COUNT(msgid) as num, SUM(IF(seen,0,1)) as unread,0,0,0 FROM $i GROUP BY toUid" >> $LOG;
#     echo "prepopulated MessageTotals for $i" >> $LOG
#     echo `date` >> $LOG
   done
    for s in `echo $t | /bin/awk '/Sent/ {print $1}'`
    do 
    $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB -vv -e "delete from $s where date < DATE_SUB(NOW(),INTERVAL ${INTERVAL_DAY} DAY) and fromUid not in ($orgs);" >> $LOG
#     $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB $VERBOSITY -e "REPLACE INTO counts (uid,totalSent,unreadSent) SELECT fromUid,COUNT(msgid) as num, SUM(IF(seen,0,1)) as unread FROM $s GROUP BY fromUid" >> $LOG;
#     $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB $VERBOSITY -e "UPDATE MessageTotals mt INNER JOIN counts USING (uid) SET mt.totalSent=counts.totalSent, mt.unreadSent=counts.unreadSent" >> $LOG;
    echo $s `date` >> $LOG
    sleep 5;
    done
   for r in `echo $t | /bin/awk '/Trash/ {print $1}'`
    do
    $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB -vv -e "delete from $r where modified < DATE_SUB(NOW(),INTERVAL 24 HOUR);" >> $LOG
    echo $r `date` >> $LOG
   done
#    for v in `echo $t | /bin/awk '/Saved/ {print $1}'`
#    do
#     $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB $VERBOSITY -e "REPLACE INTO counts (uid,totalSaved) SELECT toUid,COUNT(msgid) as num FROM $v GROUP BY toUid" >> $LOG;
#     $MYSQL -u $DBUSER -h $h -p$DBPASSWD $MESSAGEDB $VERBOSITY -e "UPDATE MessageTotals mt INNER JOIN counts USING (uid) SET mt.totalSaved=counts.totalSaved" >> $LOG;
#   done
  done
done
echo END `date` >> $LOG
${CRON_DIR}/recount2.py;

exit 0;


