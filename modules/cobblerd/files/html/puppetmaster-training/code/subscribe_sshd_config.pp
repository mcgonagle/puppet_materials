file { '/etc/ssh/sshd_config':
  ensure => present,
  source => '/etc/puppet/files/sshd_config',
}
service { 'sshd':
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  ensure     => 'running',
  subscribe  => File['/etc/ssh/sshd_config'],
}
