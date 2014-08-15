$somecontent = 'top'
class one {
  file { '/tmp/foo': content => $somecontent, }
}
class two {
  $somecontent = 'beta'
  include one
  file { '/tmp/baz': content => $somecontent, }
}
include two
