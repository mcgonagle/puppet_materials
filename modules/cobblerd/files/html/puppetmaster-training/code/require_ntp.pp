package { 'ntp': ensure => present }
file { '/etc/ntp.conf':
  owner => 'root',
  group => 'root',
  mode  => '0644',
  source => '/etc/puppet/files/ntp/ntp.conf',
  require => Package['ntp'],
}
