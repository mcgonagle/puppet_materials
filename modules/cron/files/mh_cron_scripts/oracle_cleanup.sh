#!/bin/sh
# oracle_cleanup.sh
# by Sandro Frattura 10/8/2008
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

date >> ${LOG}

#First go in and delete any .arc files in the designated directory which are more than 7 days old and delete them
#/u01/app/oracle/flash_recovery_area/ADMANAGER6/archivelog/
# would love to show what is deleted in the log.  how best to do this?
find /u01/app/oracle/flash_recovery_area/ADMANAGER6/archivelog/ -name *.arc -mtime +7 -exec rm {} \; 

# now remove any empty directories there
# would love to maybe output whats deleted to the log.  how best to do this?
find /u01/app/oracle/flash_recovery_area/ADMANAGER6/archivelog/ -type d -exec rmdir 2>/dev/null {} \;


rman nocatalog msglog=${LOG} append <<EOF

connect target /

run{
crosscheck archivelog all;
delete noprompt expired archivelog all;
}

EOF

#note. i may want to add some automated backup scripting here in future. maybe before, or maybe after .arc cleanup (or both)

RC=$?

echo "RMAN return code=$RC" >> $LOGFILE_NAME
date >> ${LOGFILE_NAME}
