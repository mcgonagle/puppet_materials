service { 'syslog':
  enable  => true,
  ensure  => running,
  require => [ File['/etc/rsyslog.conf'], Package['rsyslog'] ],
}
