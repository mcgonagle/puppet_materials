host {'localhost.localdomain':
  ensure => 'present',
  alias  => ['localhost'],
  target => '/etc/hosts',
  ip     => '127.0.0.1'
}
host {'localhost6.localdomain6':
  ensure => 'present',
  target => '/etc/hosts',
  ip     => '::1',
  alias  => ['localhost6']
}
resources {'host':
  # move the file to host
  purge => true,
}
