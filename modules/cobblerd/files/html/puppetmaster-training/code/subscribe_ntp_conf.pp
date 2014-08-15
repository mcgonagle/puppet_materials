package { 'ntp': ensure => present }
file { '/etc/ntp.conf':
  owner   => 'root',
  group   => 'root',
  mode    => '644',
  source  => '/etc/puppet/files/ntp/ntp.conf',
  require => Package['ntp'],
}
service { 'ntpd':
  enable    => true,
  ensure    => running,
  subscribe => File['/etc/ntp.conf'],
}
