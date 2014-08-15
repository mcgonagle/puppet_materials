class foo {
  file { "foo1": content => "foo_1", }
  file { "foo2": content => "foo_2", }
  file { "foo3": content => "foo_3", }
} # class foo

class bar {
  service { "bar":
    ensure => true,
    require => Class["foo"],
  } # service
} # class bar
