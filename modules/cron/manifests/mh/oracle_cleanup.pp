class cron::oracle_cleanup inherits cron {

  $stale_time = 7

  cron { "cleanup.sh":
    command => "$cron_dir/cleanup.sh $stale_time /var/backup/oracle/dartdb01",
    user    => dclk,
    hour    => 05,
    minute  => 00,
    ensure => absent,
  }

}
