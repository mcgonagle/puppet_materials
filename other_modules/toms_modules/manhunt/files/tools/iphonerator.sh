#!/bin/bash
#
# iphonerator.sh
#
# $Id: iphonerator.sh,v 1.4 2010/10/13 19:52:00 wflynn Exp $
#
# $HeadURL: $
#
# WFlynn 10/09
#
# Stupid script for configuring app.yml files for iphone releases until we get something reasonable in place.

WGET="/usr/bin/wget --no-check-certificate -q -O-"

echo "And his momma cries..."
/bin/cp -fv app.yml.mh app.yml.staging.mh
/bin/cp -fv app.yml.mo app.yml.staging.mo
/bin/cp -fv app.yml.af app.yml.staging.af
/bin/cp -fv app.yml.xml app.yml.staging.xml
/bin/cp -fv app.yml.admin app.yml.staging.admin
for ymlfile in app.yml.staging.mh app.yml.staging.mo app.yml.staging.admin app.yml.staging.af app.yml.staging.xml; do
    if [ -f ${ymlfile} ]
    then
	dos2unix $ymlfile
	## ORDER CAN BE IMPORTANT HERE, BE CAREFUL
	sed -i 's/\=mailshard01/\=stg-mailshard01.v4/g' $ymlfile
	sed -i 's/\=mailshard02/\=stg-mailshard02.v4/g' $ymlfile
	sed -i 's/\=mailshard03b/\=stg-mailshard03.v4/g' $ymlfile
	sed -i 's/\=mailshard04b/\=stg-mailshard04.v4/g' $ymlfile
	sed -i 's/.v4b./.v4./g' $ymlfile
	sed -i 's/gps.manhunt.net/gps-staging.manhunt.net/g' $ymlfile
	sed -i 's/admindb00/mainro03/g' $ymlfile
	sed -i 's/admindb01/mainro03/g' $ymlfile
	sed -i 's/billing-backend.v4.waltham.manhunt.net/billingb-i01.waltham.manhunt.net/g' $ymlfile
	#  ....net/billing... before ...net/
	sed -i 's/billing.manhunt.net\/billing/billing-i.manhunt.net\/billing/g' $ymlfile
	sed -i 's/billing.manhunt.net/billing-i.manhunt.net/g' $ymlfile
	sed -i 's/billing.v4.manhunt.net/billingb-i01.manhunt.net/g' $ymlfile
        sed -i 's/cache07.waltham.manhunt.net:11231/cache04.v4.waltham.manhunt.net:11215/g' $ymlfile
	sed -i 's/cache01/cache04/g' $ymlfile
	sed -i 's/cache02.waltham/cache05.v4.waltham/g' $ymlfile
	sed -i 's/cache03/cache05/g' $ymlfile
	sed -i 's/cache06/cache05/g' $ymlfile
	sed -i 's/cache07.waltham/cache04.v4.waltham/g' $ymlfile
	sed -i 's/janusdb01/maindb03/g' $ymlfile
	sed -i 's/maindb00/maindb03/g' $ymlfile
	sed -i 's/mainro00/mainro03/g' $ymlfile
	sed -i 's/trackdb00/maindb03/g' $ymlfile
	sed -i 's/userplanev4/userplanev4-staging/g' $ymlfile
	sed -i 's/www.manhunt.net/www-i.manhunt.net/g' $ymlfile
        ## Smartfox/GroupChat Related Things
        sed -i 's/cache08.waltham/cache05.v4.waltham/g' $ymlfile
        sed -i 's/209.67.254.143/209.67.254.144/g' $ymlfile  
        sed -i 's/66.151.184.201/209.67.254.144/g' $ymlfile 
        sed -i 's/UA-5700973-8/UA-5700973-24/g' $ymlfile
#	sed -i 's/v4_media/v4_media_staging/g' $ymlfile
	## Point to FAUX Database
	sed -i 's/_v4/_faux/g' $ymlfile


## ADMERIS  Live to Prodtest
# 	sed -i 's/10039/10145/g' $ymlfile
# 	sed -i 's/50024/50018/g' $ymlfile
# 	sed -i 's/ec1.admeris.com/test.admeris.com/g' $ymlfile
# 	sed -i 's/pQI1otN4Hkt8Ax4m/L6GsvY6fZSU5Dj9w/g' $ymlfile
## ADMERIS -- We don't do anything with this yet.

    fi
done

if [ -f /usr/local/src/manhunt/apps/frontend/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.staging.mh /usr/local/src/manhunt/apps/frontend/config/app.yml
fi

if [ -f /usr/local/src/manhunt_mobile/apps/frontend/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.staging.mo /usr/local/src/manhunt_mobile/apps/frontend/config/app.yml
fi

if [ -f /usr/local/src/manhunt_gps/apps/assfinder/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.staging.af /usr/local/src/manhunt_gps/apps/assfinder/config/app.yml
fi

if [ -f /usr/local/src/manhunt_xmlmobile/apps/xmlmobile/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.staging.xml /usr/local/src/manhunt_xmlmobile/apps/xmlmobile/config/app.yml
fi

if [ -f /usr/local/src/manhunt/apps/admin/config/app.yml ]
then
    /bin/cp -fv /tmp/app.yml.staging.admin /usr/local/src/manhunt/apps/admin/config/app.yml
fi

if [ -L /usr/local/src/manhunt ]
then
    cd /usr/local/src/manhunt && symfony cc
fi

if [ -L /usr/local/src/manhunt_mobile ]
then
    cd /usr/local/src/manhunt_mobile && symfony cc
fi

if [ -L /usr/local/src/manhunt_xmlmobile ]
then
    cd /usr/local/src/manhunt_xmlmobile && symfony cc
fi

if [ -L /uss/local/src/manhunt_gps ]
then
    cd /usr/loca/src/manhunt_gps && symfony cc
fi

# ##  Use the cacherator
# if [ -d /usr/local/src/manhunt/apps/frontend ]
# then
# # Clear the system cache (Frontend)
#     ${WGET} https://`hostname -f`/user/apcClear/pass/w74byru4r416dfphj7jm2f || ${WGET} http://`hostname -f`/user/apcClear/pass/w74byru4r416dfphj7jm2f
# fi

# if [ -d /usr/local/src/manhunt/apps/admin ]
# then
# # Clear the system cache (Admin)
#     ${WGET} https://`hostname -f`/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f
# fi

exit;
