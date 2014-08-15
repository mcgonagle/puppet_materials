class cron::cron_maindb_backups inherits cron {
  $bkp_path="/var/backup/v4/mysql"
  $bkp_host="mainbk01"

  manhunt_cron_file { maindb_backups:
    script_name => "backup_databases_fast_restore_care.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }
  cron { maindb_backups_schedule:
    ensure => present,
    command => "$cron_dir/backup_databases_fast_restore_care.sh > $bkp_path/$bkp_host/db_fast_restore.log 2>&1",
    user    => care,
    hour    => [3,7,11,15,19,23],
    minute  => 00,
    require => Manhunt_cron_file [ maindb_backups ],
  }

}
