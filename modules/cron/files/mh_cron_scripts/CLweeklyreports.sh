#!/bin/sh
# $Id: CLweeklyreports.sh,v 1.8 2009/12/14 20:53:53 rbraun Exp $

. /etc/manhunt/source.sh

LOG=$CARE_LOG
REPDIR=/home/care/reports
PATH=/usr/local/zend/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/care/bin

# Run as care
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

TODAY=`date +%Y_%m_%d_%a`
SENDTO=nchea@online-buddies.com
ALTSEND=dharpin@online-buddies.com
SENDCC=rbraun@online-buddies.com,smaston@online-buddies.com

php /var/www/manhunt/htdocs/admin/CLnewprofsjp.php > $REPDIR/newprofsjp$TODAY.csv 
php /var/www/manhunt/htdocs/admin/CLnewadsjp.php > $REPDIR/newadsjp$TODAY.csv 
# obsolete v2 reports
# php /var/www/manhunt/htdocs/admin/CLweeklystats.php > $REPDIR/weeklystats$TODAY.csv 
#php /var/www/manhunt/htdocs/admin/CLnewprofs.php > $REPDIR/newprofs$TODAY.csv 
#php /var/www/manhunt/htdocs/admin/CLnewads.php > $REPDIR/newads$TODAY.csv 

echo "  sending mail" >> $LOG
echo "  SENDTO = $SENDTO" >> $LOG
echo "  ALTSEND = $ALTSEND" >> $LOG
echo "  SENDCC = $SENDCC" >> $LOG

/usr/bin/uuencode $REPDIR/newprofsjp$TODAY.csv newprofsjp$TODAY.csv | /bin/mail -s "JAPAN weekly new profiles" $SENDTO -c $SENDCC
/usr/bin/uuencode $REPDIR/newadsjp$TODAY.csv newadsjp$TODAY.csv | /bin/mail -s "JAPAN weekly new ads" $ALTSEND -c $SENDCC,$SENDTO
#/usr/bin/uuencode $REPDIR/weeklystats$TODAY.csv weeklystats$TODAY.csv | /bin/mail -s "weekly financials" $ALTSEND -c $SENDTO,$SENDCC
#/usr/bin/uuencode $REPDIR/newprofs$TODAY.csv newprofs$TODAY.csv | /bin/mail -s "weekly new profiles" $SENDTO -c $SENDCC
#/usr/bin/uuencode $REPDIR/newads$TODAY.csv newads$TODAY.csv | /bin/mail -s "weekly new ads" $ALTSEND -c $SENDCC,$SENDTO

echo FINISH $APPNAME `date` >> $LOG
