LOGFILE_NAME=/home/oracle/rman.log
date >> ${LOGFILE_NAME}

rman nocatalog msglog=${LOGFILE_NAME} append << EOF

connect target /
set echo on

run {

allocate channel t1 type disk;

backup
  full
  filesperset=20
  database;

sql 'alter system archive log current';

backup
  filesperset=50
  archivelog all delete input;

backup
  current controlfile;

release channel t1;

}

run{

allocate channel d1 type disk;

copy
  current controlfile
  to '/u01/app/oracle/backup/%U_bkup.ctl';

release channel d1;

sql 'alter database backup controlfile to trace';

}


EOF
RC=$?

echo "RMAN return code=$RC" >> $LOGFILE_NAME
date >> ${LOGFILE_NAME}
