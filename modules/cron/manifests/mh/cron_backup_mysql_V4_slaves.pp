class cron::backup_mysql_V4_slaves inherits cron {
  manhunt_cron_file { backup_mysql_all:
    script_name => "backup_mysql_all",
  }

$srchosts = $hostname ? {
  tera-bactyl01 => "dw04",
    tera-bactyl02 => "dw03 bkp-openxdb01",
  }

  manhunt_cron_item { backup_mysql_V4_slaves:
    user    => care,
    hour    => 4,
    minute  => 45,
    opts    => $srchosts,
    mailnotify => "$monitor_mail,kpanacy@online-buddies.com",
  }
}
