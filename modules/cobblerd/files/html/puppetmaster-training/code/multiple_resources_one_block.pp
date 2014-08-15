File { owner => 'root', group => 'root', mode => '0644' }
file {
  '/etc/foo.d': ensure => directory;
  '/etc/foo.d/bar.conf': content => 'This file is foobar';
}
