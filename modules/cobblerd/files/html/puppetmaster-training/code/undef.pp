class foo {
  file{ "/tmp/foobar": source => "puppet:///modules/foo/foobar" }
}

class foo::bar inherits foo {
  File["/tmp/foobar"] { source => undef, content => "some foobar text" }
}
