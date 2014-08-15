#!/bin/bash
#
# # Put the name of the file here
# shell_template.sh
#
# # Put this ID block here. RCS/CVS/SVN will populate this with metadata about the file
# $Id: shell_template.sh,v 1.2 2009/01/07 21:03:22 wflynn Exp $
#
# # Put a small description of the file here
# An empty bash script which can be used as a template for Manhunt bash jobs
#
# # Make a note of who created the file when, and note any major edits
# Created 01/09 by wflynn

# Get the Base Variables
. /etc/manhunt/source.sh

# Set Verbosity Level (can be used for applications that support the '-v*' syntax for defining verbosity levels)
VERBOSITY=-v

# Setting HOST locally allows choosing of a specific DB instance from source.sh
HOST=${MHMASTERDBHOST}

# Set NON-ZERO to run in DEBUG mode.  This is set as DEBUG=0 in source.sh, so it's only necessary here if you want to change the value.
DEBUG=0

# Run as the care user.  This way things are where they're expected and permissions are well-defined
if [ "$UID" -ne "$CARE_UID" ]
then
    echo "Must be care to run this script."
    exit $ERROR
fi

# Check Database Connection (May be omitted for scripts that do not need DB Connectivity)
if [ "`$MYSQL -u $DBUSER -h $HOST -p$DBPASSWD $MANHUNTDB -e 'show databases'`" == "" ]
then
    echo "Cannot connect to database."
    exit $ERROR
fi

# Check to make sure we can write to our logfile (CARE_LOG defaults to /home/care/$APPNAME.log)
if [ "`touch $CARE_LOG`" != "" ]
then
    echo "Cannot write to logfile."
    exit $ERROR
fi

# Note where we start the work in the log
echo "START $APPNAME `date`" >> $CARE_LOG

# Here's where the bulk of the work would go.  Redirect any outputs to the log so they can be reviewed later.
date >> $CARE_LOG
uptime >> $CARE_LOG
echo >> $CARE_LOG <<EOF
DO SOME STUFF IN AN EOF BLOCK
EOF

# Here's how the debug bit works.
if [ $DEBUG -ne 0 ]; then
    echo "$APPNAME Running in DEBUG Mode on `date`" >> $CARE_LOG
    [ "$VERBOSITY" = "" ] && echo " $APPNAME in NON Verbose Mode " >> $CARE_LOG
    [ "$VERBOSITY" = "" ] || echo " $APPNAME in Verbose Mode " >> $CARE_LOG
    [ "$VERBOSITY" = "-vv" ] && echo " $APPNAME in EXTRA Verbose Mode" >> $CARE_LOG
else
    echo "$APPNAME Running in NORMAL Mode on `date`" >> $CARE_LOG
    [ "$VERBOSITY" = "" ] && echo " $APPNAME in NON Verbose Mode " >> $CARE_LOG
    [ "$VERBOSITY" = "" ] || echo " $APPNAME in Verbose Mode " >> $CARE_LOG
    [ "$VERBOSITY" = "-vv" ] && echo " $APPNAME in EXTRA Verbose Mode" >> $CARE_LOG
fi

# Note where we've finished in the log
echo "FINISH $APPNAME `date`" >> $CARE_LOG

# Put a newline in the log to space before the next run.
echo >> $CARE_LOG

# All Done
exit
