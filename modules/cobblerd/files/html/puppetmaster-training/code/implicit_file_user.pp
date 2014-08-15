user { 'elvis':
  ensure     => present,
  home       => '/home/foo',
  managehome => true,
  uid        => '5000',
  gid        => 'hounddog',
  shell      => '/bin/bash',
}
group { 'hounddog':
   ensure => 'present',
   gid    => '5000',
}
file { '/etc/graceland':
  owner   => 'elvis',
  group   => 'hounddog',
  mode    => '755',
  content => 'Graceland is a happy home.',
}
