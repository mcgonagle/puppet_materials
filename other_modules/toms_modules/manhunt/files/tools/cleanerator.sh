#!/bin/bash
#
# cleanerator.sh
#
# $Id: cleanerator.sh,v 1.3 2010/07/20 14:38:14 wflynn Exp $
#
# WFlynn 07/10
#
# Stupid script for deleting stale v4 releases until we get something reasonable in place.
#
#

RELEASE=`echo ${1} | grep "[[:digit:]]\{1,2\}\.[[:digit:]]\{1,2\}\.[[:digit:]]\{3,\}"`
VERKEEP=`echo ${2}| grep [[:digit:]]`

DEPDIR=/usr/local/src

depdir_cleanup() {
    MAJOR=`echo ${RELEASE} | cut -d\. -f1`
    MINOR=`echo ${RELEASE} | cut -d\. -f2`
    PATCH=`echo ${RELEASE} | cut -d\. -f3`
    SKIP=$((${PATCH} - ${VERKEEP}))
    echo "Cleaning up all but last ${VERKEEP} versions: (${MAJOR}.${MINOR}.${SKIP} and earlier)..."
    pushd ${DEPDIR}
    for file in `ls -d MHB*${MAJOR}.${MINOR}.*`;
    do
    	VER=`echo $file | cut -d\. -f3 | cut -d\- -f1 | grep [[:digit:]]`
    	if [ ! -z ${VER} ] && [ $VER -le $SKIP ]
    	then
    	    rm -rf $file
    	fi
    done
    popd
    echo "Cleanup Done..."
}

if [ -z ${RELEASE} ] || [ -z ${VERKEEP} ]
then 
    echo "Usage: $0 Major.Minor.Patch <# versions prior to ARGV[0] to start deleting from>" && exit
else
    depdir_cleanup && exit
fi


