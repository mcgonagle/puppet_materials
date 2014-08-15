class cron::backup_oracle inherits cron {
  include manhunt_user_keys

  $srchost = $hostname ? { tera-bactyl01 => dartdb03, tera-bactyl02 => dartdb01 }
  manhunt_cron_item { backup_oracle:
    ensure => absent,
    user    => care,
    hour    => "*/4",
    minute  => 15,
    opts    => $srchost,
    mailnotify => "$monitor_mail,hschmidt@online-buddies.com",
  }
}
