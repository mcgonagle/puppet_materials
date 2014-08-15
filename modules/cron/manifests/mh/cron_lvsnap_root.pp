class cron::cron_pushlogs inherits cron {
  manhunt_cron_file { lvsnap:
    script_name => "lvsnap.sh",
  }

  cron { lvsnap-root-hourly:
    command => "$cron_dir/lvsnap.sh volroot hourly 1G 2 | $cron_dir/mailif -t $monitor_mail \"lvsnap hourly\"",
    user    => root,
    minute  => 59,
    require => Manhunt_cron_file [ lvsnap ],
  }

  cron { lvsnap-root-daily:
    command => "$cron_dir/lvsnap.sh volroot daily 3G 2 | $cron_dir/mailif -t $monitor_mail \"lvsnap daily\"",
    user    => root,
    hour    => 2,
    minute  => 29,
    require => Manhunt_cron_file [ lvsnap ],
  }
}
