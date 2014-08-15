class role {
  define servertype ($myrole) {
    file { '/tmp/role': content => $myrole, }
    notice("Setting role to ${myrole}")
  }
}
role::servertype { 'foo': myrole => 'fooserver' }
