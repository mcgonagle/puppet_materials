#! /bin/sh

# Auto-installed by puppet from /var/ftp/depot/source/olb/nagios-nrpe on Ovulator01/02

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
warn=2750000
crit=3000000
db=manhunt_v4
null="NULL"
usage1="Usage: $0 -H <host> -u user -p password [-w <warn>] [-c <crit>]"
usage2="<warn> is kB to warn at.  Default is 2750000."
usage3="<crit> is kB to be critical at.  Default is 3000000."

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

PRESHISTCOUNT=`mysql -u $user -p$pass -h $host $db  -e 'call get_presence_history_tomorrow_count()\G' | awk '/_count:/ {print $2}' | head -1`

if [ "$PRESHISTCOUNT" != '' ]; then
if [ $PRESHISTCOUNT != $null ]; then
if [ $PRESHISTCOUNT != 0 ]; then
echo Presence_history_xxx count for tomorrow is currently $PRESHISTCOUNT.
fi
fi
fi

# if null, critical
if [ "$PRESHISTCOUNT" = '' ]; then
exit $STATE_CRITICAL;
fi

if [ $PRESHISTCOUNT -eq 0 ]; then
exit $STATE_CRITICAL;
fi

# if null, critical
if [ $PRESHISTCOUNT = $null ]; then
exit $STATE_CRITICAL;
fi

#w<=lag<c
if [ $PRESHISTCOUNT -gt $warn ]; then
if [ $PRESHISTCOUNT -lt $crit ]; then
exit $STATE_WARNING;
fi
fi

if [ $PRESHISTCOUNT -gt $crit ]; then
exit $STATE_CRITICAL;
fi

if [ $PRESHISTCOUNT -lt $warn ]; then
exit $STATE_OK;
fi

