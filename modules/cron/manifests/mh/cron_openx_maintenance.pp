class cron::cron_openx_maintenance inherits cron {
  cron { openx_maintenance:
    command => "/usr/bin/php /var/www/html/openx/scripts/maintenance/maintenance.php mh2.manhunt.net | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => apache,
    hour    => '*/1',
    minute  => 0,
    ensure => present,
  }
}
