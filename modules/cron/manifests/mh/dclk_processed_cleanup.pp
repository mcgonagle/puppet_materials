class cron::dclk_processed_cleanup inherits cron {

  $stale_time = 7

  cron { "cleanup.sh":
    command => "$cron_dir/cleanup.sh $stale_time /usr/local/doubleclick/logs/archive/processed",
    user    => dclk,
    hour    => 05,
    minute  => 00,
    ensure => absent,
  }

}
