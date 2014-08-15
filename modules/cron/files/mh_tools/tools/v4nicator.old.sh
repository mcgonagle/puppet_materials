#!/bin/bash
#
# v4nicator.sh
#
# $Id: v4nicator.sh,v 1.25 2010/07/15 19:22:43 wflynn Exp $
#
# WFlynn 03/09
#
# Stupid script for handling v4 releases until we get something reasonable in place.
#

RELEASE=${1}
COMPONENT=${2}
RC=${3}
BOUNCELESS="TRUE"
DEPDIR=/usr/local/src
TMPDIR=/tmp
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
SYMFONY="/usr/local/Zend/Core/bin/symfony"
MANIFEST=`egrep -H mhbangv4.version=.+?${RELEASE}--BUILD${RC} MANIF* | cut -d: -f1`;

if [ -e ${TMPDIR}/vindicia_unlock.sh ]
then
    echo "This is a production billing box!  vindicia_unlock will run at"
    echo "the end of the script, but a human (for now) will have to enter"
    echo "a password at the end of this script."
    sleep 5
fi

#  Check for Community or Platform Edition
ZE="Platform"
if [ -f /etc/zce.rc ]
then
    ZE="Community"
    SYMFONY="/usr/local/zend/bin/symfony"
fi

SYMCONFSRC=${TMPDIR}/${ZE}_symfony.txt

vindicia_unlock() {
    pushd ${TMPDIR}
    ./vindicia_unlock.sh
    popd
}

symfony_cc() {
    echo "Bouncing symfony cache (symfony cc)..."
    if [ -d /usr/local/src/manhunt ]
    then
	pushd ${DEPDIR}/manhunt && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
    fi
    if [ -d /usr/local/src/manhunt_mobile ]
    then
	pushd ${DEPDIR}/manhunt_mobile && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
    fi
    if [ -d /usr/local/src/manhunt_gps ]
    then
	pushd ${DEPDIR}/manhunt_gps && ${SYMFONY} cc && ${SYMFONY} cc && popd || (echo "symfony cc not happy" && popd && exit)
    fi
}

#####################################  REMOVE CALLS TO THESE NEXT ITERATION (AFTER 6/8/2010) #
apc_clear() {
    echo "Remove this call!: Skipping APC Cache Clear..."
}
bounce_apache() {
    echo "Remove this call!: Skipping Apache Restart..."
}

old_apc_clear() {
    if [ "$BOUNCELESS" != "TRUE" ]
    then
	if [ -d /usr/local/src/manhunt/apps/frontend ]
	then
                # Clear the system cache (This will clear all apc for all apps on the Frontend)
	    /usr/bin/lynx -localhost -dump -accept_all_cookies  http://`hostname -f`/index.php/user/apcClear/pass/w74byru4r416dfphj7jm2f
	fi
	if [ -d /usr/local/src/manhunt/apps/admin ]
	then
                # Clear the system cache (Admin)
	    /usr/bin/lynx -localhost -dump -accept_all_cookies  https://`hostname -f`/admin.php/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f
	fi
    else
	echo "Bounceless install: Skipping APC Cache Clear..."
    fi
}

old_bounce_apache() {
    if [ "$BOUNCELESS" != "TRUE" ]
    then
	case "${1}" in
	    start)
		case "${HOSTNAME}" in
		    billing*)
			echo "Starting Zend $ZE Edition"
			echo "Secure Webserver Key is: ${BILLINGKEY}"
			;;
		    *)
			echo "Starting Zend $ZE Edition"
			;;
		esac
		if [ "$ZE" = "Community" ]
		then
		    echo "Stopping Apache..."
		    /usr/local/zend/bin/zendctl.sh stop
		    echo "Bouncing symfony cache (symfony cc)..."
		    symfony_cc
		    echo "Starting Apache..."
		    /usr/local/zend/bin/zendctl.sh restart-apache
		else
		    /usr/local/Zend/Platform/bin/javamw.rc restart
		    /sbin/service httpd restart
		fi
		apc_clear
		;;
	    stop)
		echo "Stopping Zend $ZE Edition"
		if [ "$ZE" = "Community" ]
		then
		    /usr/local/zend/bin/zendctl.sh stop && sleep 15 && /usr/local/zend/bin/zendctl.sh stop
		else
		    /sbin/service httpd stop &&  sleep 15 && /sbin/service httpd stop
		    /usr/local/Zend/Platform/bin/javamw.rc stop && sleep 15 && /usr/local/Zend/Platform/bin/javamw.rc stop
		fi
		;;
	    *)
		echo "Usage: bounce_apache(stop|start)"
		;;
	esac
    else
	echo "Bounceless install: Skipping Apache Restart..."
    fi
}
#####################################  REMOVE ^^^^^^ #

case "${COMPONENT}" in
    FRONTEND)
	if [ -f ${TMPDIR}/${FEBALL} ]
	then
	    cp ${TMPDIR}/${FEBALL} ${DEPDIR}
	else
	    echo "${TMPDIR}/${FEBALL} not found" && exit
	fi
	APPBALL=${FEBALL}
	APPDIR=${FEDIR}
	CONFDIR="${DEPDIR}/manhunt/apps/frontend/config"
	APPYML="app.yml.mh"
	APPYMLMO="app.yml.mo"
	;;
    ADMIN)
	if [ -f ${TMPDIR}/${ADMINBALL} ]
	then
	    cp ${TMPDIR}/${ADMINBALL} ${DEPDIR}
	else
	    echo "${TMPDIR}/${ADMINBALL} not found" && exit
	fi
	APPBALL=${ADMINBALL}
	APPDIR=${ADMINDIR}
	CONFDIR="${DEPDIR}/manhunt/apps/admin/config"
	APPYML="app.yml.admin"
	;;
    ASSFINDER)
        if [ -f ${TMPDIR}/${ASSBALL} ]
	then
            cp ${TMPDIR}/${ASSBALL} ${DEPDIR}
        else
	    echo "${TMPDIR}/${ASSBALL} not found" && exit
        fi
	APPBALL=${ASSBALL}
	APPDIR=${ASSDIR}
	CONFDIR="${DEPDIR}/manhunt_gps/apps/assfinder/config"
	APPYML="app.yml.af"
	;;
    XMLMOBILE)
        if [ -f ${TMPDIR}/${XMOBBALL} ]
	then
            cp ${TMPDIR}/${XMOBBALL} ${DEPDIR}
        else
	    echo "${TMPDIR}/${XMOBBALL} not found" && exit
        fi
	APPBALL=${XMOBBALL}
	APPDIR=${XMOBDIR}
	CONFDIR="${DEPDIR}/manhunt_gps/apps/xmlmobile/config"
	APPYML="app.yml.xl"
	;;

    *)
	echo "Unknown argument: ${COMPONENT}" && echo "Usage: $0 Major.Minor.Patch Component BUILD#" && exit
	;;
esac

if [ -f ${TMPDIR}/${MANIFEST} ]
then
    if [ "`grep $RELEASE ${TMPDIR}/${MANIFEST}`" = "" ]
    then
	echo "${TMPDIR}/${MANIFEST} is not the right version." && exit
    fi
else
    echo "${TMPDIR}/${MANIFEST} not found" && exit
fi

echo "Deploying..."
cd ${DEPDIR}
## Could put an rm -rf ${APPDIR} here to safely void all caches, but not in a bounceless world...
tar zxvf ${APPBALL} || (echo "Couldn't Untar ${TMPDIR}/${APPBALL}" && exit)

bounce_apache "stop"

case "${COMPONENT}" in
    FRONTEND)
	echo "Updating Symlinks (main site)..."
	rm -f manhunt
	ln -s ${APPDIR} manhunt
	chmod -R 777 manhunt/cache manhunt/log manhunt/web/uploads

	if [ -f ${TMPDIR}/${APPYML} ]
	then
	    /bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	else
	    echo "${TMPDIR}/${APPYML} not found" && exit
	fi

	if [ -f ${SYMCONFSRC} ]
	then
	    /bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt/config/config.php
	else
	    echo "${SYMCONFSRC} not found" && exit
	fi

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp -v ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt/manifest.properties && chmod 644 ${DEPDIR}/manhunt/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	symfony_cc

	echo "Updating Symlinks (mobile)..."
	cd ${DEPDIR}
	rm -f manhunt_mobile
	/bin/cp -aT ${FEDIR} ${MODIR}
	ln -s ${MODIR} manhunt_mobile
	if [ -f ${TMPDIR}/${APPYMLMO} ]
	then
	    /bin/cp ${TMPDIR}/${APPYMLMO} ${DEPDIR}/manhunt_mobile/apps/frontend/config/app.yml
	else
	    echo "${TMPDIR}/app.yml.mo not found" && exit
	fi
	if [ -f ${SYMCONFSRC} ]
	then
	    /bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt_mobile/config/config.php
	else
	    echo "${SYMCONFSRC} not found" && exit
	fi
	symfony_cc
	;;
    ADMIN)
	rm -f manhunt
	ln -s ${APPDIR} manhunt
	chmod -R 777 manhunt/cache manhunt/log manhunt/web/uploads

	if [ -f ${TMPDIR}/${APPYML} ]
	then
	    /bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	else
	    echo "${TMPDIR}/${APPYML} not found" && exit
	fi

	if [ -f ${SYMCONFSRC} ]
	then
	    /bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt/config/config.php
	else
	    echo "${SYMCONFSRC} not found" && exit
	fi

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp -v ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt/manifest.properties && chmod 644 ${DEPDIR}/manhunt/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	symfony_cc
	;;
    ASSFINDER)
	echo "Updating Symlinks (manhunt_gps)..."
	rm -f manhunt_gps
	ln -s ${APPDIR} manhunt_gps
	chmod -R 777 manhunt_gps/cache manhunt_gps/log manhunt_gps/web/uploads

	if [ -f ${TMPDIR}/${APPYML} ]
	then
	    /bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	else
	    echo "${TMPDIR}/${APPYML} not found" && exit
	fi

	if [ -f ${SYMCONFSRC} ]
	then
	    /bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt_gps/config/config.php
	else
	    echo "${SYMCONFSRC} not found" && exit
	fi

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp -v ${TMPDIR}/${MANIFEST} ${DEPDIR}/manhunt_gps/manifest.properties && chmod 644 ${DEPDIR}/manhunt_gps/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

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
	chmod -R 777 xmlmobile/cache xmlmobile/log xmlmobile/web/uploads

	if [ -f ${TMPDIR}/${APPYML} ]
	then
	    /bin/cp ${TMPDIR}/${APPYML} ${CONFDIR}/app.yml
	else
	    echo "${TMPDIR}/${APPYML} not found" && exit
	fi

	if [ -f ${SYMCONFSRC} ]
	then
	    /bin/cp ${SYMCONFSRC} ${DEPDIR}/manhunt_gps/config/config.php
	else
	    echo "${SYMCONFSRC} not found" && exit
	fi

	echo "Installing manifests for ${COMPONENT}..."
	/bin/cp -v ${TMPDIR}/${MANIFEST} ${DEPDIR}/xmlmobile/manifest.properties && chmod 644 ${DEPDIR}/xmlmobile/manifest.properties && chmod 666 ${TMPDIR}/${MANIFEST}

	symfony_cc
	;;
esac

if [ -e ${TMPDIR}/vindicia_unlock.sh ]
then
    vindicia_unlock
fi

bounce_apache "start"
