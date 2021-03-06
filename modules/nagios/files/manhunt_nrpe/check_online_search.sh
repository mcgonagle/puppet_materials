#! /bin/sh

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
warn=30
crit=60
null="NULL"
usage1="Usage: $0 -H <host> -u user -p password [-w <warn>] [-c <crit>]"
usage2="<warn> is lag time, in seconds, to warn at.  Default is 30."
usage3="<crit> is lag time, in seconds, to be critical at.  Default is 60."

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

/usr/bin/mysql -u $user -p$pass -h $host manhunt_v4 -N -e 'select o/p as Reading, if(o/p between 0.09 and 1.01, 1, 0) as OK, if(o/p between 0.9 and 1.1, 0, 1) as Critical from (select count(0) p from presence) as pp, (select count(0) o from online_search) as oo' > /tmp/nagOnlineSearch.$$

READING=`/bin/cut -f1 /tmp/nagOnlineSearch.$$`
OK=`/bin/cut -f2 /tmp/nagOnlineSearch.$$`
CRITICAL=`/bin/cut -f3 /tmp/nagOnlineSearch.$$`
/bin/rm /tmp/nagOnlineSearch.$$

if [ $READING == $null ]; then
   echo "Failed to retrieve ONLINE_SEARCH count."
   exit $STATE_CRITICAL
else
   echo "ONLINE_SEARCH table is at $READING"
fi

if [ $CRITICAL == "1" ]; then
   exit $STATE_CRITICAL;
fi

if [ $OK == "0" ]; then
   exit $STATE_WARNING;
fi

if [ $OK == "1" ]; then
   exit $STATE_OK
else
   exit $STATE_UNKNOWN
fi

