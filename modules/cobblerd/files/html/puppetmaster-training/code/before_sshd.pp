package { 'openssh-server':
  ensure => present,
  before => Service['sshd'],
}
service { 'sshd':
  enable => true,
  ensure => running,
}
