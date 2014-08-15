class cron::cron_backup_atlassian inherits cron {
  $srchosts = $hostname ? {
    tera-bactyl01 => "ovulator01",
    tera-bactyl02 => "ovulator02"
  }
  manhunt_cron_item { backup_puppet:
    user    => care,
    hour    => 4,
    minute  => 30,
    opts    => $srchosts,
  }
}
