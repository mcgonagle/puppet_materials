#!/bin/bash
#
# rollbackerator.sh
#
# $Id: rollbackerator.sh,v 1.5 2010/09/01 01:09:25 dcote Exp $
#
# WFlynn 03/09
#
# Stupid script for rolling back v4 to a prior release
#

RELEASE=${1}
COMPONENT=${2}
RC=${3}
BOUNCELESS="TRUE"
DEPDIR=/usr/local/src
TMPDIR=/tmp
BILLINGKEY="M@nhunTvee4f0r3vEr!"
FEDIR=MHBANGV4--${RELEASE}--BUILD${RC}-FRONTEND
ASSDIR=MHBANGV4--${RELEASE}--BUILD${RC}-ASSFINDER
ADMINDIR=MHBANGV4--${RELEASE}--BUILD${RC}-ADMIN
XMLMOBDIR=MHBANGV4--${RELEASE}--BUILD${RC}-XMLMOBILE
MODIR=${FEDIR}.MOBILE
ADMINBALL=${ADMINDIR}.tgz
FEBALL=${FEDIR}.tgz
ASSBALL=${ASSDIR}.tgz
XMLMOBBALL=${XMLMOBILE}.tgz
SYMFONY="/usr/local/Zend/Core/bin/symfony"
#MANIFEST=`egrep -H mhbangv4.version=.+?${RELEASE}--BUILD${RC} MANIF* | cut -d: -f1`;
MANIFEST="manifest.properties"

#  Check for Community or Platform Edition
ZE="Platform"
if [ -f /etc/zce.rc ]
then
    ZE="Community"
    SYMFONY="/usr/local/zend/bin/symfony"
fi

SYMCONFSRC=${TMPDIR}/${ZE}_symfony.txt

apc_clear() {
    if [ "$BOUNCELESS" != "TRUE" ]
    then
	if [ -d /usr/local/src/manhunt/apps/frontend ]
	then
                # Clear the system cache (Frontend)
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
}

bounce_apache() {
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

case "${COMPONENT}" in
    FRONTEND)
	if [ -d ${DEPDIR}/${FEDIR} ]
	then
	    APPDIR=${FEDIR}
	else
	    echo "${DEPDIR}/${FEDIR} not found" && exit
	fi
	;;
    ASSFINDER)
	if [ -d ${DEPDIR}/${ASSDIR} ]
	then
	    APPDIR=${ASSDIR}
	else
	    echo "${DEPDIR}/${ASSDIR} not found" && exit
	fi
	;;
    ADMIN)
	if [ -d ${DEPDIR}/${ADMINDIR} ]
	then
	    APPDIR=${ADMINDIR}
	else
	    echo "${DEPDIR}/${ADMINDIR} not found" && exit
	fi
	;;
    XMLMOBILE)
	if [ -d ${DEPDIR}/${XMLMOBDIR} ]
	then
	    APPDIR=${XMLMOBDIR}
	else 
	    echo "${DEPDIR}/$XMLMOBDIR} not found" && exit
	fi
    *)
	echo "Unknown argument: ${COMPONENT}" && echo "Usage: $0 Major.Minor.Patch Component BUILD#" && exit
	;;
esac

echo "Checking manifests..."
if [ -f ${DEPDIR}/${APPDIR}/${MANIFEST} ]
then
    if [ "`grep $RELEASE ${DEPDIR}/${APPDIR}/${MANIFEST}`" = "" ]
    then
	echo "${DEPDIR}/${APPDIR}/${MANIFEST} is not the right version." && exit
    fi
else
    echo "${DEPDIR}/${APPDIR}/${MANIFEST} not found" && exit
fi

cd ${DEPDIR}

bounce_apache "stop"



case "${COMPONENT}" in
    FRONTEND)
	cd ${DEPDIR}
	/bin/rm -f manhunt_mobile
	ln -s ${MODIR} manhunt_mobile
	/bin/rm -f manhunt
	ln -s ${APPDIR} manhunt
	symfony_cc	
	;;
    ASSFINDER)
	cd ${DEPDIR}
	/bin/rm -f manhunt_gps
	ln -s ${APPDIR} manhunt_gps
	symfony_cc
	;;
    XMLMOBILE)
	cd ${DEPDIR}
	/bin/rm -f manhunt_xmlmobile
	ln -s ${APPDIR} manhunt_xmlmobile
	symfony_cc
	;;
    *)
	/bin/rm -f manhunt
	ln -s ${APPDIR} manhunt
	symfony_cc	
	;;

esac

bounce_apache "start"
