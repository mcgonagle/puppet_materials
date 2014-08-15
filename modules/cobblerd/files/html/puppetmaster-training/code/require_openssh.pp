package { 'openssh':
  ensure => present,
}
service { 'sshd':
  enable  => true,
  ensure  => running,
  require => Package['openssh'],
}
