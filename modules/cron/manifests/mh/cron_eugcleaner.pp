class cron::cron_eugcleaner inherits cron {

  manhunt_cron_item { "eugcleaner.sh":
    user    => care,
    hour    => 06,
    minute  => 10,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => present,
  }
}
