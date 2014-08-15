class parent  {
  $somecontent = 'Parent'
  file { '/tmp/foo': content => $parent::somecontent }
}
class child inherits parent {
  $somecontent = 'Child'
  file { '/tmp/baz': content => $child::somecontent }
}
