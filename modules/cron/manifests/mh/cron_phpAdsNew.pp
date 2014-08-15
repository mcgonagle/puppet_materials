class cron::cron_phpAdsNew inherits cron {
  cron { "phpAdsNew":
    ensure => present,
    command => "/usr/bin/php  /usr/local/src/manhunt/htdocs/phpAdsNew/maintenance/maintenance.php >> /tmp/PHP-ADS-DEBUG",
    user    => root,
    minute  => 0,
    hour    => $hostname ? {
      #     admin01 => '1-23/2',
      admin01 => '1',
      admin02 => '*/2',
      admin2 => '*/2',
      default => '*/2',
    }
  }
  # TBD: gets a validation error

}
