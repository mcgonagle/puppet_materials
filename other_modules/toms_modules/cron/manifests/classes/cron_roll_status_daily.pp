class cron::cron_roll_status_daily inherits cron {
   manhunt_cron_file { roll_status_daily:
    script_name => "roll_status_daily",
  }
  cron { roll_status_daily:
    ensure => present,
    command => "$cron_dir/roll_status_daily | $cron_dir/mailif -t $monitor_mail \"$hostname roll status daily\"",
    user    => root,
    hour    => 5,
    minute  => 0,
    require => Manhunt_cron_file [ roll_status_daily ],
  }

}
