#!rbin/sh
# NetLoginHistory_Daily_Ct.sh
# $Id: NetLoginHistory_Daily_Ct.sh,v 1.10 2009/03/20 18:52:49 hschmidt Exp $
#
. /etc/manhunt/source.sh

PASS=${DBPASSWD}
USER=${DBUSER}
DB=${MANHUNTDB}
HOST=${DWHOSTV4}
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



DW01_NLH_ct=$(/usr/bin/mysql -u $DBUSER -h $HOST -p$DBPASSWD $DB  -sN -e "SELECT COUNT(*) FROM LoginHistory WHERE
login > NOW()-interval 1 day");

DW01_NLH_TOTALct=$(/usr/bin/mysql -u $DBUSER -h $HOST -p$DBPASSWD $DB  -sN -e "SELECT COUNT(*) FROM NetLoginHistory");


###  implement later ### DW01_NLH_YYYY_MM_ct=$(/usr/bin/mysql -u $USER -h $DW01_HOST -p$PASS $DB  -sN -e "call get_yesterday_YYYY_MMLoginHistory_count()");

echo "The DW01 NetLoginHistory table count for previous day is $DW01_NLH_ct" | /bin/mail -s "NLH COUNT" sfrattura@online-buddies.com,dba@online-buddies.com,jcurran@online-buddies.com

echo "The DW01 NetLoginHistory **TOTAL** table count is $DW01_NLH_TOTALct" | /bin/mail -s "NLH TOTAL COUNT" sfrattura@online-buddies.com


echo FINISH $APPNAME `date` >> $LOG
echo >> $LOG

exit 0;
