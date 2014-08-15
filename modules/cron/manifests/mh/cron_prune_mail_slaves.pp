class cron::cron_importExchangeRates inherits cron {
  $ensure = "present"
  manhunt_cron_item { "prune_mail_slave.sh":
    user    => care,
    hour    => 4,
    minute  => 0,
    opts    => mailshard01b,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => $ensure,
  }
  manhunt_cron_item { "prune_mail_slave2.sh":
    user    => care,
    hour    => 4,
    minute  => 0,
    opts    => mailshard02,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => $ensure,
  }
  manhunt_cron_item { "prune_mail_slave3.sh":
    user    => care,
    hour    => 4,
    minute  => 0,
    opts    => mailshard03b,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => $ensure,
  }
  manhunt_cron_item { "prune_mail_slave4.sh":
    user    => care,
    hour    => 4,
    minute  => 0,
    opts    => mailshard04b,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => $ensure,
  }
}
