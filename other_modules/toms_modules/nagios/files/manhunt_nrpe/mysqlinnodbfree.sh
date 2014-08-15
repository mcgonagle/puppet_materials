#! /bin/sh

# Auto-installed by puppet from /var/ftp/depot/source/olb/nagios-nrpe on Ovulator01/02

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
warn=2048
crit=1024
db=manhunt
null="NULL"
usage1="Usage: $0 -H <host> -u user -p password [-w <warn>] [-c <crit>]"
usage2="<warn> is kB to warn at.  Default is 2048."
usage3="<crit> is kB to be critical at.  Default is 1024."

exitstatus=$STATE_WARNING #default
while test -n "$1"; do
    case "$1" in
        -c)
            crit=$2
            shift
            ;;
        -w)
            warn=$2
            shift
            ;;
        -u)
            user=$2
            shift
            ;;
        -p)
            pass=$2
            shift
            ;;
        -h)
            echo $usage1;
	    echo 
            echo $usage2;
            echo $usage3;
            exit $STATE_UNKNOWN
	    ;;
	-H)
            host=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            echo $usage1;
	    echo 
            echo $usage2;
            echo $usage3;
            exit $STATE_UNKNOWN
            ;;
    esac
    shift
done

for db in `mysql -u $user -p$pass -h $host -se 'show databases'`
do
# echo $db
dbfreespace=`mysql -u $user -p$pass -h $host $db  -e 'show table status where Engine="InnoDB"\G' | awk '/free:/ {print $2}' | head -1`
# echo mmm $dbfreespace mmm
if [ "$dbfreespace" != '' ]; then
if [ $dbfreespace != $null ]; then
if [ $dbfreespace != 0 ]; then
freespace=$dbfreespace
echo $host has $freespace kB free!
break
fi
fi
fi
done

# on the number line, we need to test 6 cases:
# 0-----w-----c----->
# 0, 0<lag<w, w, w<lag<c, c, c<lag
# which we simplify to
# lag>=c, w<=lag<c, 0<=lag<warn

# if null, critical
if [ "$freespace" = '' ]; then
exit $STATE_CRITICAL;
fi

if [ $freespace -eq 0 ]; then
exit $STATE_CRITICAL;
fi

# if null, critical
if [ $freespace = $null ]; then
exit $STATE_CRITICAL;
fi

#w<=lag<c
if [ $freespace -lt $warn ]; then
if [ $freespace -ge $crit ]; then
exit $STATE_WARNING;
fi
fi

if [ $freespace -lt $crit ]; then
exit $STATE_CRITICAL;
fi

# 0<=lag<warn
if [ $freespace -gt $warn ]; then
exit $STATE_OK;
fi

