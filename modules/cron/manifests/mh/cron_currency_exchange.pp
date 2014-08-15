class cron::cron_currency_exchange inherits cron {
  cron { xe_xml:  ## This is a unique identifier.
    ensure => present,
    command => "ruby /usr/local/bin/xe_whatever",
    user    => care,
    hour    => 1,
    minute  => 30,
  }
}
