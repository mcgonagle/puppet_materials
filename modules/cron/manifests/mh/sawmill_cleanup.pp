class cron::sawmill_cleanup inherits cron {

   cron { "cron_sawmill_cleanup":
     command => "find /data01/www -mtime +90 -delete",
     user    => logs,
     hour    => "03",
     minute  => "00",
     ensure  => present,
   }
}
