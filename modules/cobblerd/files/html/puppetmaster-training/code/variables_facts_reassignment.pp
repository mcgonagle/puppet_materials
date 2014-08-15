File { owner => 'root', group => 'root', mode => '0644' }

$foo_dir = '/etc/foobar'

file {
  $foo_dir: ensure => 'directory';
  "${foo_dir}/bar.conf":
    content => "Configuring the ${foo_dir}/bar.conf for ${hostname}";
}

$foo_dir = '/etc/foobaz'

file {
  $foo_dir: ensure => 'directory';
  "${foo_dir}/baz.conf":
    content => "Configuring the ${foo_dir}/baz.conf for ${hostname}";
}
