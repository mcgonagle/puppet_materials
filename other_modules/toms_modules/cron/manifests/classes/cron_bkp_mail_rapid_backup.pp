class cron::cron_bkp_mail_rapid_backup inherits cron {
  manhunt_cron_file { bkp_rapid_backup:
    script_name => "bkp_mailshard_fast_restore.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }

  $srchost1="bkp-mailshard01"
  $srchost2="bkp-mailshard02"
  $srchost3="bkp-mailshard03"
  $srchost4="bkp-mailshard04"

  cron { bkp_rapid_backup_schedule1:
# rbraun 8/10/10 allow to catch up
    ensure => absent,
    command => "$cron_dir/bkp_mailshard_fast_restore.sh -H $srchost1 >> /home/care/${srchost1}_rr.log 2>&1",
    user    => care,
    hour    => [5,17],
    minute  => 00,
    require => Manhunt_cron_file [ bkp_rapid_backup ],
  }
  cron { bkp_rapid_backup_schedule2:
    ensure => present,
    command => "$cron_dir/bkp_mailshard_fast_restore.sh -H $srchost2 >> /home/care/${srchost2}_rr.log 2>&1",
    user    => care,
    hour    => [5,17],
    minute  => 00,
    require => Manhunt_cron_file [ bkp_rapid_backup ],
  }
 cron { bkp_rapid_backup_schedule3:
    ensure => present,
    command => "$cron_dir/bkp_mailshard_fast_restore.sh -H $srchost3 >> /home/care/${srchost3}_rr.log 2>&1",
    user    => care,
    hour    => [5,17],
    minute  => 00,
    require => Manhunt_cron_file [ bkp_rapid_backup ],
  }
  cron { bkp_rapid_backup_schedule4:
    ensure => present,
    command => "$cron_dir/bkp_mailshard_fast_restore.sh -H $srchost4 >> /home/care/${srchost4}_rr.log 2>&1",
    user    => care,
    hour    => [5,17],
    minute  => 00,
    require => Manhunt_cron_file [ bkp_rapid_backup ],
  }
}
