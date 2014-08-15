class cron::backup_oracle inherits cron {

  $srchosts = $hostname ? {
    tera-bactyl01 => "flamingo",
    tera-bactyl02 => "dns01 edns01"
  }
  manhunt_cron_item { backup_dns:
    user    => care,
    hour    => 5,
    minute  => 10,
    opts    => $srchosts,
  }
}
