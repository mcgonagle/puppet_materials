File { owner => 'root', group => 'root', mode => '0644' }
file { '/etc/foo.d':
  ensure => directory,
}
file { '/etc/foo.d/bar.conf':
  content => 'This file configures the foobar',
}
