#!/bin/bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
warn=7
crit=5
null="NULL"
usage1="[-w <warn>] [-c <crit>]"
usage2="<warn> default is 7."
usage3="<crit> default is 5."

while [ -n "$1" ]; do
case "$1" in
-c)
        crit=$2
        shift
        ;;
-w)
        warn=$2
        shift
        ;;
        -h)
        echo $usage1;
        echo
        echo $usage2;
        echo $usage3;
        exit $STATE_UNKNOWN
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

#echo `ps -A -o comm --sort %cpu | tac | head -n 1`
TOPPROCESS=`ps -A -o comm --sort %cpu | tac | head -n 1`
MYSQLCOUNT=0

# try this ten times over 10 seconds. If 5 to 7 times it is not mysqld, then warn,
# if less than 5 times, critical, otherwise okay

for (( i=1; i<=10; i++ ))
do
        if [ $TOPPROCESS == "mysqld" ]; then
                let MYSQLCOUNT=MYSQLCOUNT+1
        fi
        sleep 0.1;
done

echo "MYSQL is top process $MYSQLCOUNT out of 10 tries."

# 0<----c-w-->10
# 0 123456789 10
# mysqlcount<c,  c<mysqlcount<w, w<mysqlcount

# c<mysqlcount<w
if [ $MYSQLCOUNT -le $warn ]; then
        if [ $MYSQLCOUNT -gt $crit ]; then
                exit $STATE_WARNING;
        fi
fi

# mysqlcount<=c
if [ $MYSQLCOUNT -le $crit ]; then
        exit $STATE_CRITICAL;
fi

# w<mysqlcount
if [ $MYSQLCOUNT -gt $warn ]; then
        exit $STATE_OK;
fi

