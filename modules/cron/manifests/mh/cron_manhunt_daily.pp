class cron::cron_manhunt_daily inherits cron {
  manhunt_cron_file { manhunt_daily:
    script_name => "manhunt_daily",
  }
  cron { manhunt_daily:
    ensure => present,
    command => "$cron_dir/manhunt_daily | $cron_dir/mailif -t $monitor_mail \"$hostname manhunt daily\"",
    user    => root,
    hour    => 5,
    minute  => 30,
    require => Manhunt_cron_file [ manhunt_daily ],
  }
}
