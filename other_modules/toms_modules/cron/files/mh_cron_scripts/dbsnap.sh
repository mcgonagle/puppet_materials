#!/bin/sh
# $Id: dbsnap.sh,v 1.3 2008/07/01 02:07:37 rbraun Exp $
#
# dbsnap.sh
#
# Created 6/08 by rbraun
#   Invoke this from cron on an offline slave DB server.  This will
#   suspend the slave, record the pointers, take two snapshots (log and lib),
#   then resume the slave.  Takes 4 parameters: database user and pw,
#   snapshot storage, and number to retain

#. /etc/manhunt/source.sh

# Run as root
if [ "$UID" -ne 0 ]
then
 echo "Must be root to run this script."
  exit $ERROR
fi  

DBUSER=$1
DBPASS=$2
SNAPSIZE=$3
SNAPNUM=$4

SCRIPTS=/usr/local/manhunt/cron

mysql -u $DBUSER -p$DBPASS -e "SLAVE STOP;"
sleep 1
mysql -u $DBUSER -p$DBPASS -e "SHOW MASTER STATUS\G SHOW SLAVE STATUS\G" > /var/lib/mysql/snap-pointers

$SCRIPTS/lvsnap.sh vollib db $SNAPSIZE $SNAPNUM

mysql -u $DBUSER -p$DBPASS -e "SLAVE START;"
