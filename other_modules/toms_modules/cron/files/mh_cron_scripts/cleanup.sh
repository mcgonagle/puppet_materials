#!/bin/bash

if [ "$#" -eq "0" ]; then
    echo "Usage: clean <days to keep> <list: directories>"
    exit
fi

FREQUENCY=$1
shift;

for DIRECTORY in $@

do
    if [ -d $DIRECTORY ]; then
        echo "Cleaning $DIRECTORY ..."
        /usr/bin/find $DIRECTORY -type f -mtime +$FREQUENCY -exec rm  {} \; 2>&1 > /dev/null
    else
        echo "$DIRECTORY doesn't exist.";
    fi
done

