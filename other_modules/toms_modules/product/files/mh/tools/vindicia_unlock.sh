#!/bin/bash
# 
# Script to unlock vindicia's secret key file
#
# $Id: vindicia_unlock.sh,v 1.2 2010/10/13 13:00:43 wflynn Exp $
# $HeadURL: svn+ssh://repo02.cambridge.manhunt.net/SysEng/trunk/SystemsToolsV1/vindicia_unlock.sh $
#
# This file is encrypted, it was encrypted thus:
# openssl aes-256-cbc -a -salt -in Const.php -out Const.php.enc
# It can be decrypted thus (password required):
# openssl aes-256-cbc -d -a -in Const.php.enc -out Const.php
#

YOG="\\033[0;1m\\033[m\\033[1;33;42m\\c"
YOR="\\033[0;1m\\033[m\\033[1;33;41m\\c"
NYOR="\\033[1m\\033[m\\n"
ETXTFILE=/tmp/Const.php.enc
DTXTFILE=/usr/local/src/manhunt/lib/net/manhunt/billing/vindicia/Const.php

RV=0

echo -e "\n\nTHIS WILL UNLOCK VINDICIA PRODUCTION, MAKING BILLING LIVE\n"
echo -e "<ENTER> AT '...password:' PROMPT BELOW TO CANCEL\n\n"

#  The unlock command
openssl aes-256-cbc -d -a -in ${ETXTFILE} -out ${DTXTFILE}

if ! egrep -q ".*?VIN_SOAP_PROD_PASSWORD.*?QMZZK.*"  ${DTXTFILE}
then
    echo -e ${YOR}
    echo -e "WARNING\n\\c"
    if egrep -q ".*?VIN_SOAP_PROD_PASSWORD.*?Your.*Prod.*"  ${DTXTFILE}
    then
	echo -e "YOU RAN VINDICIA_UNLOCK\n\\c"
	echo -e "BUT VINDICIA IS STILL SET TO PRODTEST (STAGING)!!\\c"
	echo -e ${NYOR}
	RV=1
    else
	echo -e "\n\nOH GOD!\n\n\\c"
	echo -e "YOU RAN VINDICIA_UNLOCK\n\n\\c"
	echo -e "BUT ${DTXTFILE} IS SOMEHOW WRONG!!\n\n\\c"
	echo -e "WHAT HAVE YOU DONE???\n\n\\c"
	echo -e "FIX IT!!\n\\c"
	echo -e "FIX IT NOW!!\n\n\\c"
	echo -e "\nTry re-running $0\n\\c"
	echo -e ${NYOR}
	RV=1
    fi
else
    echo -e ${YOG}
    echo -e "\nVINDICIA PRODUCTION HAS BEEN UNLOCKED.\n\nVINDICIA IS LIVE\n\\c"
    echo -e ${NYOR}
fi

exit $RV
