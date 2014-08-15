class cron::tablecheck inherits cron {
  manhunt_cron_item { "tablecheck.sh":
    user    => care,
    minute  => 17,
    require => File [ "/etc/$orgname/source.sh" ],
  }
}
