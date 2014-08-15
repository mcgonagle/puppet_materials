file{'/etc/sudoers':
  source => '/etc/puppet/files/sudoers',
  owner  => 'root',
  group  => 'root',
  mode   => '400',
}
