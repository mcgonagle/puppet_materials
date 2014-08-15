#!/bin/bash
#
# applymlizer.sh
#
# $Id: appymlizer.sh,v 1.3 2010/09/13 16:26:53 dcote Exp $
#
# WFlynn 06/09
#
# Stupid script for moving app.yml files into the codebase.

WGET="/usr/bin/wget --no-check-certificate -q -O-"

if [ -f /usr/local/src/manhunt/apps/frontend/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.mh /usr/local/src/manhunt/apps/frontend/config/app.yml
fi

if [ -f /usr/local/src/manhunt_mobile/apps/frontend/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.mo /usr/local/src/manhunt_mobile/apps/frontend/config/app.yml
fi

if [ -f /usr/local/src/manhunt/apps/admin/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.admin /usr/local/src/manhunt/apps/admin/config/app.yml
fi

if [ -f /usr/local/src/manhunt_gps/apps/assfinder/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.af /usr/local/src/manhunt_gps/apps/assfinder/config/app.yml
fi

if [ -f /usr/local/src/manhunt_xmlmobile/apps/xmlmobile/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.xml /usr/local/src/manhunt_xmlmobile/apps/xmlmobile/config/app.yml
fi

if [ -L /usr/local/src/manhunt ]
then
    cd /usr/local/src/manhunt && symfony cc
fi

if [ -L /usr/local/src/manhunt_mobile ]
then
    cd /usr/local/src/manhunt_mobile && symfony cc
fi

if [ -L /usr/local/src/manhunt_gps ]
then
    cd /usr/local/src/manhunt_gps && symfony cc
fi

if [ -L /usr/local/src/manhunt_xmlmobile ]
then
    cd /usr/local/src/manhunt_xmlmobile && symfony cc
fi

if [ -d /usr/local/src/manhunt/apps/frontend ]
then
# Clear the system cache (Frontend)
    ${WGET} https://`hostname -f`/user/apcClear/pass/w74byru4r416dfphj7jm2f || ${WGET} http://`hostname -f`/user/apcClear/pass/w74byru4r416dfphj7jm2f
fi

if [ -d /usr/local/src/manhunt/apps/admin ]
then
# Clear the system cache (Admin)
    ${WGET} https://`hostname -f`/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f
fi

exit;
