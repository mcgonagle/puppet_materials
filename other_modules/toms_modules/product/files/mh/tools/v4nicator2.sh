#!/bin/bash
#
# v4nicator2.sh
#
# $Id: v4nicator2.sh,v 1.6 2010/07/20 18:20:48 wflynn Exp $
#
# WFlynn 07/10
#
# Marginally less Stupid script for handling v4 releases until we get something reasonable in place.
#

RELEASE=${1}
COMPONENT=${2}
RC=${3}
BOUNCELESS="TRUE"
if [ "${4}" = "BOUNCE" ]
then
    BOUNCELESS="FALSE"
fi
DEPDIR=/usr/local/src
TMPDIR=/tmp
VERKEEP=2
BILLINGKEY="M@nhunTvee4f0r3vEr!"
ADMINDIR=MHBANGV4--${RELEASE}--BUILD${RC}-ADMIN
FEDIR=MHBANGV4--${RELEASE}--BUILD${RC}-FRONTEND
ASSDIR=MHBANGV4--${RELEASE}--BUILD${RC}-ASSFINDER
XMOBDIR=MHBANGV4--${RELEASE}--BUILD${RC}-XMLMOBILE
MODIR=${FEDIR}.MOBILE
ADMINBALL=${ADMINDIR}.tgz
FEBALL=${FEDIR}.tgz
ASSBALL=${ASSDIR}.tgz
XMOBBALL=${XMOBDIR}.tgz
ZE="Community"
SYMFONY="/usr/local/zend/bin/symfony"
MANIFEST=`egrep -H mhbangv4.version=.+?${RELEASE}--BUILD${RC} MANIF* | cut -d: -f1`;

if [ -e ${TMPDIR}/vindicia_unlock.sh ]
then
    echo "This is a production billing box!  vindicia_unlock will run at"
    echo "the end of the script, but a human (for now) will have to enter"
    echo "a password at the end of this script."
    sleep 5
fi

#  Check for Zend or Zendless install
ZEND="FALSE"
if [ -d /usr/local/zend/apache2 ]
then
    ZEND="TRUE"
fi

SYMCONFSRC=${TMPDIR}/${ZE}_symfony.txt

case "${COMPONENT}" in
    FRONTEND)
	if [ -f ${TMPDIR}/${FEBALL} ]
	then
	    echo "Staging ${COMPONENT} tarball into ${DEPDIR}..."
	    /bin/cp ${TMPDIR}/${FEBALL} ${DEPDIR}
	else
	    echo "${TMPDIR}/${FEBALL} not found" && exit
	fi
	APPBALL=${FEBALL}
	APPDIR=${FEDIR}
	CONFDIR="${DEPDIR}/manhunt/apps/frontend/config"
	CCAPPCACHE="${DEPDIR}/manhunt/cache/frontend/prod/config/config_app.yml.php"
	CCAPPCACHEMO="${DEPDIR}/manhunt_mobile/cache/frontend/prod/config/config_app.yml.php"
	APPYML="app.yml.mh"
	APPYMLMO="app.yml.mo"
	;;
    ADMIN)
	if [ -f ${TMPDIR}/${ADMINBALL} ]
	then
	    echo "Staging ${COMPONENT} tarball into ${DEPDIR}..."
	    /bin/cp ${TMPDIR}/${ADMINBALL} ${DEPDIR}
	else
	    echo "${TMPDIR}/${ADMINBALL} not found" && exit
	fi
	APPBALL=${ADMINBALL}
	APPDIR=${ADMINDIR}
	CONFDIR="${DEPDIR}/manhunt/apps/admin/config"
	CCAPPCACHE="${DEPDIR}/manhunt/cache/admin/prod/config/config_app.yml.php"
	APPYML="app.yml.admin"
	;;
    ASSFINDER)
        if [ -f ${TMPDIR}/${ASSBALL} ]
	then
	    echo "Staging ${COMPONENT} tarball into ${DEPDIR}..."
            /bin/cp ${TMPDIR}/${ASSBALL} ${DEPDIR}
        else
	    echo "${TMPDIR}/${ASSBALL} not found" && exit
        fi
	APPBALL=${ASSBALL}
	APPDIR=${ASSDIR}
	CONFDIR="${DEPDIR}/manhunt_gps/apps/assfinder/config"
	CCAPPCACHE="${DEPDIR}/manhunt_gps/cache/assfinder/prod/config/config_app.yml.php"
	APPYML="app.yml.af"
	;;
    XMLMOBILE)
        if [ -f ${TMPDIR}/${XMOBBALL} ]
	then
	    echo "Staging ${COMPONENT} tarball into ${DEPDIR}..."
            /bin/cp ${TMPDIR}/${XMOBBALL} ${DEPDIR}
        else
	    echo "${TMPDIR}/${XMOBBALL} not found" && exit
        fi
	APPBALL=${XMOBBALL}
	APPDIR=${XMOBDIR}
	CONFDIR="${DEPDIR}/manhunt_xmlmobile/apps/xmlmobile/config"
	CCAPPCACHE="${DEPDIR}/manhunt_xmlmobile/cache/xmlmobile/prod/config/config_app.yml.php"
	APPYML="app.yml.xl"
	;;

    *)
	echo "Unknown argument: ${COMPONENT}" && echo "Usage: $0 Major.Minor.Patch Component BUILD# [BOUNCE]" && exit
	;;
esac

## Some Sanity Checks on what we're about to do...
if [ "$ZEND" = "TRUE" ]
then
    echo "We appear to be on a zend-like system.  ZEND = ${ZEND}..."
else
    echo "We appear to be on a non-zend system.  ZEND = ${ZEND}..."
fi

if [ "$BOUNCELESS" != "TRUE" ]
then
    echo "This is a BOUNCED install.  Web Services *will be* interrupted.  BOUNCELESS = ${BOUNCELESS}..."

else
    echo "This is a BOUNCELESS install.  Web Services will *not* be interrupted.  BOUNCELESS = ${BOUNCELESS}..."
fi

if [ -f ${TMPDIR}/${MANIFEST} ]
then
    if [ "`grep $RELEASE ${TMPDIR}/${MANIFEST}`" = "" ]
    then
	echo "${TMPDIR}/${MANIFEST} is not the right version! Exiting." && exit
    else
	echo "${TMPDIR}/${MANIFEST} looks like the right version.  Proceeding..."
    fi
else
    echo "${TMPDIR}/${MANIFEST} not found" && exit
fi

if [ -f ${SYMCONFSRC} ]
then
    echo "${SYMCONFSRC} found.  Proceeding..."
else
    echo "${SYMCONFSRC} not found! Exiting." && exit
fi

if [ -f ${TMPDIR}/${APPYML} ]
then
    echo "${TMPDIR}/${APPYML} found.  Proceeding..."
else
    echo "${TMPDIR}/${APPYML} not found! Exiting." && exit
fi

if [ "$COMPONENT" = "FRONTEND" ]
then
    if [ -f ${TMPDIR}/${APPYMLMO} ]
    then
	echo "${TMPDIR}/${APPYMLMO} found.  Proceeding..."
    else
	echo "${TMPDIR}/${APPYMLMO} not found! Exiting." && exit
    fi
fi

### Set up Subs

call_cleanerator() {
    if [ -x ${TMPDIR}/cleanerator.sh ]
    then
	pushd ${TMPDIR}
	${TMPDIR}/cleanerator.sh ${RELEASE} ${VERKEEP}
	popd
    else
	echo "Cleanerator (${TMPDIR}/cleanerator.sh) not found or not executable! Skipping cleanup...."
    fi
}

vindicia_unlock() {
    pushd ${TMPDIR}
    ./vindicia_unlock.sh
    popd
}

symfony_cc() {
    echo "Bouncing symfony cache (${SYMFONY} cc)..."
    if [ -d ${DEPDIR}/manhunt ]
    then
	pushd ${DEPDIR}/manhunt && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
	if [ -f ${CCAPPCACHE} ]
	then
	    echo "${SYMFONY} cc didn't do something right: ${CCAPPCACHE} still exists.  Try running by hand!"
	fi
    fi
    if [ -d ${DEPDIR}/manhunt_mobile ]
    then
	pushd ${DEPDIR}/manhunt_mobile && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
	if [ -f ${CCAPPCACHEMO} ]
	then
	    echo "${SYMFONY} cc didn't do something right: ${CCAPPCACHEMO} still exists.  Try running by hand!"
	fi
    fi
    if [ -d ${DEPDIR}/manhunt_gps ]
    then
	pushd ${DEPDIR}/manhunt_gps && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
	if [ -f ${CCAPPCACHE} ]
	then
	    echo "${SYMFONY} cc didn't do something right: ${CCAPPCACHE} still exists.  Try running by hand!"
	fi
    fi
    if [ -d ${DEPDIR}/manhunt_xmlmobile ]
    then
	pushd ${DEPDIR}/manhunt_xmlmobile && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
	if [ -f ${CCAPPCACHE} ]
	then
	    echo "${SYMFONY} cc didn't do something right: ${CCAPPCACHE} still exists.  Try running by hand!"
	fi
    fi
}

apc_clear() {
    if [ "$BOUNCELESS" != "TRUE" ]
    then
	if [ -d ${DEPDIR}/manhunt/apps/frontend ]
	then
            # Clear the system cache (This will clear all apc for all apps on the Frontend)
	    APCCURL="http://`hostname -f`/index.php/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    echo "Clearing APC Cache: ${APCCURL}"
            /usr/bin/lynx  -dump -accept_all_cookies  ${APCCURL}
            echo "You should see 'Apc Cache Cleared' above."
	fi
	if [ -d ${DEPDIR}/manhunt/apps/admin ]
	then
            # Clear the system cache (Admin)
	    APCCURL="https://`hostname -f`/admin.php/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f"
	    echo "Clearing APC Cache: ${APCCURL}"
            /usr/bin/lynx  -dump -accept_all_cookies  ${APCCURL}
            echo "You should see 'Apc Cache Cleared' above."
	fi
    else
	echo "Bounceless install: Skipping APC Cache Clear..."
    fi
}

bounce_apache() {
    if [ "$BOUNCELESS" != "TRUE" ]
    then
	case "${1}" in
	    restart)
		case "${HOSTNAME}" in
		    billing*)
			echo "Restarting Web Services (ZEND = $ZEND)"
			echo "Secure Webserver Key is: ${BILLINGKEY}"
			;;
		    *)
			echo "Restarting Web Services (ZEND = $ZEND)"
			;;
		esac
		bounce_apache "stop"
		bounce_apache "start"
		;;
	    start)
		case "${HOSTNAME}" in
		    billing*)
			echo "Starting Web Services (ZEND = $ZEND)"
			echo "Secure Webserver Key is: ${BILLINGKEY}"
			;;
		    *)
			echo "Starting Web Services (ZEND = $ZEND)"
			;;
		esac
		if [ "$ZEND" = "TRUE" ]
		then
		    symfony_cc
		    echo "Starting Apache with zendctl..."
		    /usr/local/zend/bin/zendctl.sh start-apache
		else
		    symfony_cc
		    echo "Starting Apache with service..."
		    /sbin/service httpd start
		fi
		apc_clear
		;;
	    stop)
		echo "Stopping Web Services (ZEND = $ZEND)"
		apc_clear
		if [ "$ZEND" = "TRUE" ]
		then
		    echo "Stopping Apache with zendctl..."
		    /usr/local/zend/bin/zendctl.sh stop && sleep 15 && /usr/local/zend/bin/zendctl.sh stop
		else
		    echo "Stopping Apache with service..."
		    /sbin/service httpd stop && sleep 15 && /sbin/service httpd stop
		fi
		;;
	    *)
		echo "Usage: bounce_apache(stop|start|restart)"
		;;
	esac
    else
	echo "Bounceless install: Skipping Apache Restart..."
    fi
}

echo "Preparing ${COMPONENT}..."
cd ${DEPDIR}

if [ "$BOUNCELESS" != "TRUE" ]
then
    bounce_apache "stop"
    if [ -d ${APPDIR} ]
    then
	echo "Looks like we are re-v4nicating.  Removing stale ${APPDIR}..."
	rm -rf ${APPDIR}
    fi
    if [ "$COMPONENT" = "FRONTEND" ]
    then
	if [ -d ${MODIR} ]
	then
	    echo "Looks like we are re-v4nicating.  Removing stale ${MODIR}..."
	    rm -rf ${MODIR}
	fi
    fi
    echo "Unpacking ${APPBALL}..."
    tar zx --totals -f ${APPBALL} || (echo "Couldn't Untar ${TMPDIR}/${APPBALL}" && exit)
else
    echo "Unpacking ${APPBALL}..."
    tar zx --totals -f ${APPBALL} || (echo "Couldn't Untar ${TMPDIR}/${APPBALL}" && exit)
    bounce_apache "stop"
fi

echo "Deploying ${COMPONENT}..."
case "${COMPONENT}" in
    FRONTEND)
	echo "Updating Symlinks (main site)..."
	rm -f manhunt
	ln -s ${APPDIR} manhunt

	echo "Updating Permissions..."
	chmod -R 777 manhunt/cache manhunt/log manhunt/web/uploads

	echo "Installing app.yml and Symfony config..."
	/bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	/bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt/config/config.php

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt/manifest.properties && chmod 644 ${DEPDIR}/manhunt/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	symfony_cc

	echo "Updating Symlinks (mobile)..."
	#  Mobile site is a deep copy of frontend site with a different app.yml
	cd ${DEPDIR}
	rm -f manhunt_mobile
	/bin/cp -aT ${FEDIR} ${MODIR}
	ln -s ${MODIR} manhunt_mobile

	echo "Installing app.yml and Symfony config..."
	/bin/cp ${TMPDIR}/${APPYMLMO} ${DEPDIR}/manhunt_mobile/apps/frontend/config/app.yml
	/bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt_mobile/config/config.php

	symfony_cc
	;;
    ADMIN)
	rm -f manhunt
	ln -s ${APPDIR} manhunt

	echo "Updating Permissions..."
	chmod -R 777 manhunt/cache manhunt/log manhunt/web/uploads

	echo "Installing app.yml and Symfony config..."
	/bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	/bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt/config/config.php

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt/manifest.properties && chmod 644 ${DEPDIR}/manhunt/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	symfony_cc
	;;
    ASSFINDER)
	echo "Updating Symlinks (manhunt_gps)..."
	rm -f manhunt_gps
	ln -s ${APPDIR} manhunt_gps

	echo "Updating Permissions..."
	chmod -R 777 manhunt_gps/cache manhunt_gps/log manhunt_gps/web/uploads

	echo "Installing app.yml and Symfony config..."
	/bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	/bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt_gps/config/config.php

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt_gps/manifest.properties && chmod 644 ${DEPDIR}/manhunt_gps/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	################### FIX THIS ASAFP THEN REMOVE IT
	if [ -f ${DEPDIR}/manhunt_gps/web/iphone.php ]
	then
	    echo "Hacking up iphone.php index.php thing (ouch)..."
	    pushd ${DEPDIR}/manhunt_gps/web && /bin/ln -sf iphone.php index.php && popd
	fi
	################### ^^^ #

	symfony_cc
	;;
    XMLMOBILE)
	echo "Updating Symlinks (xmlmobile)..."
	rm -f xmlmobile
	ln -s ${APPDIR} xmlmobile

	echo "Updating Permissions..."
	chmod -R 777 xmlmobile/cache xmlmobile/log xmlmobile/web/uploads

	echo "Installing app.yml and Symfony config..."
	/bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	/bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt_xmlmobile/config/config.php

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt_xmlmobile/manifest.properties && chmod 644 ${DEPDIR}/manhunt_xmlmobile/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	symfony_cc
	;;
esac

if [ -e ${TMPDIR}/vindicia_unlock.sh ]
then
    vindicia_unlock
fi

bounce_apache "start"

echo "${COMPONENT} Deployment complete..."

call_cleanerator

exit;


