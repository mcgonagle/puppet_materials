class scope {
  $somecontent = 'Content in /tmp/foo'
  file { '/tmp/foo': content => $somecontent}
  $somecontent = 'Content in /tmp/baz'
  file { '/tmp/baz': content => $somecontent, }
}
