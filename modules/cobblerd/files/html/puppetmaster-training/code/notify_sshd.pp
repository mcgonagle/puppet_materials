file { '/etc/ssh/sshd_config':
  ensure => present,
  source => '/etc/puppet/files/sshd_config',
  notify => Service['sshd'],
}
service { 'sshd':
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  ensure     => running,
}
