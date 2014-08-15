#!/bin/bash
#
$Id: http_check.sh,v 1.7 2010/07/08 11:08:16 dcote Exp $
#
#
## This scripts controls the rsync for creative. 
## It will rsync the following directory over to
## the web servers and mhads servers.

OUTFILE=/tmp/outfile
OUTFILEADS=/tmp/outfile_ads
OUTFILEDL=/tmp/outfile_dl
WWWHOSTS=/home/deploy/www_hosts.txt
ADHOSTS=/home/deploy/ad_hosts.txt
DLHOSTS=/home/deploy/dl_hosts.txt

if [ -e $WWWHOSTS ];then 
    rm $WWWHOSTS
fi

for i in $(seq 1 200);do
    WEBHOST="www`printf "%02d" $i`.v4.waltham.manhunt.net"
    if wget -T 2 -t 1 $WEBHOST -O $OUTFILE -o $OUTFILE; then
	echo $WEBHOST >> ${WWWHOSTS}
	rm $OUTFILE
    fi
done

#
# This section builds the /home/depoy/ad_hosts.txt file for Creative rsync
#

if [ -e $ADHOSTS ];then
    rm $ADHOSTS
fi

for i in $(seq 1 50);do
    ADHOST="mhads`printf "%02d" $i`.waltham.manhunt.net"
    if wget -T 2 -t 1 $ADHOST -O $OUTFILEADS -o $OUTFILEADS; then
        echo $ADHOST >> ${ADHOSTS}
        rm $OUTFILEADS
    fi
done

#
# This section build the /home/deploy/dl_hosts.txt file for Creative DLIST ad servers
#
if [ -e $DLHOSTS ];then
    rm $DLHOSTS
fi

for i in $(seq 1 25);do
    DLHOST="dlads`printf "%02d" $i`.waltham.manhunt.net"
    if wget -T 2 -t 1 $DLHOST -O $OUTFILEDL -o $OUTFILEDL; then
        echo $DLHOST >> ${DLHOSTS}
        rm $OUTFILEDL
    fi
done

