#!/bin/sh
# sessionsclean.sh
# $Id: sessionsclean.sh,v 1.11 2008/08/27 12:19:42 rbraun Exp $
#
. /etc/manhunt/source.sh

HOST=${MHMASTERDBHOST}
CURRENTTOTAL=0
VERBOSITY=-vv
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

#Changed 6-4-2008 by Sandro
#$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB $VERBOSITY -e "INSERT IGNORE INTO NetLoginHistory (uid,login,sess_id,server,status,type,IP,browser,lang,lastChange,city_id,state_code) SELECT s.uid,s.lastLogin,s.sess_id,s.server,s.status,s.type,s.IP,u.browser,s.lang,u.lastChange,s.city_id,s.state_code FROM Sessions AS s INNER JOIN Users AS u using (uid) WHERE logout=0;" >> $LOG

$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB $VERBOSITY >> $LOG <<EOF
INSERT IGNORE INTO NetLoginHistory (uid,login,sess_id,server,status,type,IP,lang,city_id,state_code) SELECT s.uid,s.lastLogin,s.sess_id,s.server,s.status,s.type,s.IP,s.lang,s.city_id,s.state_code FROM Sessions AS s WHERE logout=0;
UPDATE NetLoginHistory n INNER JOIN Sessions s ON (login=lastLogin AND s.uid=n.uid) SET n.logout=s.lastAccess, logoutReason='user' WHERE s.logout=1;
UPDATE NetLoginHistory n INNER JOIN Sessions s ON (login=lastLogin AND s.uid=n.uid) SET n.logout=s.lastAccess, logoutReason='timeout' WHERE s.logout=0 AND lastAccess < NOW() - INTERVAL 30 MINUTE;
UPDATE Sessions AS s RIGHT JOIN NetLoginHistory AS n ON (n.uid=s.uid and n.login=s.lastLogin) SET n.logout=NOW(),logoutReason='vanished' WHERE s.uid IS NULL AND n.logout IS NULL;
EOF

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` manhunt logging sessions done" >> $LOG

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` delete sessions" >> $LOG

$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB $VERBOSITY >> $LOG <<EOF
DELETE FROM $MANHUNTDB.Sessions WHERE (lastAccess < NOW() - INTERVAL 30 MINUTE) AND uid!=0;
DELETE FROM $MANHUNTDB.Sessions WHERE logout=1 AND uid!=0;
EOF

###Added 5-30-2008 as a 'user throttle', per Justin
CURRENTTOTAL=$($MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB -e "select count(*) from Sessions";)

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` Current Total $CURRENTTOTAL" >> $LOG

# from CSRSessions
# All Special profiles should have a city of Manhunt HQ
$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB -e "UPDATE Users SET status='active',type='admin',city='Manhunt HQ' WHERE uid<10";
[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` manhuntserviceman active" >> $LOG

#######
# commented out by Sandro 5-9-2008
# $MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB -e "UPDATE Users SET type='free' WHERE uid=10";
#######

$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB $VERBOSITY -e "UPDATE Users SET city='The Manhunt Movie', state='XX', neighborhood='The Manhunt Movie' WHERE uid in (383574,383580,383582,383585,402925,402930,402932,402933,402938,402940,402941);"  >> $LOG

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` man movie done" >> $LOG

$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB $VERBOSITY -e "SELECT COUNT(*) as oldCsrSessions FROM CSRSessions WHERE lastActivity < CURRENT_TIMESTAMP() - INTERVAL 20 MINUTE;"  >> $LOG

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` manhunt csr sessions count done" >> $LOG

$MYSQL -u $DBUSER -h $HOST --password=$DBPASSWD $MANHUNTDB $VERBOSITY >>$LOG <<EOF
INSERT INTO CSRLogins (csrName,Login,Logout) SELECT csrName,login,lastActivity FROM CSRSessions WHERE lastActivity < CURRENT_TIMESTAMP() - INTERVAL 20 MINUTE;
DELETE FROM CSRSessions WHERE lastActivity < CURRENT_TIMESTAMP() - INTERVAL 20 MINUTE;
EOF

[ "$VERBOSITY" = "" ] || echo "  -- `date +%H:%M:%S` manhunt csr sessions done" >> $LOG

echo "FINISH $APPNAME `date`" >> $LOG
echo >> $LOG
exit 0;
