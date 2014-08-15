$somecontent = 'top'
class one {
  file { '/tmp/foo': content => $somecontent, }
}
class two {
  include one
  $somecontent = 'beta'
  file { '/tmp/baz': content => $somecontent, }
}
include two
