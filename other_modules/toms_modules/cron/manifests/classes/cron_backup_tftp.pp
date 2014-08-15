class cron::backup_oracle inherits cron {
  $srchosts = $hostname ? {
    tera-bactyl01 => "ovulator01",
    tera-bactyl02 => "ovulator02 myna"
  }
  manhunt_cron_item { backup_tftp:
    user    => care,
    hour    => 4,
    minute  => 10,
    opts    => $srchosts,
  }
}
