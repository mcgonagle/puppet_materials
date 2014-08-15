class cron::backup_mysql_script inherits cron {
  manhunt_cron_file { backup_mysql_all:
    script_name => "backup_mysql_all",
  }

$srchosts = $hostname ? {
    tera-bactyl01 => "devdb00 db152 mailbd01db152 maildb02db152 maildb03db152 sensor01 bkp-itdbmain bkp-itsomerville bkp-mysqlentmon phoenix-db dev-mainro dev-mail01 dev-mail02 dev-mail03 dev-mail04 dev-trackdb red-mainro red-mail01 red-mail02 red-mail03 red-mail04 red-trackdb blue-mainro blue-mail01 blue-mail02 blue-mail03 blue-mail04 blue-trackdb",
    tera-bactyl02 => "bkp-trackdb00 itdb04 jpdb03 jpmaildb03 bkp-jpdb bkp-jpmail",
    tera-bactyl03 => "bkp-mailshard01 bkp-mailshard02 bkp-mailshard03 bkp-mailshard04",
    tera-bactyl04 => "db-itsomerville",
  }

  cron { backup_mysql_all:
    ensure => present,
    command => "$cron_dir/backup_mysql_all 7 $srchosts | $cron_dir/mailif -t \"$monitor_mail,kpanacy@online-buddies.com,jjoy@online-buddies.com\" \"$hostname $name\"",
    user    => care,
    hour   => 12,
    minute => 00,
    require => Manhunt_cron_file [ backup_mysql_all ],
  }
}
