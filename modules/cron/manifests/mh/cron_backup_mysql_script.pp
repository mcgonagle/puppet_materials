class cron::backup_mysql_script inherits cron {
  manhunt_cron_file { backup_mysql_all:
    script_name => "backup_mysql_all",
  }
}
