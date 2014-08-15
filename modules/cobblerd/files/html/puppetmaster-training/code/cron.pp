cron { 'logrotate':
  command => '/usr/sbin/logrotate',
  user    => root,
  hour    => 2,
  minute  => 0,
}
