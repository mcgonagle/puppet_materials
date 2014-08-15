include inet
inet::service { 'talk':
  sock_type => 'dgram',
  proto     => 'udp',
  user      => 'nobody.tty',
  path      => '/usr/sbin/in.talkd',
  args      => 'in.talkd',
}
