file { '/etc/sudoers':
  ensure => file,
  group  => 'root',
  owner  => 'root',
  mode   => '440',
  source => '/etc/puppet/files/sudoers',
}
