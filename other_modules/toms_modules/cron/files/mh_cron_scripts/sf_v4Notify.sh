#!/bin/sh
# Email Notifier, Sandro Frattura Feb 2009
PID=${$}

. /etc/manhunt/source.sh
PASS=${V4_PW}
USER=${V4_USER}
USERHOST=${V4_ROSLAVE}
USERDB=${V4_USERDB}
MAILSERVER=${V4_MAILSERVER}
MAILDB=${V4_MAILDB}
LOG=${CARE_LOG}_users_$4
ERROR=1
VERBOSITY=-vv
CHAROPT="--default-character-set=utf8"
QDIR="/var/tmp/email_queue"

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

if [ -z "$1" -o -z "$2" -o -z "$3" ]
then
    echo
    echo "Need Four Parameters!!"
    echo "    1-daily or weekly"
    echo "    2-#of users per language(for testing this script)           -- pass in \"0\" to run ALL users"
    echo "    3-emailAddress for testing (all emails go to this address)  -- pass in \"REAL\" to send the real email address"
    echo "    4-last digit of UserID to notify <a.k.a. mod(10)>"
    echo
    exit 1
fi

PIDFILE="$TEMP/v4Notify.${1}.${4}.pid"

if [ `cat ${PIDFILE}` ] && [ -d /proc/`cat ${PIDFILE}` ]
then
    echo `date` "$0 $1 appears to be running already. Not starting." >> $LOG
else
    echo ${PID} > ${PIDFILE}

    echo START $APPNAME `date` >> $LOG

    mkdir -p ${QDIR}

# get my email-builder variables from the DB

for language in de en es fr it pt; do
# get my email-builder variables from the DB

	email_templ=`mysql $CHAROPT -u $USER -p$PASS -h $MAILSERVER $MAILDB -s -e "select concat(Salutation, '|', SingIntro, '|', PlurIntro, '|', SingIntroFinish, '|', PlurIntroFinish, '|', WindDown, '|', webURL, '|',Signoff, '|', SignoffName, '|', SingSubject, '|', PlurSubject, '|', canSpam1, '|', canSpam2, '|', canSpam3, '|', FromLabel, '|', SubjectLabel, '|', ReceivedLabel, '|', MoreMsgsIntro, '|', MoreMsgsFinish) from emailTemplate where lang = '$language'"`

	mailSalutation=`cut -d"|" -f1 <<< $email_templ`
	mailSingIntro=`cut -d"|" -f2 <<< $email_templ`
	mailPlurIntro=`cut -d"|" -f3 <<< $email_templ`
	mailSingFinish=`cut -d"|" -f4 <<< $email_templ`
	mailPlurFinish=`cut -d"|" -f5 <<< $email_templ`
	mailWindDown=`cut -d"|" -f6 <<< $email_templ`
	mailURL=`cut -d"|" -f7 <<< $email_templ`
	mailSignoff=`cut -d"|" -f8 <<< $email_templ`
	mailSignoffName=`cut -d"|" -f9 <<< $email_templ`
	mailSingSubject=`cut -d"|" -f10 <<< $email_templ`
	mailPlurSubject=`cut -d"|" -f11 <<< $email_templ`
	mailCanSpam1=`cut -d"|" -f12 <<< $email_templ`
	mailCanSpam2=`cut -d"|" -f13 <<< $email_templ`
	mailCanSpam3=`cut -d"|" -f14 <<< $email_templ`
	mailFromLabel=`cut -d"|" -f15 <<< $email_templ`
	mailSubjectLabel=`cut -d"|" -f16 <<< $email_templ`
	mailReceivedLabel=`cut -d"|" -f17 <<< $email_templ`
	mailMoreMsgsIntro=`cut -d"|" -f18 <<< $email_templ`
	mailMoreMsgsFinish=`cut -d"|" -f19 <<< $email_templ`

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

	select="select concat('bkp-mailshard',shlutshard, '|',  uid,'|',  trim(email),'|', trim(username)) from user natural join as_search join mailbox_shlut on mod(uid,100) = slotNumber"
	where="where right(uid,1) = $4 and shortLocaleID='$language' and abuse = 0 and email <> '' and emailFrequency ="$type

	if [ "$2" != "0" ]
	then
	    limit=" limit $2"
	fi

	sql="$select $where $limit"

#echo $sql
	LoopCounter=0

	for row in `mysql $CHAROPT -u $USER -p$PASS -h $USERHOST $USERDB -s -e "$sql"`
	do
	    userName=`cut -d"|" -f4 <<< $row`
	    userEmail=`cut -d"|" -f3 <<< $row`
	    userID=`cut -d"|" -f2 <<< $row`
	    userMailServer=`cut -d"|" -f1 <<< $row`
#echo $userMailServer $userID $userEmail


### OLD ONE	    mailInfoString=`mysql $CHAROPT -u $USER -p$PASS -h $userMailServer $MAILDB -s -e "select distinct concat(totalMessages-readMessages, '|', umailFolderID) from mailbox_folder natural join mail_messages where uidTo = $userID and name='inbox' order by uidTo"`

mailInfoString=`mysql $CHAROPT -u $USER -p$PASS -h $userMailServer $MAILDB -s -e "select distinct concat(totalMessages-readMessages, '|', umailFolderID) from mailbox_folder where uid = $userID and name='inbox'"`


	    userUnreadCount=`cut -d"|" -f1 <<< $mailInfoString`
	    userFolderID=`cut -d"|" -f2 <<< $mailInfoString`

	    if [ "$userUnreadCount" != "0" ] && [[ -n "$userUnreadCount" ]] && [[ $"userUnreadCount" != "" ]]
	    then
		let "LoopCounter=$LoopCounter+1"

		mailRows=`mysql $CHAROPT -u $USER -p$PASS -h $userMailServer $MAILDB -s -e "select concat(usernameFrom, '|', coalesce(huge.hugeTitle, title), '|',  date_format(created, '%W, %M %D - %l:%i %p EST'), '|') as mailString from mail_messages M left join mail_message_huge AS huge ON huge.umMessageID = M.umMessageID AND huge.uidOwner = M.uidFrom AND huge.shortLocaleID = '$language' where  M.uidOwner = $userID and umailFolderID = $userFolderID and opened = 'N' order by created desc limit 5"`

#####
#  This stuff can be easily replaced with a "for" or "do" loop construct.  clean up later
		mailFrom=`cut -d"|" -f1 <<< $mailRows`
		mailSubj=`cut -d"|" -f2 <<< $mailRows`
		mailDate=`cut -d"|" -f3 <<< $mailRows`
		mailFrom2=`cut -d"|" -f4 <<< $mailRows`
		mailSubj2=`cut -d"|" -f5 <<< $mailRows`
		mailDate2=`cut -d"|" -f6 <<< $mailRows`
		mailFrom3=`cut -d"|" -f7 <<< $mailRows`
		mailSubj3=`cut -d"|" -f8 <<< $mailRows`
		mailDate3=`cut -d"|" -f9 <<< $mailRows`
		mailFrom4=`cut -d"|" -f10 <<< $mailRows`
		mailSubj4=`cut -d"|" -f11 <<< $mailRows`
		mailDate4=`cut -d"|" -f12 <<< $mailRows`
		mailFrom5=`cut -d"|" -f13 <<< $mailRows`
		mailSubj5=`cut -d"|" -f14 <<< $mailRows`
		mailDate5=`cut -d"|" -f15 <<< $mailRows`
####

		if [ "$userUnreadCount" != "1" ]
		then
		    Intro2Use="$mailPlurIntro$userUnreadCount$mailPlurFinish"
		    subject2Use="$mailPlurSubject"
		else
		    Intro2Use="$mailSingIntro$userUnreadCount$mailSingFinish"
		    subject2Use="$mailSingSubject"
		fi

		extraCount=$[userUnreadCount - 5]

		case "$userUnreadCount"
		    in
		    [0-5]) andTheresMore="";;
		    *) andTheresMore="$mailMoreMsgsIntro$extraCount $mailMoreMsgsFinish";;
		esac


		mailDetails="$mailFromLabel $mailFrom
$mailSubjectLabel $mailSubj
$mailReceivedLabel $mailDate
"

		if [ -n "$mailFrom2" ]  && [[ "$mailFrom2" != " NULL NULL" ]]
		then
		    mailDetails=${mailDetails}"
$mailFromLabel $mailFrom2
$mailSubjectLabel $mailSubj2
$mailReceivedLabel $mailDate2
"
		fi

		if [ -n "$mailFrom3" ]  && [[ "$mailFrom3" != " NULL NULL" ]]
		then
		    mailDetails=${mailDetails}"
$mailFromLabel $mailFrom3
$mailSubjectLabel $mailSubj3
$mailReceivedLabel $mailDate3
"
		fi

		if [ -n "$mailFrom4" ]  && [[ "$mailFrom4" != " NULL NULL" ]]
		then
		    mailDetails=${mailDetails}"
$mailFromLabel $mailFrom4
$mailSubjectLabel $mailSubj4
$mailReceivedLabel $mailDate4
"
		fi

		if [ -n "$mailFrom5" ]  && [[ "$mailFrom5" != " NULL NULL" ]]
		then
		    mailDetails=${mailDetails}"
$mailFromLabel $mailFrom5
$mailSubjectLabel $mailSubj5
$mailReceivedLabel $mailDate5"
		fi

		full_email="$mailSalutation $userName,

$Intro2Use

$mailDetails

$andTheresMore

$mailWindDown

$mailCanSpam1

$mailCanSpam2

$mailCanSpam3"

		if [ "$3" = "REAL" ]
		then
		    email2Use=$userEmail
		else
		    email2Use="$3"
		fi

		if [ "$VERBOSITY" = "-vvv" ]
		then
		    echo ______________________________ >> $LOG
		    echo `date` >> $LOG
		    echo >> $LOG
		    echo email sent to:  $userEmail >> $LOG
		    echo >> $LOG
		    echo $full_email >> $LOG
		    echo >> $LOG
		elif [ "$VERBOSITY" = "-vv" ]
		then
		    echo "  -- ${1} process ${PID}: Message sent to $userName ($userEmail) - $(date)" >> $LOG
		fi
		
		echo -e "$full_email" > ${QDIR}/"$userName"_email.txt

#Send the actual email
		/usr/local/manhunt/cron/treet_pusher.py -e$email2Use -f${QDIR}/"$userName"_email.txt -i$userID -l$language -u$userName -s"$subject2Use"

		let "MyModulus = $LoopCounter%1000"
		if [ "$MyModulus" = "0" ]
		then
     #now send the BCC
		    /usr/local/manhunt/cron/treet_pusher.py -ev4BCC@online-buddies.com -f${QDIR}/"$userName"_email.txt -i$userID  -l$language -u$userName -s"$subject2Use"
		fi

		rm ${QDIR}/"$userName"_email.txt

	    fi
	done
    done

    [ "$VERBOSITY" = "" ] || echo "  -- $LoopCounter Members notified" >> $LOG

    echo FINISH $APPNAME `date` >> $LOG
    echo SCRIPT ENDED ON `date` >> $LOG

fi
