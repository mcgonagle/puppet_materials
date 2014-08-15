class cron::cron_updatecount_jp inherits cron {
  manhunt_cron_file { weeklynotifications:
    script_name => "weeklynotifications",
  }
  cron { weeklynotifications:
    ensure => present,
    command => "$cron_dir/weeklynotifications | $cron_dir/mailif -t $monitor_mail \"$hostname update count\"",
    user    => root,
    minute  => '*/20',
    require => Manhunt_cron_file [ weeklynotifications ],
  }
}
