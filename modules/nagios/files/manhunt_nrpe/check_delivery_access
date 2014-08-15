#!/bin/sh


STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

HOST=`hostname`
FOUND=0

if [[ -z $HOST  ]]
then
    echo "No server specified."
    exit $STATE_WARNING;
fi

for FILES in `/usr/bin/find /var/log/httpd/delivery_access* -type f -mmin -60  -size +2k`
do

    if [[ $FILES = *delivery_access*  ]] 
    then
        FOUND=1
    fi 

done

if [[  FOUND -eq 1  ]] 
then
    echo "$HOST is delivering ads."
    exit $STATE_OK
else
    echo "$HOST does NOT seem to be delivering ads."
    exit $STATE_CRITICAL
fi


