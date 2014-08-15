class cron::mh::http_integrity_check {
   cron { "http_integrity":
     command => "/usr/bin/wget `/bin/hostname` -O /tmp/last_http_request",
     user    => care,
     minute  => "*/2",
     ensure  => present,
   }
}
