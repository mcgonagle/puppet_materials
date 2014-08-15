$foo_dir = '/etc/foo.d'
File { owner => 'root', group => 'root', mode => '0644' }
file {
  $foo_dir: ensure => directory;
  "${foo_dir}/bar.conf":
     content => "Configuring the ${foo_dir}/bar.conf for ${hostname}",
     mode => '0644';
}
