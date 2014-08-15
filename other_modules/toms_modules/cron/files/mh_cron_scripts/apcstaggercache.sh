#!/bin/bash
#
# apcstaggercache.sh
#
# $Id: apcstaggercache.sh,v 1.2 2009/09/02 22:50:37 wflynn Exp $
#
# WFlynn 09/09
#
# Stupid script for bouncing APC cache in staggered fashion, so they don't all expire at once, across the site.


HOSTLISTFILE="/home/deploy/www_hosts.txt"
HOSTCOUNT=`wc -l ${HOSTLISTFILE}  | cut -d' '  -f1`
SLEEPMINS=$((60 / ${HOSTCOUNT}))
SLEEPTIME="${SLEEPMINS}m"

for webhost in `cat ${HOSTLISTFILE}`; do 
#    echo "SLEEP $SLEEPTIME ($SLEEPMINS = 60 / $HOSTCOUNT) for HOST ${webhost} DONE"
    sleep ${SLEEPTIME} && /usr/bin/lynx -dump -accept_all_cookies  http://${webhost}/index.php/user/apcClear/pass/w74byru4r416dfphj7jm2f
done;

exit;

