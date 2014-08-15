#!/bin/bash
#
# Script for checking various parts of cron execution, logging, monitoring, etc.
#
# $Id: cron_tester.sh,v 1.3 2010/07/22 21:07:02 wflynn Exp $
#
# wflynn 7/10
#

#  Import vars from source.sh

. /etc/manhunt/source.sh

TEST_STATUS=${1}
LOG=${CARE_LOG}
STATLOG=${STAT_LOG}

if [ -z ${TEST_STATUS} ]
then
    echo "Usage: $0 <status_to_test ($OK, $WARNING, $CRITICAL, $UNKNOWN)>"
fi

mh_user_check "care"
mh_init

# Make Sure Status Log Is Accessible and set inital status
if [ "`echo $OK > $STATLOG`" != "" ]
then
    echo "Cannot write to status logfile."
    mh_exit $CRITICAL
fi

# Log Start Of Script
echo START $APPNAME `date` >> $LOG

# Log Test Status
echo "$APPNAME Testing Status $TEST_STATUS `date`" >> $LOG

# Set Test Status
echo "$TEST_STATUS" > ${STATLOG}

# Report Test Status
echo "$APPNAME Has Set Status `cat $STATLOG` `date`" >> $LOG

#mh_exit
mh_exit $TEST_STATUS

