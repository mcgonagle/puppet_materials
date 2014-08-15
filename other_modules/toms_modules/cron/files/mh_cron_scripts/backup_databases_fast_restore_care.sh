#!/bin/bash
#This is the good version
#############################################################
# Set up variables
#############################################################
# Source care user universal variables from /etc/manhunt/source.sh
# See /usr/local/manhunt/cron and scripts on admin02
#
. /etc/manhunt/source.sh

# Source variable settings

# HOSTS=$MAILDBHOSTS
LOG=$CARE_LOG
VERBOSITY=-vv

# User and password
# These are the grants for backup now in play on bkp mailshards
# GRANT SELECT, RELOAD, FILE, SUPER, LOCK TABLES, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'bkp'@'192.168.%' IDENTIFIED BY PASSWORD '5cd3f98d0a42bb73';
MYSQL_USER=${BKPUSER} # MySQL Backup user
MYSQL_PASSWD=${BKPPASSWD}

# MYSQL_USER="root" # MySQL user
# MYSQL_PASSWD=Pdn1uL+p

#
# Page if the connection or the script has errors
#
EMAIL_PAGE=${DBA_EMAIL}

# Variables that are built upon below
BACKUP_DATE=`date +"%b-%d-%y-%H-%M-%S"`
BACKUP_DAY=`date +"%b-%d-%y"`
# HOSTNAME=`hostname | awk -F "." '{print $1}'`
HOSTNAME=${V4_MAINBK}
BACKUP_BASE_DIR=/var/backup/v4/mysql/${HOSTNAME}/rr
BACKUP_DIR=${BACKUP_BASE_DIR}/${BACKUP_DAY}/${BACKUP_DATE}

# The log file to reference
BACKUP_LOG=${BACKUP_DIR}/log/${HOSTNAME}_V4_${BACKUP_DATE}.log

mkdir -p ${BACKUP_DIR}/log

touch ${BACKUP_LOG}

# Specializes backup directory names
PHPKB_DIR=${BACKUP_DIR}/phpkb
MYSQL_DIR=${BACKUP_DIR}/mysql

# For now the data dir hard coded -- should be found out from my.cnf
DATA_DIR=/data01/multi_mysql
SOCK_DIR=${DATA_DIR}/mysql_A/mysql.sock

# Executable variables
# Keep the -q ! See SYS-1993 and http://jeremy.zawodny.com/blog/archives/000690.htmli
DUMPOPTS="--skip-extended-insert  --quick --insert-ignore --single-transaction"
DATABASE=${V4_USERDB}
#

# Session settings for huge dump file
echo "Setting the net read and write timeouts dynamically to avoid Error 2013 -- failure of mysqldump on large tables"
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} --batch  -h ${HOSTNAME} ${DATABASE} --silent -e "set global net_read_timeout=1200; set global net_write_timeout=1200;" >> ${BACKUP_LOG}

SESSION_SETTINGS="SET AUTOCOMMIT = 0; SET FOREIGN_KEY_CHECKS=0;"

#
# Create statement for getting the database that matches manhunt_
#
# DATABASE="select distinct(db) from mysql.db where db like 'manhunt%v4%'"
#
# DATABASE="${MYSQL} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} mysql --silent -e "select distinct(db) from mysql.db where db like 'manhunt%v4%';" | tail -2#

#
#  The SQL for generating the list of big tables based on specific DB logged in as
#
IN_SQL="select table_name, engine, row_format, table_rows, avg_row_length, (data_length+index_length)/1024/1024 as total_mb, (data_length)/1024/1024 as data_mb, (index_length)/1024/1024 as index_mb from information_schema.tables where table_schema=DATABASE() AND  (data_length+index_length)/1024/1024 > 500.00 order by 6 desc "
NOT_IN_SQL="select table_name, engine, row_format, table_rows, avg_row_length, (data_length+index_length)/1024/1024 as total_mb, (data_length)/1024/1024 as data_mb, (index_length)/1024/1024 as index_mb from information_schema.tables where table_schema=DATABASE() AND  (data_length+index_length)/1024/1024 < 500.00 order by 6 desc "

#
# Test SQL statements
#
#${MYSQL} -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} ${DATABASE} --batch --silent -e "${IN_SQL}" >> /tmp/bigtables_list.txt
#${MYSQL} -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} ${DATABASE} --batch --silent -e "${NOT_IN_SQL}" >> /tmp/smalltables_list.txt
#exit 0
#


#############################################################
#
# Test to make sure the bkp can connect. If not, page admins
#
#############################################################

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
 echo "Must be care to run this script."
  exit $ERROR
fi

if [ "`touch $LOG`" != "" ]
then
echo "Cannot write to logfile."
exit $ERROR
fi

echo START $APPNAME `date` >> $LOG
if [ "`mysql -u ${MYSQL_USER} -h ${HOSTNAME} -p${MYSQL_PASSWD} ${DATABASE} -e 'show databases'`" == "" ]
        then
                echo "Cannot connect to ${DATABASE}." | mail -s "Backup user not able to connect to ${DATABASE} on ${HOSTNAME}" ${EMAIL_PAGE}
                exit $ERROR
else
#       Run the rest of the script..
        echo "this part is working `date` moving on to the rest"

#
# Export dir variables and make dirs on fly
#
BIG_TABLES_DIR=${BACKUP_DIR}/bigtables
SMALL_TABLES_DIR=${BACKUP_DIR}/smalltables
ROUTINES_DIR=${BACKUP_DIR}/routines
SCHEMA_DIR=${BACKUP_DIR}/schema
PHPKB_DIR=${BACKUP_DIR}/phpkb

mkdir ${BACKUP_DIR}/bigtables
mkdir ${BACKUP_DIR}/smalltables
mkdir ${BACKUP_DIR}/phpkb
mkdir ${BACKUP_DIR}/mysql
mkdir ${BACKUP_DIR}/schema
mkdir ${BACKUP_DIR}/routines


cd ${BACKUP_DIR}


#
# Create the big and small backup lists
#
echo "Creating the big table list ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} ${DATABASE} --silent -e "${IN_SQL}" >> ${BIG_TABLES_DIR}/bigtables_list.txt

echo "Creating the small table list ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} ${DATABASE} --silent -e "${NOT_IN_SQL}" >> ${SMALL_TABLES_DIR}/smalltables_list.txt

# Dump
echo "Backup Started at ${BACKUP_DATE}" > ${BACKUP_LOG}
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "Load overage at start: $load_average" >> ${BACKUP_LOG}
echo "BackingUP $Database database:" >> ${BACKUP_LOG}

echo "Stopping Slave ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} --batch  -h ${HOSTNAME} ${DATABASE} --silent -e "slave stop"
echo "Slave Stopped ${BACKUP_DATE}" >> ${BACKUP_LOG}

echo "Locking Tables ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} --batch  -h ${HOSTNAME} ${DATABASE} --silent -e "flush tables with read lock"
echo "Tables locked ${BACKUP_DATE}" >> ${BACKUP_LOG}

echo "Capturing Slave Position ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} --batch  -h ${HOSTNAME} ${DATABASE} --silent -e "show slave status\G" >> ${BACKUP_LOG}

echo "MySQL dump started at ${BACKUP_DATE}" >> ${BACKUP_LOG}

touch ${BACKUP_DIR}/xxxlock

echo "Dumping Database ${DATABASE} BIG TABLES ${BACKUP_DATE}" >> ${BACKUP_LOG}
for i in `cat ${BIG_TABLES_DIR}/bigtables_list.txt | awk '{print $1}' | sort `; do echo "`date +'%b-%d-%y %H:%M:%S'` Dumping table --->> $i..." >> $BACKUP_LOG ; mysqldump ${DUMPOPTS} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} $DATABASE $i >> $BIG_TABLES_DIR/$i.dump; done

echo "Dumping Database mysql TABLES ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysqldump ${DUMPOPTS} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} mysql > ${MYSQL_DIR}/mysql.dump &

echo "Dumping Database phpkb TABLES ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysqldump ${DUMPOPTS} -R -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} phpkb > ${PHPKB_DIR}/phpkb.dump &

echo "Dumping Database ${DATABASE} SMALL TABLES ${BACKUP_DATE}" >> ${BACKUP_LOG}
for i in `cat ${SMALL_TABLES_DIR}/smalltables_list.txt | awk '{print $1}' | sort `; do echo "`date +'%b-%d-%y %H:%M:%S'` Dumping table --->> $i..." >> $BACKUP_LOG ; mysqldump ${DUMPOPTS} -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} $DATABASE $i >> $SMALL_TABLES_DIR/$i.dump; done

echo "Dumping Database All status ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} information_schema  --silent -e "show global status;" >> ${BACKUP_DIR}/status.dump
echo "Dumping Database All processlist ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME}  information_schema  --silent -e "show full processlist;" >> ${BACKUP_DIR}/processlist.dump
echo "Dumping Database Innodb status ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} information_schema  --silent -e "show innodb status \G;" >> ${BACKUP_DIR}/innodb_status.dump
echo "Adding All my.cnf  Parameters to the dump files " >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWD} -h ${HOSTNAME} information_schema  --silent -e "show global variables;" >> ${BACKUP_DIR}/variables.dump

echo "Dumping Database Routines ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysqldump ${DUMPOPTS} -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} --force --no-create-info --no-data -R --triggers --events --all-databases > $ROUTINES_DIR/routines.dump

echo "Dumping Database Schema ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysqldump ${DUMPOPTS} -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} --force --no-data --all-databases > $SCHEMA_DIR/schema.dump

echo "Unlocking Tables ${BACKUP_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} --batch ${DATABASE} --silent -e "unlock tables"
echo "Tables unlocked ${BACKUP_DATE}" >> ${BACKUP_LOG}

END_DATE=`date +"%b-%d-%y-%H-%M-%S"`
echo "Starting Slave ${END_DATE}" >> ${BACKUP_LOG}
mysql -u ${MYSQL_USER}  -p${MYSQL_PASSWD} -h ${HOSTNAME} --batch ${DATABASE} --silent -e "slave start"
SLAVE_DATE=`date +"%b-%d-%y-%H-%M-%S"`
echo "Slave started ${SLAVE_DATE}" >> ${BACKUP_LOG}
echo "MySQL dump completed at ${SLAVE_DATE}" >> ${BACKUP_LOG}
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "\nLoad overage after MySQL dumps: $load_average\n" >> ${BACKUP_LOG}
echo "Done" >> $LOG
echo "Backup completed at `date +"%b-%d-%y-%H-%M-%S"`" >> ${BACKUP_LOG}
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "\nLoad overage after backup: $load_average\n" >> ${BACKUP_LOG}

# compress to conserve space. compared bzip2 to gzip and 
# found gzip better suited to rapid restore backups.
# compresses and decompresses faster.
echo "`date +'%b-%d-%y %H:%M:%S'` GZIP backup files" >> $LOG
gzip -r $BACKUP_DIR
echo END $APPNAME `date` >> $LOG

# remove old files, write these to the Care user log
echo "Remove old backup files\n" >> $LOG
/usr/bin/find ${BACKUP_BASE_DIR}/* -type f -mmin +720 >> $LOG

/usr/bin/find ${BACKUP_BASE_DIR}/* -type f -mmin +720 -exec rm {} \; 2>&1 > /dev/null

# order is reversed so that it doesn't try to remove a child after the parent is removed
# these will actually get deleted the following day because their modified date
# gets changed by the previous commands
for delete_dir in `/usr/bin/find ${BACKUP_BASE_DIR}/* -type d -mmin +720 | tac`
do
  echo ${delete_dir} >> $LOG
  rm -r ${delete_dir}
done
#
# End of the if then loop up above
#
fi
# Exit with the status of the script  and tell the code as well
echo END $APPNAME `date` >> $LOG
exit
echo $?
#
