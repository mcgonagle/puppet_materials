#!/bin/sh
# written by Sandro Frattura
#
# $Id: ImportExchangeRates.sh,v 1.7 2010/07/26 14:02:24 wflynn Exp $
#
# This file imports a text file of exchange rates into a mySql table
# called "fact_exchange" on MANHAUS in the dw03 database
#

. /etc/manhunt/source.sh
PASS=${V4_PW}
USERHOST=${V4_DATAWAREHOUSE}
USERDB=${V4_WAREHOUSEDB}
LOG=${CARE_LOG}
VERBOSITY=-vv
CHAROPT="--default-character-set=utf8"

mh_user_check "care"
mh_init

# Log Start Of Script
echo START $APPNAME `date` >> $LOG

# Create Y/M/D cariables
year=`date +%Y`
month=`date +%m`
day=`date +%d`

# Create Filename to look for & import
myFilename="/var/tmp/xe.rates.$year-$month-$day"

# is the expected file present???
if [ ! -e $myFilename ]; then
    echo "$myFilename  does not exist!" | /usr/local/manhunt/cron/mailif -t sfrattura@online-buddies.com  "exchange rate script failure"
    echo "$myFilename  does not exist!" >> $LOG
    mh_exit $CRITICAL
fi

# Is the expected file zero bytes???
if [ ! -s $myFilename ]; then
    echo "$myFilename is zero bytes!" | /usr/local/manhunt/cron/mailif -t sfrattura@online-buddies.com  "exchange rate script failure"
    echo "$myFilename is zero bytes!"  >> $LOG
    mh_exit $CRITICAL
fi

#Build the SQL stmt
sqlStmt="load data LOCAL infile '$myFilename' into table fact_ExchangeRate FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\'' (@tmpdt,currencyTypeID,exchangeRateToUSD) set dt=STR_TO_DATE(@tmpdt, '%Y-%m-%d')"

#execute the SQL Statement
`mysql $CHAROPT -u $V4_USER -p$PASS -h $USERHOST $USERDB -s -e "$sqlStmt"`

#Get the number of rows in the Exchange Rate Tabke
RowCnt=`mysql $CHAROPT -u $V4_USER -p$PASS -h $USERHOST $USERDB -s -e "select count(*) from fact_ExchangeRate"`

#Send Confirmation Email
#  SYS-3112, monitoring this with NAGIOS now, the advisory success email isn't necessary
#echo "ExchangeRate script complete!" | /usr/local/manhunt/cron/mailif -t sfrattura@online-buddies.com "exchange rate script complete: #Rows in table - $RowCnt"

#Log Script Completion
echo END $APPNAME `date` >> $LOG

mh_exit $OK
