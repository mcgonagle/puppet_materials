if $server != 'foo' {
  file { '/etc/foo': ensure => absent }
} else {
  file { '/etc/foo': ensure => present }
}
