file { '/tmp/testfile':
  source => '/tmp/src/testfile',
}

file { '/tmp/testlink':
  ensure => symlink,
  target => '/tmp/testfile',
}
