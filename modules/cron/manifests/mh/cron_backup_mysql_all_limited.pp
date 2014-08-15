class cron::backup_mysql_script inherits cron {
  manhunt_cron_file { backup_mysql_all:
    script_name => "backup_mysql_all",
  }

$srchosts = $hostname ? {
    tera-bactyl01 => "dw04v2",
  }

  cron { backup_mysql_all_limited:
    ensure => present,
    command => "$cron_dir/backup_mysql_all 1 $srchosts | $cron_dir/mailif -t \"$monitor_mail,kpanacy@online-buddies.com,jjoy@online-buddies.com\" \"$hostname $name\"",
    user    => care,
    hour   => 5,
    minute => 45,
    require => Manhunt_cron_file [ backup_mysql_all ],
  }
}
