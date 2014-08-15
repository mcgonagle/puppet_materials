class parent  {
  $somecontent = 'Parent'
  file { '/tmp/foo': content => $somecontent }
}
class child inherits parent {
  $somecontent = 'child is scope two'
  file { '/tmp/baz': content => $somecontent }
}
