#!/bin/bash 
# $Id: innodb_space_utilization.sh,v 1.17 2010/03/25 17:23:55 kpanacy Exp $
#
# Created by hschmidt 2/09

##############
#
#  Nagios Alert instructions below 
#
##############

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

###############
# Defaults that don't get set below
###############
host="localhost"
user="nagmon"
pass="m0n1t0rM3"
warn=2
crit=1
db=mysql
altdb=manhunt_v4
null="NULL"
export exit_string=""
export exit_state=0

##############
#
#  Usage instructions below 
#
##############

usage1="Usage: $0 -u user -p password [-w <warn>] [-c <crit>]"
usage2="<warn> is GB to warn at.  Default is $warn"
usage3="<crit> is GB to be critical at.  Default is $crit"

exitstatus=$STATE_WARNING #default
while test -n "$1"; do
    case "$1" in
        -c)
            export crit=$2
            shift
            ;;
        -w)
            export warn=$2
            shift
            ;;
        -u)
            export user=$2
            shift
            ;;
        -p)
            export pass=$2
            shift
            ;;
#        -h)
#            echo $usage1;
#	    echo 
#            echo $usage2;
#            echo $usage3;
#            exit $STATE_UNKNOWN
#	    ;;
#	-H)
#            export host=$2
#            shift
#            ;;
        *)
            echo "Unknown argument: $1"
            echo $usage1;
	    echo 
            echo $usage2;
            echo $usage3;
            exit $STATE_CRITICAL
            ;;
    esac
    shift
done

count=0
for homedir in `grep "MYSQL_HOME" /etc/init.d/mysql_* | /bin/egrep -v -e '#' -e 'server' | /bin/awk -F"=" '{print $2}'`
do
if [ ! -S $homedir/mysql.sock ]; then
	exit_string=`echo "$exit_string" "UNK Instance " $homedir " mysql.sock is missing. "`
# ignore instances that are shut down
# 	export exit_state=$STATE_UNKNOWN
	continue		
fi
count+=1
total_ibdata_space=`perl -ne 'if (/innodb_data_file_path/) {$total_G+=$1 while(/([0-9]+)[GM];*/g); pos()-1; print $total_G}' $homedir/my.cnf` 
# echo $total_ibdata_space
###############
#
# Debugging 
# echo "$homedir/bin/mysql -u $user -p$pass $db -S $homedir/mysql.sock -e 'select distinct(round((data_free/1024)/1024)/1024) GbytesFree from INFORMATION_SCHEMA.TABLES where engine ="InnoDB"\G' | awk '/GbytesFree:/ {print $2}'"
#
###############

# Any/all SELECT references to INFORMATION_SCHEMA.TABLES could fail with the following
# if any are federated:
#
# ERROR 1431 (HY000) at line 1: The foreign data source you are trying to reference does not
#  exist. Data source error:  error: 1146  'Table 'manhunt.v4_profile_entries' doesn't exist'
#
# So if the first query fails we look for a table named manhunt_v4.u%

dbfreespace=`$homedir/bin/mysql -u $user -p$pass $db -S $homedir/mysql.sock -e 'select distinct(round((data_free/1024)/1024)/1024) GbytesFree from INFORMATION_SCHEMA.TABLES where engine ="InnoDB"\G' | awk '/GbytesFree:/ {print $2}'`
[ "$dbfreespace" = "" ] && dbfreespace=`expr \`$homedir/bin/mysql -u $user -p$pass -S $homedir/mysql.sock -e "use $altdb;show table status like 'u%'\G"|grep Data_free|head -1|cut -d: -f2\` / 1024 / 1024 / 1024`

# echo "dbfreespace : " $dbfreespace
#inuse=${dbusedspace:-0}
notinuse=${dbfreespace}

#warn_alert_level=$( echo |  awk '{ print "'"$total_ibdata_space"'" - "'"$inuse"'" }' | cut -d. -f1 )
#crit_alert_level=$( echo |  awk '{ print "'"$total_ibdata_space"'" - "'"$inuse"'" }' | cut -d. -f1 )
warn_alert_level=$( echo |  awk '{ print "'"$dbfreespace"'" }' | cut -d. -f1 )
crit_alert_level=$( echo |  awk '{ print "'"$dbfreespace"'" }' | cut -d. -f1 )

# echo "crit alert level (total minus inuse) : $crit_alert_level"
# echo "warn alert level (total minus inuse) : $warn_alert_level"

# echo "Default warn value: $warn"
# echo "Default crit value: $crit"


################
#  This is a extended test condition for alerting per item in loop that there is a problem 
################

# If critical level  which is total - inuse then compared to the crit level. If remainder is less than crit then state it as Critical.

if [   "$crit_alert_level" -le "$crit" ]; then 
	export exit_state=$STATE_CRITICAL
#	echo "Setting CRIT exit_state to $STATE_CRITICAL"
	exit_string=`echo "$exit_string" "CRITICAL Instance " $homedir " " $notinuse "GB out of $total_ibdata_space GB. "`

# If warning level  which is total - inuse then compared to the warn level and crit level. If remainder is above "less than warn" value but above crit then Warn folks.

elif [ \( $warn_alert_level -le $warn \) -o \( $crit -ge $crit_alert_level \) ]; then 
	if [ $exit_state -eq 0 ]; then 
		export exit_state=$STATE_WARNING
#		echo "Setting WARN exit_state to $STATE_WARNING"
	fi
	exit_string=`echo "$exit_string" "WARN Instance $homedir $notinuse GB out of $total_ibdata_space GB. "`

# If warning level  which is total - inuse then compared to the warn level. If remainder is "more than warn" value then space available for InnoDB is all well and good for now.

else 
#	echo "Setting OK exit_state to $?"
	exit_string=`echo "$exit_string" "OK Instance $homedir $notinuse GB out of $total_ibdata_space GB. "`
fi

done

if [ $count -eq 0 ]; then 
	echo $0 ": No MySQL servers on this machine! "
	exit $STATE_CRITICAL
fi

echo $exit_string
exit $exit_state
