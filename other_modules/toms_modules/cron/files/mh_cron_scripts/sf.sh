#!/bin/sh
# Email Notifier, Sandro Frattura Feb 2009


. /etc/manhunt/source.sh
PASS=${V4_PW}
USER=${V4_USER}
USERHOST=${V4_USERSERVER}
USERDB=${V4_USERDB}
MAILSERVER=${V4_MAILSERVER}
MAILDB=${V4_MAILDB}
LOG=${CARE_LOG}
ERROR=1
VERBOSITY=-vv



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
echo "Need Three Parameters!!"  
echo "    1-daily or weekly"
echo "    2-#of users (for testing the script)                        -- pass in \"0\" to run ALL users"
echo "    3-emailAddress for testing (all emails go to this address)  -- pass in \"REAL\" to send the real email address" 
echo
exit 1
fi


echo SCRIPT STARTED ON `date` >> $LOG

# get my email-builder variables from the DB


email_templ=`mysql -u $USER -p$PASS -h $MAILSERVER $MAILDB -s -e "select concat(Salutation, '|', SingIntro, '|', PlurIntro, '|', SingIntroFinish, '|', PlurIntroFinish, '|', WindDown, '|', webURL, '|',Signoff, '|', SignoffName, '|', SingSubject, '|', PlurSubject, '|', canSpam1, '|', canSpam2, '|', canSpam3) from emailTemplate where lang = 'en'"`

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

# note:  Interval is supposed to be used as "date since last email", to prevent a person from getting too many

select="select concat(concat('mailshard',shlutshard), '|',  uid,'|',  trim(email),'|', trim(username)) from user natural join account_settings join mailbox_shlut on mod(uid,100) = slotNumber"
where="where accSettingName='emailFrequency' and value ="$type 

if [ "$2" != "0" ] 
then
  limit=" limit $2"
fi
 
sql="$select $where $limit"

#echo $sql
LoopCounter=0

for row in `mysql -u $USER -p$PASS -h $USERHOST $USERDB -s -e "$sql"`
do
  let "LoopCounter=$LoopCounter+1" 
  userName=`cut -d"|" -f4 <<< $row`
  userEmail=`cut -d"|" -f3 <<< $row`
  userID=`cut -d"|" -f2 <<< $row`
  userMailServer=`cut -d"|" -f1 <<< $row`
#echo $userMailServer $userID $userEmail


mailInfoString=`mysql -u $USER -p$PASS -h $MAILSERVER $MAILDB -s -e "select distinct concat(totalMessages-readMessages, '|', umailFolderID) from mailbox_folder natural join mail_messages where uidTo = $userID and name='inbox' order by uidTo"`

userUnreadCount=`cut -d"|" -f1 <<< $mailInfoString`
userFolderID=`cut -d"|" -f2 <<< $mailInfoString`

if [ "$userUnreadCount" != "0" ] && [[ -n "$userUnreadCount" ]] && [[ $"userUnreadCount" != "" ]] 
 then
mailRows=`mysql -u $USER -p$PASS -h $MAILSERVER $MAILDB -s -e "select concat(uum2.username, '|', ifnull(title,' - no subject - ') , '|', date_format(created, '%W, %M %D - %l:%i %p EST'), '|') as mailString from mailbox_folder natural join mail_messages M join uid_username_mapper U on M.uidTo = U.uid join uid_username_mapper uum2 on M.uidFrom=uum2.uid where uidTo = $userID and name='inbox' and opened = 'N' order by created desc limit 5"`

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
6) andTheresMore="(plus 1 more message - log in to view them all)";;
*) andTheresMore="(plus $extraCount more messages - log in to view them all)";;
esac



mailDetails="From: $mailFrom
Subject: $mailSubj
Received: $mailDate
"

if [ -n "$mailFrom2" ]  && [[ "$mailFrom2" != " NULL NULL" ]]
then
mailDetails=${mailDetails}"
From: $mailFrom2
Subject: $mailSubj2
Received: $mailDate2
"
fi

if [ -n "$mailFrom3" ]  && [[ "$mailFrom3" != " NULL NULL" ]]
then
mailDetails=${mailDetails}"
From: $mailFrom3
Subject: $mailSubj3
Received: $mailDate3
"
fi

if [ -n "$mailFrom4" ]  && [[ "$mailFrom4" != " NULL NULL" ]]
then
mailDetails=${mailDetails}"
From: $mailFrom4
Subject: $mailSubj4
Received: $mailDate4
"
fi

if [ -n "$mailFrom5" ]  && [[ "$mailFrom5" != " NULL NULL" ]]
then
mailDetails=${mailDetails}"
From: $mailFrom5
Subject: $mailSubj5
Received: $mailDate5"
fi




full_email="$mailSalutation**$userName**,

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

echo ______________________________ >> $LOG
echo `date` >> $LOG
echo >> $LOG
echo email sent to:  $userEmail >> $LOG
echo >> $LOG
echo $full_email >> $LOG
echo >> $LOG

echo -e "$full_email" > /tmp/email_queue/"$userName"_email.txt

#Send the actual email
#/usr/local/manhunt/cron/treet_pusher.py -e$email2Use -f/tmp/email_queue/"$userName"_email.txt -i$userID -u$userName -s"$subject2Use"

let "MyModulus = $LoopCounter%100"
  if [ "$MyModulus" = "0" ]
  then
     #now send the BCC
      /usr/local/manhunt/cron/treet_pusher.py -esfrattura@online-buddies.com -f/tmp/email_queue/"$userName"_email.txt -i$userID -u$userName -s"$subject2Use"
  fi


rm /tmp/email_queue/"$userName"_email.txt
fi


done

echo SCRIPT ENDED ON `date` >> $LOG
