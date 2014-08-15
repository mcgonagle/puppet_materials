#!/bin/bash
#
# renewalreminder.sh
#
# $Id: renewalreminder.sh,v 1.7 2009/01/07 19:49:14 wflynn Exp $
#
# Generates email to members reminding them that their paid account just expired
#
# Created 12/08 by wflynn

# Base Variables
. /etc/manhunt/source.sh

HOST=${MHMASTERDBHOST}

VERBOSITY=-v
LOG=${CARE_LOG}

# Awk to take the output file format and make paramaterized arguments out of it
AWK_PARAM_SPLIT='{split ($0, a, "\t"); print "-e " a[1] " -i " a[2] " -u " a[3] " -l " a[4]}'

# Awk to safety guard user email addresses for debugging.  Changes foo@bar.net to foo_USERID_bar.net@picard.bucket.cambridge.manhunt.net
AWK_DEBUG_SAFE='{sub(/\@/, "_"$2"_"); sub(/\t/, "@picard.bucket.cambridge.manhunt.net\t"); print}'

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

$MYSQL -N -u $DBUSER -p$DBPASSWD -h $HOST $DB > /tmp/$APPNAME-list.$$ <<EOF
SELECT manhunt.Users.email, manhunt.Users.uid, manhunt.Users.username, manhunt.Users.lang FROM
manhunt.Users
Inner Join manhunt.Bill_Sales ON manhunt.Users.uid = manhunt.Bill_Sales.uid
WHERE
manhunt.Users.type = 'limited' AND
manhunt.Users.lang = 'en' AND
manhunt.Users.status = 'active' AND
manhunt.Bill_Sales.endDate = (NOW() - interval 1 DAY) AND
manhunt.Users.email LIKE '%@%' AND
manhunt.Users.email NOT LIKE '%,%' AND
UPPER(manhunt.Bill_Sales.typesale) = 'POS'
EOF

echo -e "monitor-${APPNAME}@manhunt.net\t000000\t${APPNAME}\ten" >> /tmp/$APPNAME-list.$$

WE_SENT=`cat /tmp/$APPNAME-list.$$ | wc -l`

if [ $DEBUG -ne 0 ]; then
    cat /tmp/$APPNAME-list.$$ | awk "${AWK_DEBUG_SAFE}" | awk "${AWK_PARAM_SPLIT}" | while read args; do
	$CRON_DIR/treet_pusher.py ${args} -t renewalreminder
    done
    [ "$VERBOSITY" = "" ] || echo "  We would have sent ${WE_SENT} emails" >> $LOG
    [ "$VERBOSITY" = "-vv" ] && echo "  Recipients:" >> $LOG && cut -f1  /tmp/$APPNAME-list.$$ >> $LOG
else
    cat /tmp/$APPNAME-list.$$ | awk "${AWK_PARAM_SPLIT}" | while read args; do
	$CRON_DIR/treet_pusher.py ${args} -t renewalreminder
    done
    [ "$VERBOSITY" = "" ] || echo "  We sent ${WE_SENT} emails" >> $LOG
    [ "$VERBOSITY" = "-vv" ] && echo "  Recipients:" >> $LOG && cut -f1  /tmp/$APPNAME-list.$$ >> $LOG
    rm -f /tmp/$APPNAME-list.$$
fi

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` :  ${WE_SENT} renewal reminders sent" >> $LOG

echo "FINISH $APPNAME `date`" >> $LOG
echo >> $LOG
exit
