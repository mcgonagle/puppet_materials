if $foo {
  file { '/etc/foo': ensure => present }
} else {
  file { '/etc/foo': ensure => absent }
}
