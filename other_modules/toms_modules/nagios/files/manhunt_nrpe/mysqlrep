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

/usr/bin/mysql -u $user -p$pass -h $host -e 'show slave status\G' > /tmp/nagrep.$$
errno=`/bin/grep Last_Errno /tmp/nagrep.$$ | /bin/cut -f2 -d:`
running=`/bin/grep Slave_IO_Running /tmp/nagrep.$$ | /bin/cut -f2 -d:`
seconds=`/bin/grep Seconds_Behind_Master /tmp/nagrep.$$ | /bin/cut -f2 -d:`
/bin/rm /tmp/nagrep.$$

if [ "$seconds" != " NULL" ]
then
  echo $host is $seconds seconds behind
elif [ "$running" == " No" ]
then
  echo $host replication halted by user command
else
  echo $host errno $errno replication halted
fi

# on the number line, we need to test 6 cases:
# 0-----w-----c----->
# 0, 0<lag<w, w, w<lag<c, c, c<lag
# which we simplify to 
# lag>=c, w<=lag<c, 0<=lag<warn

# if null, critical
if [ $seconds == $null ]; then 
exit $STATE_CRITICAL;
fi

if [ $seconds == "" ]; then 
exit $STATE_CRITICAL;
fi

#w<=lag<c
if [ $seconds -lt $crit ]; then 
if [ $seconds -ge $warn ]; then 
exit $STATE_WARNING;
fi
fi

if [ $seconds -ge $crit ]; then 
exit $STATE_CRITICAL;
fi

# 0<=lag<warn
if [ $seconds -lt $warn ]; then 
exit $STATE_OK;
fi
