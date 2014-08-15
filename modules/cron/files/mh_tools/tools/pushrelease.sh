#!/bin/bash
#
# pushrelease.sh
#
# $Id: pushrelease.sh,v 1.23 2010/10/07 18:56:47 wflynn Exp $
#
# WFlynn 05/09
#
# Stupid script for handling v4 releases until we get something reasonable in place.
# This puts files where the v4nicator will want to find them
# App dot yml files are managed via puppet with the v4_dotnet_config function

EXPECTED_ARGS=2
TMPDIR=/tmp

if [ $# -ne $EXPECTED_ARGS ]
then
    SHOWBUILDS=5
    echo "Usage: `basename $0` release_number build_number "
    echo -e "Example: `basename $0` 336--BUILD20 4.0.539"
    echo -e "\t Pulls release tarballs for 'release_number' from colbert DROPZONE"
    echo -e "\t and places the appropriate tarball on each of web, admin, and billing servers."
    echo -e "\t The ${SHOWBUILDS} most recent releases:" `ssh colbert ls -t /DROPZONE | grep MH | grep tgz | cut -d\. -f3 | cut -d\- -f1 | uniq  | head -${SHOWBUILDS}`
    echo -en "\t Corresponding to builds: "
    for RELEASE in `ssh colbert ls -t /DROPZONE | grep MH | grep tgz | cut -d\. -f3 | cut -d\- -f1-3 | sort -ur -nk1  | head -${SHOWBUILDS}`;
    do
	for MANIFEST in `ssh colbert egrep mhbangv4.version=.+?${RELEASE} /DROPZONE/MANIF* | cut -d: -f1`;
	do
	    for BUILD in `ssh colbert egrep manifest.version= ${MANIFEST} | cut -d= -f2`;
	    do
		echo -n "$RELEASE -> $BUILD   "
	    done
	done
    done
    echo ""
    exit;
fi

RELEASE=${1}
BUILD=${2}

FELIST=(
    www01
    www02
    www03
    www04
    www05
    www06
    www07
    www08
    www09
    www10
    www11
    www12
    www13
    www14
    www15
    www16
    www17
    www18
    www19
    www20
    www21
    www22
    www23
    www24
    www25
    www26
    www27
    www28
    www29
    www30
    www31
    www32
    billing01
    billing02
    billing03
    billing04
    billing05
    billing06
)

ADMINLIST=(
    admin41
    admin42
)

cd ${TMPDIR}

MANIFEST=`ssh colbert egrep -H mhbangv4.version=.+?${RELEASE} /DROPZONE/MANIF*${BUILD}* | cut -d: -f1`
MANIFEST=`basename ${MANIFEST}`

echo "Fetching: Build ${BUILD} (${RELEASE})..."
scp colbert:/DROPZONE/*${RELEASE}*.tgz .
scp colbert:/DROPZONE/${MANIFEST} .

for FEHOST in ${FELIST[*]}
do
    if host ${FEHOST}.v4 &> /dev/null;
    then
	echo "${BUILD} -> ${FEHOST}" && scp *${RELEASE}-*FRONT* ${FEHOST}.v4:/tmp && scp ${MANIFEST} ${FEHOST}.v4:/tmp;
	echo "${BUILD} -> ${FEHOST}" && scp *${RELEASE}-*ASS* ${FEHOST}.v4:/tmp && scp ${MANIFEST} ${FEHOST}.v4:/tmp;
	echo "${BUILD} -> ${FEHOST}" && scp *${RELEASE}-*XML* ${FEHOST}.v4:/tmp && scp ${MANIFEST} ${FEHOST}.v4:/tmp;
    fi
done

for ADMINHOST in ${ADMINLIST[*]}
do
    if host ${ADMINHOST}.v4 &> /dev/null;
    then
	echo "${BUILD} -> ${ADMINHOST}" && scp *${RELEASE}-*ADMIN* ${ADMINHOST}.v4:/tmp && scp ${MANIFEST} ${ADMINHOST}.v4:/tmp;
    fi
done
