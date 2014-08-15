class cron::cron_pushlogs inherits cron {
  manhunt_cron_item { backup_directory:
    user    => care,
    hour    => 4,
    minute  => 30,
    opts    => "carelogs admin02 /home/care",
  }
}
