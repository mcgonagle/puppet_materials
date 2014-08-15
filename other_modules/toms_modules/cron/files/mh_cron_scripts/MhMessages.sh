#!/bin/sh
# MhMessages.sh
# $Id: MhMessages.sh,v 1.1 2008/07/03 19:40:51 rbraun Exp $

. /etc/manhunt/source.sh

PASS=${DBPASSWD}
USER=${DBUSER}
DB=${MESSAGEDB}
TESTBIN=${MYSQL}
MHHOST=${MHMASTERDBHOST}
HOSTS=${MAILDBHOSTS}
LOG=${CARE_LOG}
RUN=${CARE_RUN}

echo START `date` >> $LOG
# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
 echo "Must be care to run this script."
  exit $ERROR
fi  

if [ "`$TESTBIN -u $USER -h $MHHOST -p$PASS $DB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database." | mail -s "manhunt message script cannot connect to $DB on $MHHOST" ${MHMONITOR}
exit $ERROR
else 
echo running query from dove
  $TESTBIN -u $USER -h $MHHOST -p$PASS $DB -e 'select @time:=TIMEDIFF(max(modified),min(modified)) as elapsedTime,@total:=count(toUsername) as totalUid,@distinct:=count(distinct toUsername) as distinctUid from Sent_MH union select HOUR(@time)*60*60+MINUTE(@time)*60+SECOND(@time),FORMAT(@distinct/@total*100,2),min(modified) from Sent_MH group by fromUid union select "seconds","pct distinct","min modified";'
fi

mv $RUN $RUN.1
echo "use Archives;" > $RUN
for h in $HOSTS 
do
if [ "`$TESTBIN -u $USER -h $h -p$PASS $DB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database." | mail -s "manhunt message script cannot connect to $DB on $h" ${MHMONITOR}
exit $ERROR
fi
done

if [ "`touch $LOG`" != "" ]
then 
echo "Cannot write to logfile." | mail -s "manhunt message script can't write to $LOG" ${MHMONITOR}
exit $ERROR
fi

for h in $HOSTS
do
  # all tables that match Sent should be checked for messages sent
  for t in `$TESTBIN -u $USER -h $h -p$PASS $DB -e 'show tables'`
  do
    for s in `echo $t | /bin/awk '/Sent/ {print $1}'`
    do 
    $TESTBIN -u $USER -h $h -p$PASS $DB -e "SELECT CONCAT('REPLACE INTO Archives.DavesMail (fromUid,sent) VALUES (',fromUid,',\"',date,'\");') from $s where toUid=1" | /bin/awk '/^REPLACE/' >> $RUN;
    sleep 2;
    done
  done
done

$TESTBIN -u $USER -h $ARCHOST -p$PASS $ARCHDB < $RUN
echo running query on main 
$TESTBIN -u $USER -h $ARCHOST -p$PASS $ARCHDB -e "SELECT LEFT(sent,10) as date,count(1) as mailSent FROM DavesMail WHERE LEFT(sent,10)=DATE(NOW()-interval 1 day) group by LEFT(sent,10)";


echo END `date` >> $LOG

exit 0;


