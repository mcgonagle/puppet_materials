user { 'elvis-presley':
  name   => 'elvis',
  ensure => present,
  gid    => 'sysadmin',
}
