user { 'elvis':
  ensure     => present,
  home       => '/home/elvis',
  managehome => true,
  uid        => '5000',
  gid        => 'hounddog',
  shell      => '/bin/bash',
}
group { 'hounddog':
   ensure => present,
   gid    => '5000',
}
