service { 'sshd':
  enable     => true,
  ensure     => running,
  hasstatus  => true,
  hasrestart => true,
}
