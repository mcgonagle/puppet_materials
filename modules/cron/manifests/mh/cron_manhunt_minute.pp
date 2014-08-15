class cron::cron_manhunt_minute inherits cron {
 require mysql

  manhunt_cron_file { manhunt_minute:
    script_name => "manhunt_minute",
    mode        => 550,
    owner       => care,
    require         => User [ "care" ],
  }
  manhunt_cron_file { minute_sql:
    script_name => "minute.sql",
    mode        => 400,
    owner       => care,
    require         => User [ "care" ],
  }

  cron { manhunt_minute:
    ensure => present,
    command => "$cron_dir/manhunt_minute | $cron_dir/mailif -t $monitor_mail \"$hostname manhunt minute\"",
    user    => root,
    require => [ Manhunt_cron_file [ manhunt_minute ],
                 Manhunt_cron_file [ minute_sql ] ],
  }

}
