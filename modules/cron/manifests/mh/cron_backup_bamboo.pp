class cron::cron_pushlogs inherits cron {

  #  manhunt_cron_file { backup_directory:
  #    script_name => "backup_directory",
  #  }

  cron { backup_bamboo:
    ensure => present,
    command => "$cron_dir/backup_directory bamboo colbert /bamboo-backup | $cron_dir/mailif -t $mailnotify \"$hostname backup_bamboo\"",
    user    => care,
    hour    => 3,
    minute  => 33,
    require => Manhunt_cron_file [ backup_directory ],
  }
}
