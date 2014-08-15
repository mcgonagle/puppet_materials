#!/bin/sh
#  Generated for <%= fqdn %>
#  $Id: getRulebase.sh,v 1.2 2010/06/21 17:22:25 apradhan Exp $
# Script to download a rulebase for SNFServer.
#
# Copyright (C) 2008 by MicroNeil Corporation. All rights reserved.
## See www.armresearch.com for the copyright terms.
#

#
# Replace authenticationxx and licensid with your license info.
#

. /etc/manhunt/source.sh
SNIFFER_PATH=/usr/share/snf-server
SNF2CHECK=/usr/sbin/SNF2Check
# AUTHENTICATION=<%= authentication %>
# LICENSE_ID=<%= licenseid %>

#
# Do not modify anything below this line.
#

cd $SNIFFER_PATH

if [ -e UpdateReady.txt ] && [ ! -e UpdateReady.lck ]; then

#       Uncomment the following line if more than one process might 
#       launch this script. Leave it commented out if this script will
#       normally be run by the <update-script/> mechanism in SNFServer.
#	touch UpdateReady.lck

	curl http://www.sortmonster.net/Sniffer/Updates/$LICENSE_ID.snf --output $LICENSE_ID.new --compressed --user sniffer:ki11sp8m --remote-time --fail

        $SNF2CHECK $LICENSE_ID.new $AUTHENTICATION 
 	RETVAL=$?
        if [ $RETVAL -eq 0 ]; then 

                if [ -e $LICENSE_ID.old ]; then rm -f $LICENSE_ID.old; fi
                if [ -e $LICENSE_ID.snf ]; then mv $LICENSE_ID.snf $LICENSE_ID.old; fi
                mv $LICENSE_ID.new $LICENSE_ID.snf

		if [ -e UpdateReady.txt ]; then rm -f UpdateReady.txt; fi
		if [ -e UpdateReady.lck ]; then rm -f UpdateReady.lck; fi

	else

		if [ -e $LICENSE_ID.new ]; then rm -f $LICENSE_ID.new; fi
		if [ -e UpdateReady.lck ]; then rm -f UpdateReady.lck; fi

	fi
fi

