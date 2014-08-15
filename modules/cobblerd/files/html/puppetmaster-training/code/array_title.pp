file{['/tmp/one', '/tmp/one/two', '/tmp/one/two/three']:
  mode   => '0750',
  owner  => 'root',
  group  => 'root',
  ensure => directory,
}
