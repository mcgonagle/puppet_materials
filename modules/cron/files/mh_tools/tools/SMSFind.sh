#!/bin/sh
# SMSFind.sh
# $Id: SMSFind.sh,v 1.2 2010/05/06 17:20:31 sfrattura Exp $
#
. /etc/manhunt/source.sh

echo finding information for phone number like $1
sleep 2;
$MYSQL -u $DBUSER -p$DBPASSWD -h $V4_USERSERVER -vv $MANHUNTDB -e "SELECT Users.uid,username,email,smsEmail,phonenumber FROM Users INNER JOIN MobilePrefs USING (uid) WHERE smsEmail like '$1%' or phonenumber like '$1%'\G";
