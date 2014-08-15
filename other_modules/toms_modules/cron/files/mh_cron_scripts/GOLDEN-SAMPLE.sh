#!/bin/sh
# purgemessages.sh
# $Id: purgemessages.sh,v 1.6 2008/08/06 16:51:22 sfrattura Exp $
#
. /etc/manhunt/source.sh

HOSTS=$MAILDBHOSTS
LOG=$CARE_LOG
VERBOSITY=-vv
UIDDB=$MANHUNTDB
UIDHOST=$MHMASTERDBHOST

# Add a comment here spelling out what the command-line parameters are, and name 
# them in a readable way
PARAM1=$1
PARAM2=$2

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

# Do your logic here
# Use the VERBOSITY flag thus:
#
#   [ "$VERBOSITY" = "" ] || echo "  -- $LoopCounter Members notified" >> $LOG

echo FINISH $APPNAME `date` >> $LOG
echo >> $LOG

exit 0;


