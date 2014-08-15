class cron::http_integrity_check inherits cron {
   cron { "http_integrity":
     command => "/usr/bin/wget `/bin/hostname` -O /tmp/last_http_request",
     user    => care,
     minute  => "*/2",
     ensure  => present,
   }
}
