class foo {
  package { "foo": ensure => present }
  service { "foo": ensure => true, require => Package["foo"] }
}

class foo::bar inherits foo {
  package { "bar": ensure => present }
  Service["foo"] { require +> Package["bar"] }
}
