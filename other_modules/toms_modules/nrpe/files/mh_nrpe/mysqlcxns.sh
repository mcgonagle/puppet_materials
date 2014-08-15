#! /bin/sh

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
warn=1600
crit=2000
null="NULL"
usage1="Usage: $0 -H <host> -u user -p password [-w <warn>] [-c <crit>]"
usage2="<warn> is cxns to warn at.  Default is 1600."
usage3="<crit> is cxns to be critical at.  Default is 2000."

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

cxns=`/usr/bin/mysql -u $user -p$pass $db -h $host -e 'show status like "Threads_connected";' | /bin/awk '/Threads_connected/ {print $2}'` 

echo $host has $cxns connections

# if null, critical
if [ $cxns == $null ]; then 
exit $STATE_CRITICAL;
fi

if [ $cxns -ge $warn ]; then 
if [ $cxns -lt $crit ]; then 
exit $STATE_WARNING;
fi
fi

if [ $cxns -ge $crit ]; then 
exit $STATE_CRITICAL;
fi

if [ $cxns -lt $warn ]; then 
exit $STATE_OK;
fi
