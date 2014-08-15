file { 'sudoers':
  path   => '/etc/sudoers',
  source => '/etc/puppet/files/sudoers',
  ensure => present,
}
