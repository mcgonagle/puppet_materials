#! /bin/sh
# $Id: mysqluptime.sh,v 1.1 2009/10/25 18:22:23 rbraun Exp $

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
warn=345600
crit=432000
null="NULL"
usage1="Usage: $0 -H <host> -u user -p password [-w <warn>] [-c <crit>]"
usage2="<warn> is uptime to warn at.  Default is 345600 (4 days)."
usage3="<crit> is uptime to be critical at.  Default is 432000 (6 days)."

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

uptime=`/usr/bin/mysql -u $user -p$pass $db -h $host -e 'show status like "Uptime";' | /bin/awk '/Uptime/ {print $2}'` 

echo $host uptime $uptime

# if null, critical
if [ $uptime == $null ]; then 
exit $STATE_CRITICAL;
fi

if [ $uptime -ge $warn ]; then 
if [ $uptime -lt $crit ]; then 
exit $STATE_WARNING;
fi
fi

if [ $uptime -ge $crit ]; then 
exit $STATE_CRITICAL;
fi

if [ $uptime -lt $warn ]; then 
exit $STATE_OK;
fi
