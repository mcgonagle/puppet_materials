#!/bin/sh
# sessionsclean.sh
# $Id: US_FutureRebills.sh,v 1.3 2008/08/22 20:29:01 tmcgonagle Exp $
#
. /etc/manhunt/source.sh

##HOST=${MHMASTERDBHOST}
HOST=${DWHOST}

VERBOSITY=-v
LOG=${CARE_LOG}

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
 echo "Must be care to run this script."
  exit $ERROR
fi  

if [ "`$MYSQL -u $DBUSER -h $HOST -p$DBPASSWD $MANHUNTDB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database."
exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then 
echo "Cannot write to logfile."
exit $ERROR
fi
echo "START $APPNAME `date`" >> $LOG




$MYSQL -u $DBUSER -h $HOST -p$DBPASSWD $MANHUNTDB $VERBOSITY -e "insert PermanentArchive.USFutureRebills select date(now()),  sum(case when period =7 then 1 else 0 end) as 7DayCount, sum(case when period =7 then total else 0 end) as 7DayTotal, sum(case when period =30 then 1 else 0 end) as 30DayCount, sum(case when period =30 then total else 0 end) as 30DayTotal, sum(case when period =90 then 1 else 0 end) as 90DayCount, sum(case when period =90 then total else 0 end) as 90DayTotal, sum(case when period not in (7,30,90) then 1 else 0 end) as OtherCount, sum(case when period not in (7,30,90) then total else 0 end) as OtherTotal, count(*) as GrandCount, sum(total) as GrandTotal from Bill_Sched_Paym;" >> $LOG 




echo "FINISH $APPNAME `date`" >> $LOG

exit 0;
