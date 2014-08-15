#!/bin/sh
# $Id: eugcleaner.sh,v 1.8 2010/10/01 16:13:06 rpeachey Exp $
# Created 8/07 by mjapher

# Base Variables

. /etc/manhunt/source.sh


LOG=$CARE_LOG
VERBOSITY=-v

ERROR=1


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

MCHOSTS=("cache07.waltham.manhunt.net:11213 cache02.waltham.manhunt.net:11213 cache03.v4.waltham.manhunt.net:11213")
#MCHOST='red-cache01.qa.manhunt.net'; #the host containing the memcache shard for entitlements
#MCPORT='11213'; #the port specifc to the entitlement shard
SQLCLEAN="--connect_timeout=60 --batch --skip-column-names"
PASSWD="manhunt2001"
USER="manhunt"
MYHOST='maindb00.v4.waltham.manhunt.net'
MYDB='manhunt_v4'

echo "START $APPNAME `date`" >> $LOG
echo "START EUGCLEANER `date`" >> $LOG


$MYSQL -u $USER -p$PASSWD -h $MYHOST $VERBOSITY $MYDB -e "call eugcleaner(1)">> $LOG

echo "FINISH EUGCLEANER `date`" >> $LOG

function flush_user_entitlements ()
{

    (
        sleep 1
        uids=$3
        for myUID in ${uids[*]} ; do
            echo "delete UserLimits:$myUID:a="
        done
        sleep 1
        echo "quit"
        ) | telnet $1 $2
}

uids=()

echo "About to flush entitlements" >> $LOG
for myUID in `$MYSQL $SQLCLEAN -u$USER -p$PASSWD -h $MYHOST $MYDB -e "select uid from eugcleaner_working"`


  do
  uids[${#uids[*]}]=$myUID
echo $myUID >> $LOG
done

for myHost in  $MCHOSTS ; do
    IFS=':'
    set -- $myHost
    flush_user_entitlements $1 $2 $uids
done
echo "Purging entitlements for ${#uids[*]} users..."
echo "All done."

echo "FINISH $APPNAME `date`" >> $LOG
