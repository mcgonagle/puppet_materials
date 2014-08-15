class cron::cron_updatecount inherits cron {
  manhunt_cron_file { "updatecount.php":
    script_name => "updatecount.php",
  }
  cron { "updatecount.php":
    ensure => present,
    command => "/usr/bin/php $cron_dir/updatecount.php > /var/tmp/updatecount.log",
    user    => apache,
    minute  => $hostname ? {
      #TBD          admin01 => '*/10',
      #TBD          admin02 => '5-55/10',
      admin01 => '2',
      admin02 => '*/5',
      admin2 => '*/5',
      default => '*/5',
    }
  }
}
