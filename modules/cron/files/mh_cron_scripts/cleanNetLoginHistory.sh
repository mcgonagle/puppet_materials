#!/bin/sh
# cleanNetLoginHistory.sh
# $Id: cleanNetLoginHistory.sh,v 1.13 2008/12/03 14:58:39 sfrattura Exp $
#

. /etc/manhunt/source.sh

LOG=$CARE_LOG
VERBOSITY="-vv"

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

mysql -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST $MANHUNTDB $VERBOSITY -e "SELECT count(*) from NetLoginHistory" >> $LOG
mysql -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST $MANHUNTDB $VERBOSITY -e "SET @week:=NOW()-INTERVAL 7 DAY; SELECT count(*) from NetLoginHistory where login>@week" >> $LOG


mysql -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST $MANHUNTDB $VERBOSITY >> $LOG <<EOF
drop table if exists NetLoginHistoryTemp;

CREATE TABLE NetLoginHistoryTemp ( login datetime NOT NULL default '0000-00-00 00:00:00',  uid int(10) unsigned NOT NULL default 0,   logout datetime default NULL,  logoutReason varchar(10) default NULL,  state_code varchar(5) NOT NULL default '' ,  PRIMARY KEY  (uid,login) )  ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO NetLoginHistoryTemp (login,uid,logout,logoutReason,state_code) SELECT login,uid,logout,logoutReason,state_code FROM NetLoginHistory WHERE logout IS NULL;


######
## re-added by Sandro 11/25/2008 to keep a "hot backup" of the NetLoginHistory table 
## this will help us deal with the times when NLH triggers stop firing inexplicably
## essentially, we make a copy of NetLoginHistory before wiping it out
drop table if exists NetLoginHistory_Old;
create table NetLoginHistory_Old like NetLoginHistory;
insert into NetLoginHistory_Old select * from NetLoginHistory;
#####

delete from NetLoginHistory;


INSERT INTO NetLoginHistory (login,uid,logout,logoutReason,state_code) SELECT login,uid,logout,logoutReason,state_code FROM NetLoginHistoryTemp;

DROP TABLE NetLoginHistoryTemp;

EOF

# rbraun 7/15/08 - the above INSERT INTO line just puts data back into
# the same place.  Shouldn't it go to the data warehouse?
#
# Also - can't this use the ARCHIVE engine instead of InnoDB?

mysql -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST $MANHUNTDB $VERBOSITY -e "SELECT count(*) from NetLoginHistory" >> $LOG
mysql -u $DBUSER -p$DBPASSWD -h $MHMASTERDBHOST $MANHUNTDB $VERBOSITY -e "SET @week:=NOW()-INTERVAL 7 DAY; SELECT count(*) from NetLoginHistory where login>@week" >> $LOG

echo FINISH $APPNAME `date` >> $LOG
echo >> $LOG

exit 0;
