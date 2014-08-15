class cron::cron_pushlogs inherits cron {
  manhunt_cron_file { apcstaggercache:
    script_name => "apcstaggercache.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }
}
