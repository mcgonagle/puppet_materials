#!/bin/sh
# /home/care/bkp_mailshard_fast_restore.sh
# 
# $Id: bkp_mailshard_fast_restore.sh,v 1.4 2010/08/30 21:20:48 kpanacy Exp $
#
# Source care user universal variables from /etc/manhunt/source.sh
# See /usr/local/manhunt/cron and scripts on admin02
#
. /etc/manhunt/source.sh

mh_user_check care
LOG=${CARE_LOG}
mh_init

# default user and password
# These are the grants for backup now in play on bkp mailshards:
# GRANT SELECT, RELOAD, FILE, SUPER, PROCESS, LOCK TABLES, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'bkp'@'192.168.%' IDENTIFIED BY PASSWORD '5cd3f98d0a42bb73';
#
DBUSER=${BKPUSER} # MySQL Backup user
DBPASSWD=${BKPPASSWD}

# check if alternate user/password was used
usage1="Usage: $0 -H <host mailshard>"

while [ -n "$1" ]; do
    case "$1" in
        -h)
            echo $usage1;
            echo
            exit 1
            ;;
        -H)
            HOST=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            echo $usage1;
            echo
            exit 1
            ;;
    esac
    shift
done

# whom to email with errors
# EMAIL_PAGE="kpanacy@online-buddies.com"

# BACKUP_ADMIN_EMAIL="kpanacy@online-buddies.com"
# BACKUP_MAIL_SUBJECT="$HOST: bkp rapid restore backup"
# BACKUP_USER="backup_user"

# Check Database Connection (May be omitted for scripts that do not need DB Connectivity)
mh_db_check $DBUSER $DBPASSWD $HOST

BACKUP_DATE=`date +"%b-%d-%y-%H-%M-%S"`
BACKUP_BASE_DIR=/var/backup/mysql/rapidrestore
BACKUP_DIR=$BACKUP_BASE_DIR/${HOST}_${BACKUP_DATE}
BACKUP_LOG=$BACKUP_DIR/log/${HOST}_${BACKUP_DATE}.log

# Set NON-ZERO to run in DEBUG mode.  This is set as DEBUG=0 in source.sh, so it's only necessary here if you want to change the value.
DEBUG=0
VERBOSITY=-v

# Log Start Of Script
echo "START $APPNAME for ${HOST} `date`" >> $LOG
echo "`date` [${HOST}] Logging progress to $BACKUP_LOG" >> $LOG

# Debugging
if [ $DEBUG -ne 0 ]; then
    echo "`date` [${HOST}] $APPNAME Running in DEBUG Mode on `date`" >> $LOG
    [ "$VERBOSITY" = "" ] && echo "`date` [${HOST}]  $APPNAME in NON Verbose Mode " >> $LOG
    [ "$VERBOSITY" = "" ] || echo "`date` [${HOST}]  $APPNAME in Verbose Mode " >> $LOG
    [ "$VERBOSITY" = "-vv" ] && echo "`date` [${HOST}]  $APPNAME in EXTRA Verbose Mode" >> $LOG
else
    echo "$APPNAME Running in NORMAL Mode on `date`" >> $LOG
    [ "$VERBOSITY" = "" ] && echo "`date` [${HOST}]  $APPNAME in NON Verbose Mode " >> $LOG
    [ "$VERBOSITY" = "" ] || echo "`date` [${HOST}]  $APPNAME in Verbose Mode " >> $LOG
    [ "$VERBOSITY" = "-vv" ] && echo "`date` [${HOST}]  $APPNAME in EXTRA Verbose Mode" >> $LOG        
fi

# Executable variables
DATABASE=${V4_MAILDB}
DUMPOPTS="--extended-insert --quick --insert-ignore"
# used to have --single-transaction here but that doesn't work with LOCK TABLES

# Session settings for huge dump file
SESSION_SETTINGS="SET AUTOCOMMIT = 0; SET FOREIGN_KEY_CHECKS=0;"

#
#  Separate large and small tables into two lists
#
IGNORE_TABLES="'mail_graveyard','mailboxes_wrong_shard','tmp_mm_to_add','PaywayShard1','PaywayShard2','PaywayShard3','PaywayShard4','deletedUsers','UidsToRecall','Broadcast_shard1','Broadcast_shard2','Broadcast_shard3','Broadcast_shard4'"
IN_SQL="select table_name, engine, row_format, table_rows, avg_row_length, (data_length+index_length)/1024/1024 as total_mb, (data_length)/1024/1024 as data_mb, (index_length)/1024/1024 as index_mb from information_schema.tables where table_schema=DATABASE() AND  (data_length+index_length)/1024/1024 > 500.00 and table_name not in (${IGNORE_TABLES}) order by 6 desc "
NOT_IN_SQL="select table_name, engine, row_format, table_rows, avg_row_length, (data_length+index_length)/1024/1024 as total_mb, (data_length)/1024/1024 as data_mb, (index_length)/1024/1024 as index_mb from information_schema.tables where table_schema=DATABASE() AND  (data_length+index_length)/1024/1024 < 500.00 and table_name not in (${IGNORE_TABLES}) order by 6 desc "

BIG_TABLES_DIR=$BACKUP_DIR/bigtables
SMALL_TABLES_DIR=$BACKUP_DIR/smalltables
MYSQL_DIR=$BACKUP_DIR/mysql
ROUTINES_DIR=$BACKUP_DIR/routines
SCHEMA_DIR=$BACKUP_DIR/schema


mkdir $BACKUP_DIR
mkdir $BACKUP_DIR/bigtables
mkdir $BACKUP_DIR/smalltables
mkdir $BACKUP_DIR/mysql
mkdir $BACKUP_DIR/log
mkdir $BACKUP_DIR/schema
mkdir $BACKUP_DIR/routines

cd $BACKUP_DIR

#
# Create the large and small table lists
#
echo "`date +"%b-%d-%y %H:%M:%S"` Backup Started" >> $BACKUP_LOG

echo "Creating the big table list" >> $BACKUP_LOG
${MYSQL} -u ${DBUSER}  -p${DBPASSWD} -h ${HOST} ${DATABASE} --silent -e "${IN_SQL}" >> ${BIG_TABLES_DIR}/bigtables_list.txt

echo "Creating the small table list" >> $BACKUP_LOG
${MYSQL} -u ${DBUSER}  -p${DBPASSWD} -h ${HOST} ${DATABASE} --silent -e "${NOT_IN_SQL}" >> ${SMALL_TABLES_DIR}/smalltables_list.txt

# Dump
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "Load overage at start: $load_average" >> $BACKUP_LOG
echo "Backing up ${DATABASE} database..." >> $BACKUP_LOG

if [ $DEBUG -ne 0 ]; then
    echo "DEBUGGING: "
    echo "${MYSQL} -u ${DBUSER} -p[password] --batch  -h ${HOST} ${DATABASE}"
    echo "${MYSQLDUMP} ${DUMPOPTS} -u ${DBUSER} -p[password] -h ${HOST}"
    echo
    echo "Big tables: ${IN_SQL}"
    echo
    echo "Small tables: ${NOT_IN_SQL}"
else
    echo "Stopping Slave" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER}  -p${DBPASSWD} --batch  -h ${HOST} ${DATABASE} --silent -e "slave stop"
    echo "Slave Stopped" >> $BACKUP_LOG

    echo "Locking Tables" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER}  -p${DBPASSWD} --batch  -h ${HOST} ${DATABASE} --silent -e "flush tables with read lock"
    echo "Tables locked" >> $BACKUP_LOG

    echo "Capturing Slave Position" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER}  -p${DBPASSWD} --batch  -h ${HOST} ${DATABASE} --silent -e "show slave status\G" >> $BACKUP_LOG

    echo "`date +"%b-%d-%y %H:%M:%S"` MySQL dump started" >> $BACKUP_LOG

    touch $BACKUP_DIR/xxxlock

    # set net read and write timeouts to avoid "Error 2013 - failure of mysqldump on large tables"
    echo "Setting the net read and write timeouts to 1200..."
    ${MYSQL} -u ${DBUSER}  -p${DBPASSWD} --batch  -h ${HOST} ${DATABASE} --silent -e "set global net_read_timeout=1200; set global net_write_timeout=1200;" >> $BACKUP_LOG

    echo "Dumping Database ${DATABASE} BIG TABLES" >> $BACKUP_LOG
    for i in `cat ${BIG_TABLES_DIR}/bigtables_list.txt | awk '{print $1}' | sort `; do echo "Dumping table --->> $i..." >> $BACKUP_LOG ; ${MYSQLDUMP} ${DUMPOPTS} -u ${DBUSER} -p${DBPASSWD} -h ${HOST} $DATABASE $i >> $BIG_TABLES_DIR/$i.dump; done &

    echo "Dumping Database ${DATABASE} SMALL TABLES" >> $BACKUP_LOG
    for i in `cat ${SMALL_TABLES_DIR}/smalltables_list.txt | awk '{print $1}' | sort `; do echo "Dumping table --->> $i..." >> $BACKUP_LOG ; ${MYSQLDUMP} ${DUMPOPTS} -u ${DBUSER} -p${DBPASSWD} -h ${HOST} $DATABASE $i >> $SMALL_TABLES_DIR/$i.dump; done &

    echo "Dumping Database mysql" >> $BACKUP_LOG
    ${MYSQLDUMP} ${DUMPOPTS} -u ${DBUSER} -p${DBPASSWD} -h ${HOST} mysql > $MYSQL_DIR/mysql.dump &

    echo "Dumping Database All status" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER} -p${DBPASSWD} -h ${HOST} information_schema  --silent -e "show global status;" >> $BACKUP_DIR/status.dump
    echo "Dumping Database All processlist" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER} -p${DBPASSWD} -h ${HOST}  information_schema  --silent -e "show full processlist;" >> $BACKUP_DIR/processlist.dump
    echo "Dumping Database Innodb status" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER} -p${DBPASSWD} -h ${HOST} information_schema  --silent -e "show innodb status \G;" >> $BACKUP_DIR/innodb_status.dump
    echo "Adding All my.cnf  Parameters to the dump files " >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER} -p${DBPASSWD} -h ${HOST} information_schema  --silent -e "show global variables;" >> $BACKUP_DIR/variables.dump

    echo "Dumping Database Routines" >> $BACKUP_LOG
    ${MYSQLDUMP} -u ${DBUSER}  -p${DBPASSWD} -h ${HOST} --force --no-create-info --no-data -R --triggers --events --all-databases > $ROUTINES_DIR/routines.dump

    echo "Dumping Database Schema" >> $BACKUP_LOG
    ${MYSQLDUMP} -u ${DBUSER}  -p${DBPASSWD} -h ${HOST} --force --no-data --all-databases > $SCHEMA_DIR/schema.dump

    # check processlist on target. don't unlock tables until backups are complete
    # wait will block further execution until all child processes (the big sql dumps) are completed
    echo "`date +"%b-%d-%y %H:%M:%S"` Waiting for large dumps to complete..." >> $BACKUP_LOG
    wait
    echo "`date +"%b-%d-%y %H:%M:%S"` Unlocking Tables" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER}  -p${DBPASSWD} -h ${HOST} --batch ${DATABASE} --silent -e "unlock tables"
    echo "Tables unlocked" >> $BACKUP_LOG

    echo "Starting Slave" >> $BACKUP_LOG
    ${MYSQL} -u ${DBUSER}  -p${DBPASSWD} -h ${HOST} --batch ${DATABASE} --silent -e "slave start"
    echo "Slave started" >> $BACKUP_LOG
            
fi

load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "Load overage at end: $load_average" >> $BACKUP_LOG
echo "`date +"%b-%d-%y %H:%M:%S"` Backup completed" >> $BACKUP_LOG

# remove old files, write these to the Care user log
echo "`date` [${HOST}] Remove old backup files" >> $LOG
/usr/bin/find $BACKUP_BASE_DIR/* -type f -mmin +720 >> $LOG

if [ $DEBUG -eq 0 ]; then
    /usr/bin/find $BACKUP_BASE_DIR/* -type f -mmin +720 -exec rm {} \; 2>&1 > /dev/null
fi

# order is reversed so that it doesn't try to remove a child after the parent is removed
# these will actually get deleted the following day because their modified date
# gets changed by the previous commands
for delete_dir in `/usr/bin/find $BACKUP_BASE_DIR/* -type d -mmin +720 | tac`
do
  echo ${delete_dir} >> $LOG
  if [ $DEBUG -eq 0 ]; then
    rm -r ${delete_dir}
  fi
done

# Note where we've finished in the log
echo "FINISH $APPNAME for ${HOST} `date`" >> $LOG

# Put a newline in the log to space before the next run.
echo >> $LOG

# All Done
mh_exit $?

