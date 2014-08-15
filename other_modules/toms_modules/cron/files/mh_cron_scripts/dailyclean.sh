#!/bin/sh
# dailyclean.sh
# $Id: dailyclean.sh,v 1.2 2008/07/03 21:00:15 wflynn Exp $
#
. /etc/manhunt/source.sh

APASS=${ARCH_PASSWD}
AUSER=${ARCH_USER}
PASS=${DBPASSWD}
USER=${DBUSER}
DB=${MANHUNTDB}
HOST=${MHDBMASTERHOST}
LOG=${CARE_LOG}

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
  echo "Must be care to run this script."
  exit $ERROR
fi  

if [ "`$MYSQL -u $USER -h $HOST -p$PASS $DB -e 'show databases'`" == "" ]
then
 echo "Cannot connect to database: $TESTHOST."
 exit $ERROR
fi
 
if [ "`touch $LOG`" != "" ]
then 
 echo "Cannot write to logfile."
 exit $ERROR
fi

rm -f ${LOG}
TABLE="PreviewLimits"
CSVFILE="${TEMP}/${TABLE}.csv"
# Archive, zero and e-mail PreviewLimits
$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "SELECT uid,messagesSent,messagesRead,profilesViewed,NOW() FROM ${TABLE}" --skip-column-names | 's/[^tab]NULL[^tab]/ \\N /g' > ${CSVFILE}
ONE=`$MYSQL -u $USER -h $DWHOST --password=$PASS $ARCHDB -e "SELECT COUNT(*) as PreviewLimitRowBefore FROM ${TABLE}"`
$MYSQLIMPORT -v -u $AUSER -h $DWHOST --password=$APASS $ARCHDB ${CSVFILE} >> ${LOG}
TWO=`$MYSQL -u $USER -h $DWHOST --password=$PASS $ARCHDB -e "SELECT COUNT(*) as PreviewLimitRowAfter FROM ${TABLE}"`
THREE=`$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "TRUNCATE ${TABLE}" `
echo $ONE $TWO $THREE |  /bin/mail -s "preview limits dailyproddb" ${MHMONITOR}

TABLE="Bones"
CSVFILE="${TEMP}/${TABLE}.csv"
# Archive, zero and e-mail Winks
$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "SELECT * FROM ${TABLE}" --skip-column-names | 's/[^tab]NULL[^tab]/ \\N /g' > ${CSVFILE}
ONE=`$MYSQL -u $USER -h $DWHOST --password=$PASS $ARCHDB -e "SELECT COUNT(*) as ${TABLE}Before FROM ${TABLE}"`
$MYSQLIMPORT -v -u $AUSER -h $DWHOST --password=$APASS $ARCHDB ${CSVFILE} >> ${LOG}
TWO=`$MYSQL -u $USER -h $DWHOST --password=$PASS $ARCHDB -e "SELECT COUNT(*) as ${TABLE}After FROM ${TABLE}"`
THREE=`$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "TRUNCATE ${TABLE}" `
echo $ONE $TWO $THREE |  /bin/mail -s "winks dailyproddb" ${MHMONITOR}

TABLE="PaidUsers"
CSVFILE="${TEMP}/${TABLE}.csv"
# Archive and e-mail count of ${TABLE}
$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "SELECT uid, CURRENT_DATE(),state_code,city_id,state,country,county_code,city,zip,zipCan,neighborhood FROM Users WHERE type='paid'" --skip-column-names | 's/[^tab]NULL[^tab]/ \\N /g' > ${CSVFILE}
ONE=`$MYSQL -u $USER -h $DWHOST --password=$PASS $ARCHDB -e "SELECT COUNT(*) as ${TABLE}Before FROM ${TABLE}"`
$MYSQLIMPORT -v -u $AUSER -h $DWHOST --password=$APASS $ARCHDB ${CSVFILE} >> ${LOG}
THREE=`$MYSQL -u $USER -h $DWHOST --password=$PASS $ARCHDB -e "SELECT COUNT(*) as ${TABLE}After FROM ${TABLE}"`
echo $ONE $THREE |  /bin/mail -s "paid users dailyproddb" ${MHMONITOR}

TABLE="TypeStatus"
CSVFILE="${TEMP}/${TABLE}.csv"
# Archive and e-mail all status * type.
$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "SELECT COUNT(*),type,status,current_date(),state_code FROM Users group by type,status,state_code"  --skip-column-names | 's/[^tab]NULL[^tab]/ \\N /g' > ${CSVFILE}
$MYSQLIMPORT -v -u $AUSER -h $DWHOST --password=$APASS $ARCHDB ${CSVFILE} >> ${LOG}
ONE=`$MYSQL -u $USER -h $HOST --password=$PASS $DB -e "SELECT COUNT(*),type,status,current_date(),state_code FROM Users group by status,type,state_code with rollup"`
echo $ONE |  /bin/mail -s "all statuses dailyproddb" ${MHMONITOR}

TABLE="HighScores"
CSVFILE="${TEMP}/${TABLE}.csv"
# update ${TABLE}
# UPDATE HIGHSCORE BY HIGHTODAY IF TODAY'S SCORE IS A RECORD SCORE
ONE=`$MYSQL -u $USER -h $HOST --password=$PASS $DB -vv -e "SELECT * from ${TABLE} ORDER BY state_code"`;
TWO=`$MYSQL -u $USER -h $HOST --password=$PASS $DB -vv -e "UPDATE ${TABLE} SET highScore=highToday, currentDay=now() WHERE highToday > highScore"`;

# SET TODAY'S SCORE TO YESTERDAY'S SCORE AND INITIAL TODAY'S SCORE
THREE=`$MYSQL -u $USER -h $HOST --password=$PASS $DB -vv -e "UPDATE ${TABLE} SET highYesterday=highToday, highToday=0"`;

# SHOW ME THE SCORES
echo $ONE $TWO $THREE |  /bin/mail -s "high scores dailyproddb" ${MHMONITOR}

