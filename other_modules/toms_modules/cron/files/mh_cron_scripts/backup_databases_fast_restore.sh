find  /var/backup/  -type f -mtime +1 -exec rm -rf {} \;

BACKUP_ADMIN_EMAIL="aalexander@online-buddy.com"
BACKUP_MAIL_SUBJECT="`hostname`: SQL Backup Synchronization Result"
BACKUP_DATE=`date +"%b-%d-%y-%H-%M-%S"`
BACKUP_USER="backup_user" # User at remote storage
MYSQL_USER="root" # MySQL user
DATABASE=manhunt_v4

BACKUP_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE
BIG_TABLES_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/bigtables
SMALL_TABLES_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/smalltables
PHPKB_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/phpkb
MANHAUSE_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/MANHAUS
MYSQL_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/mysql
FEDERATED_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/federated
PRESENCE_FEDERATED_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/presence_federated
ROUTINES_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/routines
SCHEMA_DIR=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/schema

#MYSQL_PASSWD=`cat /etc/psa/.psa.shadow`
MYSQL_PASSWD=Pdn1uL+p
BACKUP_LOG=/var/backup/dw03_manhunt_v4_$BACKUP_DATE/log/dw03_manhunt_v4_$BACKUP_DATE-backup-sql.log

mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/bigtables
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/smalltables
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/phpkb
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/MANHAUS
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/federated
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/mysql
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/log
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/presence_federated
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/schema
mkdir /var/backup/dw03_manhunt_v4_$BACKUP_DATE/routines


cd /var/backup

# Dump
echo "Backup Started at `date`" > $BACKUP_LOG
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "Load overage at start: $load_average" >> $BACKUP_LOG
echo "BackingUP $Database database:" >> $BACKUP_LOG

echo "Stopping Slave `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock $DATABASE --silent -e "slave stop"
echo "Slave Stopped `date`" >> $BACKUP_LOG

echo "Locking Tables `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock $DATABASE --silent -e "flush tables with read lock"
echo "Tables locked `date`" >> $BACKUP_LOG

echo "Capturing Slave Position `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock $DATABASE --silent -e "show slave status\G" >> $BACKUP_LOG

echo "MySQL dump started at `date`" >> $BACKUP_LOG

touch $BACKUP_DIR/xxxlock

for i in `/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock information_schema  --silent -e "select table_name from tables where table_name in ('entitlement_user_tokens', 'buddies','locations', 'locations_fulltext', 'profile_entries') "`; do echo "Adding Innodb Parameters to the dump files  --->> $i..." >> $BACKUP_LOG ; echo "SET AUTOCOMMIT=0; SET UNIQUE_CHECKS=0; SET FOREIGN_KEY_CHECKS=0;" > $BIG_TABLES_DIR/$i.dump; done 

for i in `/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock information_schema  --silent -e "select table_name from tables where table_name in ('entitlement_user_tokens', 'locations', 'locations_fulltext', 'buddies', 'profile_entries') "`; do echo "Dumping table --->> $i..." >> $BACKUP_LOG ; /data02/multi_mysql/mysql_B/bin/mysqldump --single-transaction -S /data02/multi_mysql/mysql_B/mysql.sock --insert-ignore --quick --opt --skip-extended-insert -u$MYSQL_USER -p$MYSQL_PASSWD $DATABASE $i >> $BIG_TABLES_DIR/$i.dump; done &

/data02/multi_mysql/mysql_B/bin/mysqldump --single-transaction -S /data02/multi_mysql/mysql_B/mysql.sock --insert-ignore --quick --opt --skip-extended-insert -u$MYSQL_USER -p$MYSQL_PASSWD mysql > $MYSQL_DIR/mysql.dump &

/data02/multi_mysql/mysql_B/bin/mysqldump --single-transaction -R -S /data02/multi_mysql/mysql_B/mysql.sock --insert-ignore --quick --opt --skip-extended-insert -u$MYSQL_USER -p$MYSQL_PASSWD phpkb > $PHPKB_DIR/phpkb.dump &

/data02/multi_mysql/mysql_B/bin/mysqldump --single-transaction -R -S /data02/multi_mysql/mysql_B/mysql.sock --insert-ignore --quick --opt --skip-extended-insert -u$MYSQL_USER -p$MYSQL_PASSWD MANHAUS > $MANHAUSE_DIR/MANHAUS.dump &

/data02/multi_mysql/mysql_B/bin/mysqldump --single-transaction -R -S /data02/multi_mysql/mysql_B/mysql.sock --insert-ignore --quick --opt --skip-extended-insert -u$MYSQL_USER -p$MYSQL_PASSWD presence_federated > $PRESENCE_FEDERATED_DIR/presence_federated.dump &

/data02/multi_mysql/mysql_B/bin/mysqldump --no-data  -S /data02/multi_mysql/mysql_B/mysql.sock --opt  -u$MYSQL_USER -p$MYSQL_PASSWD federated_v4  > $FEDERATED_DIR/federated_v4.dump &

for i in `/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock information_schema  --silent -e "select table_name from tables where table_name not in ('entitlement_user_tokens', 'buddies', 'profile_entries', 'locations', 'locations_fulltext') and table_schema='manhunt_v4' and engine in ('InnoDB', 'MyISAM', 'MEMORY') "`; do echo "Dumping table --->> $i..." >> $BACKUP_LOG ; echo "SET AUTOCOMMIT=0; SET UNIQUE_CHECKS=0; SET FOREIGN_KEY_CHECKS=0;"  > $SMALL_TABLES_DIR/$i.dump; done

for i in `/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock information_schema  --silent -e "select table_name from tables where table_name not in ('entitlement_user_tokens', 'buddies', 'profile_entries', 'locations', 'locations_fulltext') and table_schema='manhunt_v4' and engine in ('InnoDB', 'MyISAM', 'MEMORY') "`; do echo "Dumping table --->> $i..." >> $BACKUP_LOG ; /data02/multi_mysql/mysql_B/bin/mysqldump --single-transaction -S /data02/multi_mysql/mysql_B/mysql.sock --insert-ignore --quick --opt --skip-extended-insert -u$MYSQL_USER -p$MYSQL_PASSWD $DATABASE $i >> $SMALL_TABLES_DIR/$i.dump; done

for i in `/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock information_schema  --silent -e "select table_name from tables where table_name not in ('entitlement_user_tokens', 'buddies', 'profile_entries', 'locations', 'locations_fulltext') and table_schema='manhunt_v4' and engine in ('InnoDB', 'MyISAM', 'MEMORY') "`; do echo "Dumping table --->> $i..." >> $BACKUP_LOG ; echo "SET AUTOCOMMIT=1; SET UNIQUE_CHECKS=1; SET FOREIGN_KEY_CHECKS=1;"  >> $SMALL_TABLES_DIR/$i.dump; done

for i in `/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock information_schema  --silent -e "select table_name from tables where table_name in ('entitlement_user_tokens', 'buddies', 'profile_entries', 'locations', 'locations_fulltext') "`; do echo "Adding Innodb Parameters to the dump files  --->> $i..." >> $BACKUP_LOG ; echo "SET AUTOCOMMIT=1; SET UNIQUE_CHECKS=1; SET FOREIGN_KEY_CHECKS=1;" >> $BIG_TABLES_DIR/$i.dump; done

echo "Dumping Database Routines `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysqldump -u root  -pPdn1uL+p  -S /data02/multi_mysql/mysql_B/mysql.sock --no-create-info --no-data -R --all-databases > $SMALL_TABLES_DIR/routines.dump

echo "Dumping Database Routines `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysqldump -u root  -pPdn1uL+p  -S /data02/multi_mysql/mysql_B/mysql.sock --no-create-info --no-data -R --all-databases > $ROUTINES_DIR/routines.dump

echo "Dumping Database Routines `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysqldump -u root  -pPdn1uL+p  -S /data02/multi_mysql/mysql_B/mysql.sock --no-data --all-databases > $SCHEMA_DIR/schema.dump

echo "Unlocking Tables `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock $DATABASE --silent -e "unlock tables"
echo "Tables unlocked `date`" >> $BACKUP_LOG

echo "Starting Slave `date`" >> $BACKUP_LOG
/data02/multi_mysql/mysql_B/bin/mysql -u root  -pPdn1uL+p --batch   -S /data02/multi_mysql/mysql_B/mysql.sock $DATABASE --silent -e "slave start"
echo "Slave started `date`" >> $BACKUP_LOG
echo "MySQL dump completed at `date`" >> $BACKUP_LOG
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "\nLoad overage after MySQL dumps: $load_average\n" >> $BACKUP_LOG
echo "Done" >> $BACKUP_LOG
echo "Backup completed at `date`" >> $BACKUP_LOG
load_average=`uptime|awk '{print $10" "$11" "$12}'`
echo "\nLoad overage after backup: $load_average\n" >> $BACKUP_LOG
