user { 'elvis':
  ensure     => present,
  home       => '/home/elvis',
  managehome => true,
  uid        => '5000',
  gid        => 'hounddog',
  shell      => '/bin/bash',
  # not required!
  require    => Group['hounddog'],
}
group { 'hounddog':
   ensure => present,
   gid    => '5000',
}
