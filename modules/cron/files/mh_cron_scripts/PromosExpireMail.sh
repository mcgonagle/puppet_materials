#!/bin/sh

PID=${$}

# V4_DATAWAREHOUSE is presently dw03
# V4_WAREHOUSEDB is MANHAUS

. /etc/manhunt/source.sh

PASS=${V4_PW}
USER=${V4_USER}
USERHOST=${V4_DATAWAREHOUSE}
USERDB=${V4_USERDB}
DWDB=${V4_WAREHOUSEDB}
MAILSERVER=${V4_MAILSERVER}
MAILDB=${V4_MAILDB}
LOG=${CARE_LOG}_run
ERROR=1
VERBOSITY=-vv
CHAROPT="--default-character-set=utf8"
# DEBUGGING=$1
DEBUGGING=1


MSG="call routines_run_init('PromosExpireMail')"
SQL=`mysql $CHAROPT -u $USER -p$PASS -h $USERHOST $USERDB -e "$MSG"`

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
    echo "Must be care to run this script."
    exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then
    echo "Cannot write to logfile."
    exit $ERROR
fi

echo `date` [$APPNAME] START >> $LOG
if [ "$DEBUGGING" = "1"  ]
then
    echo `date` [$APPNAME] DEBUGGING MODE >> $LOG
    DEBUGMODE="(Debug mode)"
else
    DEBUGMODE=" "
fi

PIDFILE="$TEMP/PromosExpireMail.pid"

touch $PIDFILE

if [ `cat ${PIDFILE}` ] && [ -d /proc/`cat ${PIDFILE}` ]
then
    echo `date` "$0 $1 appears to be running already. Not starting." >> $LOG
else
    echo ${PID} > ${PIDFILE}

    COUNTED=0
    
    for arrMailList in `mysql $CHAROPT -u $USER -p$PASS -h $USERHOST $DWDB -s -e "select concat(uid,'|','mailshard0', mod(uid, 4) + 1,  if(mod(uid, 4) + 1=2,'', 'b'),'|','abc-123') ExpiringPromosDaily from ExpiringPromosDaily where reportDate = CURRENT_DATE;"`    

    do
        OWNERID=`cut -d"|" -f1 <<< $arrMailList`
        MAILSHARD=`cut -d"|" -f2 <<< $arrMailList`
        MESSAGEID=`cut -d"|" -f3 <<< $arrMailList`

        # echo $UID $MAILSHARD $MESSAGEID

        MSG="insert ignore mail_messages select $OWNERID, '$MESSAGEID', NULL, 1, $OWNERID, NULL, umailFolderID, now(), 'N', 'N', 'N', NULL, NULL, NULL, 'N', NULL, 'MANHUNTServiceMan' from mailbox_folder where uid = $OWNERID and name = 'Inbox'";

        # echo $MSG

        # MAILSEND=`mysql $CHAROPT -u $USER -p$PASS -h $MAILSHARD $MAILDB -s -e "$MSG"`

        if [ "$DEBUGGING" = "1"  ]
        then
             echo mysql $CHAROPT -u $USER -p$PASS -h $MAILSHARD $MAILDB -e '"'$MSG'"'
        else
             MAILSEND=`mysql $CHAROPT -u $USER -p$PASS -h $MAILSHARD $MAILDB -e "$MSG"`
        fi

        COUNTED=$(($COUNTED+1))

        echo `date` [$APPNAME] $arrMailList >> $LOG
    done

    if [ "$DEBUGGING" = "1"  ]
        then
            echo call write_promos_expire_mail_log"("CURRENT_DATE,0,0,0,0,$COUNTED,0")"
        else
            MSG="call write_promos_expire_mail_log(CURRENT_DATE,0,0,0,0,$COUNTED,0)"
            SQL=`mysql $CHAROPT -u $USER -p$PASS -h $USERHOST $USERDB -e "$MSG"`
    fi

    echo `date` [$APPNAME] Completed with $COUNTED rows sent.  >> $LOG
fi

rm -f ${PIDFILE}

MSG="call routines_run_end('PromosExpireMail', '$COUNTED messages sent. $DEBUGMODE ')"
SQL=`mysql $CHAROPT -u $USER -p$PASS -h $USERHOST $USERDB -e "$MSG"`


exit

