#!/bin/bash
# $Id: spamfilter.sh,v 1.5 2010/08/17 18:22:03 rbraun Exp $

# Variables
SENDMAIL="/usr/sbin/sendmail -i"
EGREP=/bin/egrep
SPAMC=/usr/bin/spamc
QUARANTINE=/var/tmp/quarantine

# Exit codes from <sysexits.h>
EX_UNAVAILABLE=69

# Number of *'s in X-Spam-level header needed to sideline message:
# (Eg. Score of 5.5 = "*****" )
SPAMLIMIT=12

# Clean up when done or when aborting.
trap "rm -f /var/tmp/out.$$" 0 1 2 3 15

# Pipe message to spamc
cat | $SPAMC -u spamfilter | sed 's/^\.$/../' > /var/tmp/out.$$

# Are there more than $SPAMLIMIT stars in X-Spam-Level header? :
if $EGREP -q "^X-Spam-Level: \*{$SPAMLIMIT,}" < /var/tmp/out.$$
then
  QDIR=$QUARANTINE/`date +%Y%m%d`
  [ -d $QDIR ] || mkdir $QDIR

  # (Temp) Move high scoring messages to quarantine dir so
  # a human can look at them later:
  mv /var/tmp/out.$$ $QDIR/`date +%m-%d_%R`-$$

  # (Once we are done debugging): Delete the message
  # rm -f /var/tmp/out.$$
else
  $SENDMAIL "$@" < /var/tmp/out.$$
fi

# Postfix returns the exit status of the Postfix sendmail command.
exit $?
