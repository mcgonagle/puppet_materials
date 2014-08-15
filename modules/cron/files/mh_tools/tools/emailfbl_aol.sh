#!/bin/bash
# $Id: emailfbl_aol.sh,v 1.16 2009/09/25 16:06:43 rbraun Exp $
#
# Created 10/08 by sfrattura

. /etc/manhunt/source.sh

VERBOSITY=-vv
LOG=/var/tmp/fbl-`whoami`.log


if [ "`$MYSQL -u $V4_USER -h $V4_USERSERVER -p$V4_PW $V4_USERDB -e 'show databases'`" == "" ]
then
    echo "Cannot connect to database."
    exit $ERROR
fi

if [ "`touch $LOG 2>&1`" != "" ]
then
    echo "Cannot write to logfile."
    exit $ERROR
fi


echo "START $APPNAME `date`" >> $LOG

stringToSeek=X-MH-UID:
strFound=0
exitCode=0

while read line
do
    temp=`echo $line | awk ' { printf $1 } '`
    if [ "$temp" = "$stringToSeek" ]
    then
	FinalUID=`echo $line | awk ' { printf $2} '`
	strFound=1

	QueryResult=`$MYSQL -s --skip-column-names -u $V4_USER -h $V4_USERSERVER -p$V4_PW $V4_USERDB -e "SELECT emailFrequency FROM as_search WHERE uid='$FinalUID'"`
	if [ -z "$QueryResult" ] || ["$QueryResult" = "Never"]
        then
	    [ "$VERBOSITY" = "" ] || echo "-- Notifications already disabled for $FinalUID" >> $LOG
	    echo "FINISH $APPNAME `date`" >> $LOG
	    exit 1;   ## the uid is not going to get updated: notify is not set
        else
	    $MYSQL -u $V4_USER -h $V4_USERSERVER -p$V4_PW $VERBOSITY $V4_USERDB -e \
	    "UPDATE as_search set emailFrequency = 0 where uid = '$FinalUID'" >> $LOG
	    [ "$VERBOSITY" = "" ] || echo "-- Notifications disabled for $FinalUID" >> $LOG
        fi
    fi
done

if [ "$strFound" = "0" ]
then
    echo "-- $stringToSeek header not found" >> $LOG
    exitCode=2;    ## i.e. the stringToSeek was not found
fi

#if [ "$strFound" != "0" ]
#then
#    echo "User not found or otherwise returned something weird" >> $LOG
#    exitCode=2;    ## i.e. the stringToSeek was not found
#fi

echo "FINISH $APPNAME `date`" >> $LOG
echo >> $LOG
exit $exitCode;

