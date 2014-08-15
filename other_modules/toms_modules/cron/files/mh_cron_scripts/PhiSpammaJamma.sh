#!/bin/sh
# $Id: PhiSpammaJamma.sh,v 1.7 2008/11/06 20:25:02 sfrattura Exp $
# Created 2/08 by sfrattura

# Base Variables

. /etc/manhunt/source.sh

DB=$MESSAGEDB
BIN=$MYSQLDUMP
TESTBIN=$MYSQL
LOG=$CARE_LOG

MYRESULTS=""
SQL1=""
ERROR=1

# Threshold is number of messages; timeframe is number of hours

SPAM_THRESHOLD=$1
SPAM_TIMEFRAME=$2

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

for h in $MAILDBHOSTS_S
do
  if [ "`$TESTBIN -u $DBUSER -h $h -p$DBPASSWD $DB -e 'show databases'`" == "" ]
  then
    echo "Cannot connect to database."
    exit $ERROR
  fi
done


for h in $MAILDBHOSTS_S
do


$TESTBIN -u $DBUSER -h $h -p$DBPASSWD $DB -e "create table if not exists PhiSpammaJamma (fromUid int(10), TotalSent int (10), subj varchar(50), Body text )"
$TESTBIN -u $DBUSER -h $h -p$DBPASSWD $DB -e "truncate TABLE PhiSpammaJamma "


echo " `date +%H:%M:%S` -- Server: $h" >> $LOG

  # all tables that match Inbox should have old records deleted
  for t in `$TESTBIN -u $DBUSER -h $h -p$DBPASSWD  $DB -e 'show tables'`
  do
    for i in `echo $t | /bin/awk '/Sent/ {print $1}'`
    do

      SQL1="insert PhiSpammaJamma select fromUid, count(distinct toUid) as MyTot, subject, body  from $t where fromUid not in (1,2,588516,2338977,1458169,2338986,2653350,1458175,2338928,513808,1773532,2338890,588516,958964,1498198,1514710) and date >= date_sub(now(), INTERVAL $SPAM_TIMEFRAME HOUR) group by fromUid, subject having MyTot > $SPAM_THRESHOLD;" 

      $TESTBIN -u $DBUSER -h $h -p$DBPASSWD  $DB  -e "$SQL1" 
      done
  done

#--before emailing, check to see if this record exists in the PhiSpammaJamma database
$TESTBIN -u $DBUSER -h $h -p$DBPASSWD $DB -e  "insert ignore into SpamThrottle select fromUid, subj, now() from PhiSpammaJamma group by fromuid, subj\G"

#--now email the results, if necessary
$TESTBIN -u $DBUSER -h $h -p$DBPASSWD $DB -e  "select fromUid, TotalSent, subj, body from PhiSpammaJamma where fromuid not in (select fromUid from SpamThrottle where NotifyDate < date_sub(now(), INTERVAL 2 minute)) group by fromuid, subj\G;" | tee --append $LOG

done # end of go through hosts
echo "FINISH $APPNAME `date`" >> $LOG

exit 0;


