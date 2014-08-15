#!/bin/bash
#
# mediadir.sh
#
# $Id: mediadir.sh,v 1.1 2009/11/16 17:11:03 wflynn Exp $
#
# Script to take a userid and generate the appropriate media directory.
#

E_NOARGS=85 # Command-line arg missing.
NFSS=("nfs06" "nfs07" "nfs06" "nfs07" "nfs04" "nfs05" "nfs01" "nfs02" "nfs01" "nfs02")

usage() {
    echo "Usage: $0 userid [ISILON|v2|v4|both]"
    echo "     : ISILON for directory on the isilon"
    echo "     : v2 for directory on a v2 server (obsolete?)"
    echo "     : v4 for directory on a v4 server"
    echo "     : both to show v2 and v4 directories"
    exit $E_NOARGS
}

if [ -z "$1" ]
then
    usage
fi

int2hex() {
    NUM=`printf "%X" $1;`
    WC=`echo $NUM| wc -m`
    MOD=`echo "$WC 2 % p"  | dc`
    if [ $MOD -eq "0" ]
    then
	echo "0$NUM"
    else
	echo $NUM
    fi
}

getisidir() {
    ary=`echo ${1} | sed "s/\(..\)/\ \1/g" | awk '{for (i=NF;i>=1;i--) printf $i" "} END{print ""}'`
    dir=`echo ${ary[@]} | sed "s/ /\//g"`
    echo "/ifs/data/media/images/${dir}"
}


getv4dir() {
    ary=`echo ${1} | sed "s/\(..\)/\ \1/g" | awk '{for (i=NF;i>=1;i--) printf $i" "} END{print ""}'`
    dir=`echo ${ary[@]} | sed "s/ /\//g"`
    echo "/v4_media/${dir}"
}

getv2dir() {
    ROOT=`echo $1 1000 / 10 % p | dc`
    SERVER="${NFSS[${ROOT}]}"

## This would give the right directory with exports from live NFS
##    echo "${SERVER}/${ROOT}/"`echo $1 1000 / p | dc`"/$1"

## This would give the right directory on tera-bactyl02
    echo "/var/backup/photos/${SERVER}/${ROOT}/"`echo $1 1000 / p | dc`"/$1"
}


case "${2}" in
    v2)
	V2DIR=`getv2dir "$1"`
	echo "$V2DIR"
	;;
    v4)
	V4ID=`int2hex "$1"`
	V4DIR=`getv4dir "$V4ID"`
	echo "$V4DIR"
	;;
    ISILON)
	V4ID=`int2hex "$1"`
	V4DIR=`getisidir "$V4ID"`
	echo "$V4DIR"
	;;
    both)
	V2DIR=`getv2dir "$1"`
	V4ID=`int2hex "$1"`
	V4DIR=`getv4dir "$V4ID"`
	echo -e "$V2DIR\t$V4DIR"
	;;
    *)
	usage
	;;
esac
exit





