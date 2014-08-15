user { 'elvis':
  ensure => present,
  home => '/home/elvis',
  gid => 'elvis',
  shell => '/bin/bash',
  managehome => true,
}
group { 'elvis': ensure => present }
