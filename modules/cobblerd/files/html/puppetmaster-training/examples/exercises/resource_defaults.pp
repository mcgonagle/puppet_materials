File{owner => 'root', group => 'root', mode => '644'}
file{
  '/tmp/defaults': ensure => directory;
  '/tmp/defaults/hello': content => 'hello';
  '/tmp/defaults/goodbye':content => 'goodbye';
}
