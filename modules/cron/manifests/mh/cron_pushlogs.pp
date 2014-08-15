class cron::cron_pushlogs inherits cron {
  include manhunt_mailif

  manhunt_cron_item { "pushlogs.pl":
    user    => root,
    hour    => 5,
    minute  => 30,
  }
}
