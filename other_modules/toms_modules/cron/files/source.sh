#!/bin/bash
# source.sh - Autogenerated for www31.waltham.manhunt.net by puppet
# $Id: source.sh.tpl,v 1.43 2010/09/13 18:35:18 wflynn Exp $
#
#. /etc/manhunt/source.sh
#
# Created 06/2008 by wflynn
#
# This file is a place to store variables to be used in cron scripts

# Debugging Flag - Works like this:
# if [ $DEBUG -ne 0 ]; then
## Do some stuff in DEBUG mode
# else
## Do some stuff in NORMAL mode
# fi

# Set NON-ZERO in your script to run in DEBUG mode
DEBUG=0

# Derived logname
APPNAME=`basename ${0} | cut -d\. -f1`
LOGNAME=${APPNAME}.log
PIDNAME=${APPNAME}.pid
RUNNAME=${APPNAME}.run
STATLOGNAME=${APPNAME}.status

# Primary Variables
ADMIN="bkupadmin"
ADMINPAGE="adminpager"
ARCHDB="Archives"
ARCH_PASSWD="lefelene29"
ARCH_USER="archive"
BKPPASSWD="807d854bq"
BKPUSER="bkp"
CARE_LOGDIR="/home/care"
CARE_USER="care"
CAT="/bin/cat"
CP="/bin/cp"
CRON_DIR="/usr/local/manhunt/cron"
DBA_EMAIL="dba@online-buddies.com"
DBPASSWD="LQSyM"
DBUSER="apache"
ECHO="/bin/echo"
GPG="/usr/bin/gpg"
LN="/bin/ln"
if [ -z ${LOGDIR} ]
then
    LOGDIR="/var/log"
fi
MANHUNTDB="manhunt"
MHMONITOR="monitor@manhunt.net"
MV="/bin/mv"
MYSQLLIMIT=0
PIDDIR="/var/tmp"
ROOT_PASSWD="Pdn1uL+p"
ROOT_UID=0
ROOT_USER="root"
SFTP="/usr/bin/sftp"
STAT_LOGDIR="/var/tmp"
TEMP="/tmp"
TOUCH="/bin/touch"

# Exit Codes ERROR is for legacy support, the others are the NAGIOS standard
ERROR=1
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

# Set Initial STATUS to $OK
STATUS="$OK"

# Time Variables
TODAY=`date`
NOW=`/bin/date +%Y_%m_%d_%H_%M_%S`
DOW=`date +%a`
INTERVAL_DAY=10

# Applications
CHOWN="/bin/chown"
FIND="/usr/bin/find"
MKDIR="/bin/mkdir"
MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"
MYSQLIMPORT="/usr/bin/mysqlimport"
RMDIR="/bin/rmdir"

# Derived Variables
ARCHOST=${MHMASTERDBHOST}
CARE_UID=`grep ${CARE_USER} /etc/passwd | cut -d\: -f3 | head -1`
CARE_LOG="${CARE_LOGDIR}/${LOGNAME}"
CARE_RUN="${CARE_LOGDIR}/${RUNNAME}"
if [ -z ${LOG} ]
then
    LOG="${LOGDIR}/${LOGNAME}"
fi
PIDFILE="${PIDDIR}/${PIDNAME}"
STAT_LOG="${STAT_LOGDIR}/${STATLOGNAME}"
PW=${DBPASSWD}

# Host Variables

# DW01 was decommissioned by Rich and the V4 data warehouse host is dw04 with 2 MySQL instances (dw01 aka dwo4v2, and dw04) as of March 18, 2009
DWHOSTV4="dw04.cambridge.manhunt.net"
DWHOSTSV4="${DWHOSTV4} ${DWHOST2}"

# V4 vars
V4_PW="manhunt2001"
V4_USER="manhunt"
V4_USERSERVER="maindb00"
V4_MAINBK="mainbk01"
V4_ROSLAVE="mainro00"
V4_DATAWAREHOUSE="dw03"
V4_MAILSERVER="mailshard01"
V4_USERDB="manhunt_v4"
V4_MAILDB="manhunt_mail_v4"
V4_WAREHOUSEDB="MANHAUS"
# UNIQSID
# Unique Session ID
## Provides a regularly formatted string that's unique
## for a given invocation of a script sourcing this file.
## Useful when creating temporary tables in databases, etc.
## Result will look something like: 49c9_z
UNIQSID=($RANDOM + ${$})
UNIQSID=(${UNIQSID} % 0x10000)
UNIQSID=`printf "%04x" ${UNIQSID}`
TTSFX="_z";
UNIQSID="${UNIQSID}${TTSFX}"

#for TESTHOST in $MAILDBHOSTS $MAILDBHOSTS_S; do
# host $TESTHOST
#done

## For ExactTarget
EXACT_TARGET_USER="155310"
EXACT_TARGET_DATABASE_CLIENT="migrate"


# getRulebase.sh
AUTHENTICATION="jwdo3cvp6vu4weoq"
LICENSE_ID="wort8osd"

mh_carp() {
    MYMSG=${1}
    echo "$0: ${MYMSG}" >&2
    echo "$0: ${MYMSG}" >> ${LOG}
}

# Importable subroutines for facilitating logging and monitoring
mh_init () {
# Make Sure Log Is Accessible
    case "${1}" in
	clobber)
# Clobber ${LOG}
	    if ! > ${LOG}
	    then
		echo "WARNING! $0 Cannot write (clobber) to logfile $LOG." >&2
		mh_exit $CRITICAL
	    fi
	    ;;
	*)
# Append ${LOG}
	    if ! touch ${LOG}
	    then
		echo "WARNING! $0 Cannot write (append) to logfile $LOG." >&2
		mh_exit $CRITICAL
	    fi
	    ;;
    esac

# Make Sure Status Log Is Accessible and set inital status
    if ! echo $OK > $STAT_LOG
    then
	echo "WARNING! $0 Cannot write to status logfile $STAT_LOG" >&2
	echo "WARNING! $0 Cannot write to status logfile $STAT_LOG" >> ${LOG}
	mh_exit $CRITICAL
    fi
}

mh_exit () {
    EXIT_STATUS=${1}
    if [ -z ${EXIT_STATUS} ]
    then
	echo "$0 WARNING! EXIT_STATUS Not Set" >&2
	echo "$0 WARNING! EXIT_STATUS Not Set" >> ${LOG}
	EXIT_STATUS=${WARNING}
    fi
# STAT_LOG should exist here (was mh_init called?) If it doesn't (error in mh_init?), we don't want to create it now!
    if [ -e ${STAT_LOG} ] && [ -w ${STAT_LOG} ]
    then
	if ! echo $EXIT_STATUS > $STAT_LOG
	then
	    echo "$0 WARNING! Cannot write $EXIT_STATUS to status logfile $STAT_LOG" >&2
	    echo "$0 WARNING! Cannot write $EXIT_STATUS to status logfile $STAT_LOG" >> ${LOG}
	    exit $CRITICAL
	fi
	exit $EXIT_STATUS
    else
	echo $0 "WARNING! $STAT_LOG missing or not writable by $USER! Not logging $EXIT_STATUS to status logfile $STAT_LOG" >&2
	echo $0 "WARNING! $STAT_LOG missing or not writable by $USER! Not logging $EXIT_STATUS to status logfile $STAT_LOG" >> ${LOG}
	exit $EXIT_STATUS
    fi
}

mh_capture_log () {
## Capture the $LOG (probably only useful if "clobber" is used in mh_init above)
## to an error log for later review, if there's an abnormal exit condition.
    CAPTURE_LOG="${LOG}.${NOW}.error"
    if [ $STATUS -ne $OK ]
    then
	mh_carp "STATUS = ${STATUS}: Capturing $LOG to $CAPTURE_LOG."
	if ! /bin/cp -f ${LOG} ${CAPTURE_LOG}
	then
	    mh_carp "WARNING! Cannot copy ${LOG} to ${CAPTURE_LOG}"
	    exit $CRITICAL
	fi
    fi
}

mh_user_check () {
    TEST_USER=${1}
    if [ -z ${TEST_USER} ]
    then
	echo "WARNING! No username given for mh_user_check in $0" >&2
# Don't create a logfile if we're not the right user!!
	if [ -e ${LOG} ] && [ -w ${LOG} ]
	then
	    mh_carp "WARNING! No username given for mh_user_check"
	    exit $CRITICAL
	fi
	mh_exit $CRITICAL
    fi

    if [ "$USER" != "$TEST_USER" ]
    then
	echo "WARNING! Must be $TEST_USER to run $0" >&2
# Don't create a logfile if we're not the right user!!
	if [ -e ${LOG} ] && [ -w ${LOG} ]
	then
	    echo "WARNING! Must be $TEST_USER to run $0" >> ${LOG}
	    exit $CRITICAL
	fi
	mh_exit $CRITICAL
    fi
}

mh_pid_check () {
    case "${1}" in
	clean)
	    if [ -e ${PIDFILE} ]
	    then
		FOUNDPID=`cat ${PIDFILE}`
		if [ $$ -ne $FOUNDPID ]
		then
		    mh_carp "WARNING! Found PID $FOUNDPID -ne $$ in ${PIDFILE}. Not Removing."
		else
		    if ! /bin/rm -f $PIDFILE
		    then
			mh_carp "WARNING! Cannot delete $PIDFILE"
			mh_exit $CRITICAL
		    fi
		fi
	    else
		mh_carp "WARNING! ${PIDFILE} doesn't Exist. Can't Delete it."
	    fi
	    ;;
	*)
	    if [ -r ${PIDFILE} ]
	    then
		FOUNDPID=`cat ${PIDFILE}`
		if [ $$ -ne $FOUNDPID ]
		then
		    if ! ls -d /proc/$FOUNDPID
		    then
			mh_carp "WARNING! Found stale PID $FOUNDPID in ${PIDFILE}. Resetting."
			if ! echo $$ > $PIDFILE
			then
			    mh_carp "WARNING! Cannot write to $PIDFILE"
			    mh_exit $CRITICAL
			fi
		    else
			mh_carp "WARNING! Found Active PID $FOUNDPID in ${PIDFILE}!"
			mh_exit $CRITICAL
		    fi
		else
		    mh_carp "WARNING! Found our PID $FOUNDPID in ${PIDFILE}. Check for duplicate call to mh_pid_check"
		fi
	    else
		if ! echo $$ > $PIDFILE
		then
		    mh_carp "WARNING! Cannot write to $PIDFILE"
		    mh_exit $CRITICAL
		fi
	    fi
	    ;;
    esac
}

mh_uid_check () {
    TEST_UID=${1}
    if [ -z ${TEST_UID} ]
    then
	echo "WARNING! No uid given for mh_uid_check in $0" >&2
        # Don't create a logfile if we're not the right user!!
	if [ -e ${LOG} ] && [ -w ${LOG} ]
	then
	    echo "WARNING! No uid given for mh_uid_check in $0" >> ${LOG}
	    exit $CRITICAL
	fi
	mh_exit $CRITICAL
    fi

    if [ "$UID" -ne "$TEST_UID" ]
    then
	echo "WARNING! Must have UID $TEST_UID to run $0" >&2
        # Don't create a logfile if we're not the right user!!
	if [ -e ${LOG} ] && [ -w ${LOG} ]
	then
	    echo "WARNING! Must have UID $TEST_UID to run $0" >> ${LOG}
	    exit $CRITICAL
	fi
	mh_exit $CRITICAL
    fi
}

mh_db_check () {
    TEST_USER=${1}
    TEST_PW=${2}
    TEST_HOST=${3}
    if [ -z ${TEST_USER} ] || [ -z ${TEST_PW} ] || [ -z ${TEST_HOST} ]
    then
	mh_carp "WARNING! Bad call to mh_db_check in . Required: mh_db_check <USERNAME> <PASSWORD> <HOSTNAME>"
	mh_exit $CRITICAL
    fi

    if ! /usr/bin/mysql -u${TEST_USER} -p${TEST_PW} -h${TEST_HOST} -e 'show databases' > /dev/null
    then
	mh_carp "WARNING! Cannot access DB on $TEST_HOST as $TEST_USER"
	mh_exit $CRITICAL
    fi
}
