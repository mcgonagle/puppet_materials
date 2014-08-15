#!/bin/sh
# SMS Notifier, Sandro Frattura Feb 2009
PID=${$}
. /etc/manhunt/source.sh

PASS=${V4_PW}
USER=${V4_USER}
USERHOST=${V4_ROSLAVE}
USERDB=${V4_USERDB}
LOG=${CARE_LOG}
ERROR=1
VERBOSITY=-vv

#  Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
    echo "You Must be care to run this script."
    exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then
    echo "Cannot write to logfile."
    exit $ERROR
fi

if [ -z "$1" -o -z "$2" -o -z "$3" ]
then
    echo "Need Three Parameters!!"
    echo "    1-daily or weekly"
    echo "    2-#of users (for testing the script)                        -- pass in \"0\" to run ALL users"
    echo "    3-emailAddress for testing (all emails go to this address)  -- pass in \"REAL\" to send the real email address"
    exit 1
fi

PIDFILE="$TEMP/v4Notify_SMS.${1}.pid"

if [ `cat ${PIDFILE}` ] && [ -d /proc/`cat ${PIDFILE}` ]
then
    echo `date` "$0 $1 appears to be running already. Not starting." >> $LOG
else
    echo ${PID} > ${PIDFILE}

    echo SCRIPT STARTED ON `date` >> $LOG

# Are we sending weekly or daily notices?
    if [ "$1" = "daily" ]
    then
	type=7;
	interval="4 hour";
	titleType="Daily";
    else
	type=1;
	interval="12 hour";
	titleType="Weekly";
    fi


    select="select concat(concat('bkp-mailshard',shlutshard), '|', user.uid,  '|',  concat(smsPhone, '@', spDomain) ,'|', username)  from user natural join profiles natural join as_search natural join user_sms natural join sms_providers join mailbox_shlut on mod(user.uid,100) = slotNumber "
    where="where verified = 'Y' and abuse = 0 and smsContactFreq = "$type


    if [ "$2" = "0" ]
    then
	limit=""
    else
	limit="limit $2"
    fi

    sql="$select $where $limit"

    LoopCounter=0

    for row in `mysql -u $USER -p$PASS -h $USERHOST $USERDB -s -e "$sql"`
    do
	userName=`cut -d"|" -f4 <<< $row`
	userEmail=`cut -d"|" -f3 <<< $row`
	userID=`cut -d"|" -f2 <<< $row`
	userMailServer=`cut -d"|" -f1 <<< $row`

	mailInfoString=`mysql -u $USER -p$PASS -h $userMailServer $MAILDB -s -e "select distinct concat(totalMessages-readMessages, '|') from mailbox_folder where uid=$userID and name = 'inbox'"`


	userUnreadCount=`cut -d"|" -f1 <<< $mailInfoString`

	if [ "$userUnreadCount" != "0" ]
	then
	    let "LoopCounter=$LoopCounter+1"

	    part1=" new message"
	    part2=" on MANHUNT for "
	    part3="  Log in to www.manhunt.net to check mail/change settings, or call +1 617 424 9999"

	    case "$userUnreadCount"
		in
		[1]) pluralize="";;
		*) pluralize="s";;
	    esac

	    if [ "$3" = "REAL" ]
	    then
		email2Use=$userEmail
	    else
		email2Use="$3"
	    fi

	    full_email=$userUnreadCount$part1$pluralize$part2$userName$part3

	    if [ "$VERBOSITY" = "-vvv" ]
	    then
		echo ______________________________ >> $LOG
		echo `date` >> $LOG
		echo >> $LOG
		echo sms sent to:  $email2Use >> $LOG
		echo >> $LOG
		echo $full_email >> $LOG
		echo >> $LOG
	    elif [ "$VERBOSITY" = "-vv" ]
	    then
		echo "  -- ${1} process ${PID}: Message sent to $userName ($email2Use)" >> $LOG
	    fi
	    
	    echo -e "$full_email" > /var/tmp/email_queue/"$userName"_sms.txt

#Send the actual email
	    /usr/local/manhunt/cron/treet_pusher.py -e$email2Use -f/var/tmp/email_queue/"$userName"_sms.txt -i$userID -u$userName -s"-"

	    let "MyModulus = $LoopCounter%500"
	    if [ "$MyModulus" = "0" ]
	    then

     #now send the BCC
		/usr/local/manhunt/cron/treet_pusher.py -e6176450914@messaging.sprintpcs.com -f/var/tmp/email_queue/"$userName"_sms.txt -i$userID -u$userName -s"-"
	    fi



	    rm /var/tmp/email_queue/"$userName"_sms.txt

	fi
    done

    echo SCRIPT ENDED ON `date` >> $LOG

fi
