file { '/etc/foo.d':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}
file { '/etc/foo.d/bar.conf':
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => 'This file configures the foobar',
}
