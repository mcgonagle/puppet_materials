class cron::cron_importExchangeRates inherits cron {
  manhunt_cron_item { "ImportExchangeRates.sh":
    user    => care,
    hour    => 03,
    minute  => 00,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => present,
  }

}
