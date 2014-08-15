package {'sshd':
  name   => 'openssh-server',
  ensure => installed,
} # package

file {'/etc/ssh/sshd_config':
  source  => '/etc/puppet/files/sshd_config',
  owner   => 'root',
  group   => 'root',
  mode    => '640',
  notify  => Service['sshd'],
  require => Package['sshd'],
} # file

service {'sshd':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
#  this works too 
#  subscribe => File['/etc/ssh/sshd_config'],
} # service
