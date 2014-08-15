#!/bin/sh

PASS="LQSyM"
USER="apache"
DB="manhunt"
CARE_UID=500
BIN=/usr/bin/mysql
HOST=192.168.1.184
LOG=/home/care/dailyclean.log
ERROR=1

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
 echo "Must be care to run this script."
  exit $ERROR
fi  

if [ "`$BIN -u $USER -h $HOST -p$PASS $DB -e 'show databases'`" == "" ]
then
echo "Cannot connect to database."
exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then 
echo "Cannot write to logfile."
exit $ERROR
fi


# Archive and e-mail count of PaidUsers
ONE=`$BIN -u $USER -h $HOST --password=$PASS $DB -e "SELECT COUNT(*) as PaidUsersBefore FROM Archives.PaidUsers"`
$BIN -u $USER -h $HOST --password=$PASS $DB -e "INSERT INTO Archives.PaidUsers (uid,whn,state_code,city_id,state,country,county_code,city,zip,zipCan,neighborhood) SELECT uid, CURRENT_DATE(),state_code,city_id,state,country,county_code,city,zip,zipCan,neighborhood FROM Users WHERE type='paid'"
THREE=`$BIN -u $USER -h $HOST --password=$PASS $DB -e "SELECT COUNT(*) as PaidUsersAfter FROM Archives.PaidUsers"`
echo $ONE $THREE |  /bin/mail -s "paid users dailyproddb" monitor@manhunt.net

