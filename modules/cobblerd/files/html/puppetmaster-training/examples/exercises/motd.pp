file{'/etc/motd':
  owner => 'root',
  group => 'root',
  mode  => '0664',
  content => template('/etc/puppet/templates/motd.erb'),
}