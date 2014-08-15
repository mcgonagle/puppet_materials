#!/bin/bash
# tablecheck.sh
#
# Creates a CSV file of table sizes for each table in each database for each host in HOSTLIST
# Old files are rolled off after RETENTION days
#
# $Id: tablecheck.sh,v 1.5 2009/06/26 18:23:21 wflynn Exp $
#
. /etc/manhunt/source.sh

HOSTLIST=(
    admindb01
    admindbrosl
    bkp-mailshard01
    bkp-mailshard02
    bkp-mailshard03
    bkp-mailshard04
    db-mailsl00-24
    db-mailsl25-49
    db01
    db02
    db04
    db05
    db06
    db06
    db07
    db152
    dbrosl2
    devdb00
    devdb01_G
    devdb01_H
    devdb01_I
    devmainro01
    dw01
    dw02
    dw03
    dw04
    dw04v2
    dwpres
    itdb01
    itdb02
    itdb03
    itdb04
    jpdb02
    jpdb03
    jpmaildb02
    jpmaildb03
    lrjanusdb01
    lrmaildb01
    lrmaildb01_B
    lrmaindb00
    lrmainro01
    lrmainro01_B
    lrpresdb01
    lrtrackdb01
    maildb01
    maildb01db152
    maildb02
    maildb02a
    maildb02db152
    maildb03
    maildb03db152
    maildb04
    mailshard01
    mailshard02
    mailshard03
    mailshard04
    maindb00
    maindb03
    mainro01
    mainro02
    mainro03
    mainro04
    mainro05
    migrate
    mysqlentmon
    presdb00
    qadb01a
    qadb03b
    qadbjanus
    qadbmail01
    qadbmail02
    qadbmail04
    qadbmain
    qadbpresence
    qadbtrack
    sandbox
    stg-mailshard01
    stg-mailshard02
    stg-mailshard03
    stg-mailshard04
    sys628test
    trackdb00
    trackdb01
    trackdb02
    userplane01
    userplane01-up
    userplane02
    userplane02-up
    userplanetest01
    userplanetest02
    v2spare
    v2spare2
    wsdevdb
    wsdevdb-old
    )

USER=${DBUSER}
PASSWD=${DBPASSWD}
RETENTION=30
DBTIMEOUT=5

TIMESTAMP=`date -u +"%Y%m%d_%H%MUTC"`
DELSTAMP=`date -u +"%Y%m%d" -d"$RETENTION days ago"`
ORDER='sort -rnt, -k6'
SQLCLEAN="--connect_timeout=$DBTIMEOUT --batch --skip-column-names"
LOGDIR=${CARE_LOGDIR}/${APPNAME}
LOGBASE="${LOGDIR}/${APPNAME}_${TIMESTAMP}"
DELBASE="${LOGDIR}/${APPNAME}_${DELSTAMP}"
LOGTMP="${LOGBASE}.temp"
LOGOUT="${LOGBASE}.csv"

rm -f "${LOGBASE}.*"
rm -f "${DELBASE}*"
[ -e $LOGDIR ] || mkdir $LOGDIR

for MYHOST in ${HOSTLIST[*]}
do
    if host $MYHOST &> /dev/null;
    then
	for MYDB in `$MYSQL $SQLCLEAN -u$USER -p$PASSWD -h $MYHOST -e 'show databases' | cut -f2`
	do
	    for TABLECOUNT in `$MYSQL $SQLCLEAN -u$USER -p$PASSWD -h $MYHOST $MYDB -e 'show table status' | cut --output-delimiter=, -f1,2,5,7`
	    do
#		echo "$MYHOST,$MYDB,$TABLECOUNT" | tee -a $LOGTMP | sed -e "s/,/\t/g"
		echo "$MYHOST,$MYDB,$TABLECOUNT" >> $LOGTMP
	    done
	done
    fi
done

echo "Host,DB,Table,Engine,Rows,Size" >> $LOGOUT && $ORDER $LOGTMP >> $LOGOUT && rm -f $LOGTMP

# Omissions
#Cacti/Nagios

#Other Errors:
#Host dw01 not found: 3(NXDOMAIN)
#Host itdb01 not found: 3(NXDOMAIN)
#Host itdb02 not found: 3(NXDOMAIN)
#Access denied for apache to db06
#Access denied for apache to userplane*
#Trackdb02 (currently not in commission)
#maildb03 (currently not in commission)
