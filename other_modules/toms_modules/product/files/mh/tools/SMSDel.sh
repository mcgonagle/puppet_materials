#!/bin/sh
# SMSDel.sh
# $Id: $
#
. /etc/manhunt/source.sh

echo blanking information for phone number like $1
sleep 2;
$MYSQL -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST -vv $MANHUNTDB -e "UPDATE Users INNER JOIN MobilePrefs USING (uid) SET smsEmail='', phonenumber='' WHERE smsEmail like '$1%' or phonenumber like '$1%'\G";
