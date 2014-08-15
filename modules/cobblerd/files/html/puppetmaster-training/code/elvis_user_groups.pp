user { 'elvis':
  ensure => 'present',
  home   => '/home/elvis',
  uid    => '5000',
  gid    => 'hounddog',
  shell  => '/bin/bash',
  groups => ['jailhouse', 'surfer', 'legend'],
}
